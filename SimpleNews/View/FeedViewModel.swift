//
//  FeedViewModel.swift
//
//  Created by Hai Le Thanh.
//  
//

import Foundation

protocol FeedViewModelProtocol: BaseViewModelProtocol {
    func numberOfRows() -> Int
    func cellViewModel(at index: Int) -> BaseViewModel?
    func requestDataForCellIfNeeded(at index: Int)
    func stopRequestDataForCell(at index: Int)
    func clearDataForCell(at index: Int)
}

class FeedViewModel {
    private weak var view: FeedViewProtocol?
    private var rowItems = [Article]()
    private var articleImages = [ArticleImage?]()
    private var viewModels = [ContentCellViewModel]()
    
    private let service: WebService
    private let imageService: ImageServiceProtocol
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, yyyy"
        return formatter
    }()
    
    init(service: WebService, imageService: ImageServiceProtocol) {
        self.service = service
        self.imageService = imageService
    }
}

extension FeedViewModel: FeedViewModelProtocol {
    func bind(to view: BaseViewProtocol) {
        guard let view = view as? FeedViewProtocol else { return }
        self.view = view
    }
    
    func requestData() {
        service.requestNews { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let feed):
                self.rowItems = feed.assets
                self.viewModels = self.rowItems.compactMap { item -> ContentCellViewModel in
                    
                    let minSizeImage = item.relatedImages.min { (image1, image2) -> Bool in
                        image1.height * image1.width < image2.height * image2.width
                    }
                    
                    self.articleImages.append(minSizeImage)
                    
                    return ContentCellViewModel(imageState: Observable<ImageState>(minSizeImage != nil ? .loading : .none),
                                                topTitle: item.headline,
                                                title: item.theAbstract,
                                                subtitle: item.byLine,
                                                dateString: self.dateFormatter.string(from: Date(timeIntervalSince1970: item.timeStamp)))
                }
                DispatchQueue.main.async {                    
                    self.view?.configure(with: self)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.view?.handleError(error)
                }
            }
        }
    }
    
    func numberOfRows() -> Int {
        viewModels.count
    }
    
    func cellViewModel(at index: Int) -> BaseViewModel? {
        viewModels[safe: index]
    }
    
    func requestDataForCellIfNeeded(at index: Int) {
        guard let imageObject = articleImages[safe: index],
              let object = imageObject,
              let url = URL(string: object.url),
              let cellViewModel = viewModels[safe: index],
              cellViewModel.imageState.value == .loading else { return }
        imageService.downloadImage(at: url) { result in
            switch result {
            case .success(let image):
                cellViewModel.imageState.value = .loadedImage(image: image)
            case .failure(_):
                cellViewModel.imageState.value = .fail
            }
        }
    }
    
    func stopRequestDataForCell(at index: Int) {
        guard let imageObject = articleImages[safe: index],
              let object = imageObject,
              let url = URL(string: object.url) else { return }
        imageService.cancelDownloadImage(at: url)
    }
    
    func clearDataForCell(at index: Int) {
        
    }
}
