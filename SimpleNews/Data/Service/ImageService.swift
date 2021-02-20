//
//  ImageService.swift
//
//  Created by Hai Le Thanh.
//  
//
	
import UIKit

protocol ImageServiceProtocol {
    func downloadImage(at url: URL, completionHandler: @escaping ((Result<UIImage, Error>) -> Void))
    func cancelDownloadImage(at url: URL)
}

class ImageService {
    private var imageOperations: [String: Operation] = [:]
    private let queueManager: QueueManager
    private let session: URLSessionProtocol
    
    init(queueManager: QueueManager = .shared,
         session: URLSessionProtocol = URLSession.shared) {
        self.queueManager = queueManager
        self.session = session
    }
}
extension ImageService: ImageServiceProtocol {    
    func downloadImage(at url: URL, completionHandler: @escaping ((Result<UIImage, Error>) -> Void)) {
        let operation = CacheImageOperation(url: url, urlSession: session)
        operation.completionHandler = { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                completionHandler(result)
                self.imageOperations.removeValue(forKey: url.absoluteString)
            }
        }
        queueManager.queue(operation)
        imageOperations[url.absoluteString] = operation
    }
    
    func cancelDownloadImage(at url: URL) {
        guard let operation = imageOperations[url.absoluteString] else { return }
        operation.cancel()
        imageOperations.removeValue(forKey: url.absoluteString)
    }
}
