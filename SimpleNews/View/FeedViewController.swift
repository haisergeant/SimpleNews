//
//  FeedViewController.swift
//
//  Created by Hai Le Thanh.
//  
//
	

import UIKit

protocol FeedViewProtocol: class, BaseViewProtocol {
    
}

protocol FeedViewControllerDelegate: class {
    func feedViewController(_ controller: FeedViewController, didSelect object: Any)
}

final class FeedViewController: UIViewController {
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout
        )
        collectionView.backgroundColor = .white
        collectionView.contentInset = .zero
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ContentCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let viewModel: FeedViewModelProtocol
    weak var delegate: FeedViewControllerDelegate?
    
    private lazy var tempCell = ContentCell()
    
    init(viewModel: FeedViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        viewModel.bind(to: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        
        collectionView.disableTranslatesAutoResizing()
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullRefreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        refreshData(forceLoad: true)
    }
    
    @objc private func pullRefreshData() {
        refreshData(forceLoad: true)
    }
    
    private func refreshData(forceLoad: Bool) {
        collectionView.refreshControl?.beginRefreshing()
        viewModel.requestData(forceLoad: forceLoad)
    }
}

extension FeedViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ContentCell = collectionView.dequeueReuseableCell(indexPath: indexPath)
        if let cellViewModel = viewModel.cellViewModel(at: indexPath.row) {
            cell.configure(with: cellViewModel)
            cell.style()
            
            cell.animate(with: Double(indexPath.row) * 0.3)
            viewModel.requestDataForCellIfNeeded(at: indexPath.row)
        }
        return cell
    }
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let article = viewModel.model(at: indexPath.row) else { return }
        delegate?.feedViewController(self, didSelect: article)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.stopRequestDataForCell(at: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cellViewModel = viewModel.cellViewModel(at: indexPath.row) else { return .zero }
        
        tempCell.configure(with: cellViewModel)
        tempCell.style()
        let size = tempCell.systemLayoutSizeFitting(CGSize(width: collectionView.bounds.width, height: 1),
                                                    withHorizontalFittingPriority: .required,
                                                    verticalFittingPriority: .fittingSizeLevel)
        
        return CGSize(width: size.width, height: ceil(size.height) + 1)
    }
}

extension FeedViewController: FeedViewProtocol {
    func configure(with viewModel: BaseViewModelProtocol) {
        collectionView.refreshControl?.endRefreshing()
        collectionView.reloadData()
    }
    
    func handleError(_ error: Error) {
        collectionView.refreshControl?.endRefreshing()
        showAlert(title: "Error",
                  message: (error as? ErrorDisplayable)?.errorMessage ?? error.localizedDescription,
                  primaryButtonTitle: "OK",
                  primaryAction: {})
    }
}
