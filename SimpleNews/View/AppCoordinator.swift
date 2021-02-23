//
//  AppCoordinator.swift
//
//  Created by Hai Le Thanh.
//  
//
	
import UIKit

class AppCoordinator {
    var initialViewController: UIViewController
    
    init() {
        let service = ServiceFactory.webService(with: .api)
        
        let viewController = FeedViewController(viewModel: FeedViewModel(service: service, imageService: ImageService()))
        let navigationController = UINavigationController(rootViewController: viewController)
        self.initialViewController = navigationController
        viewController.delegate = self
    }
}

extension AppCoordinator: FeedViewControllerDelegate {
    func feedViewController(_ controller: FeedViewController, didSelect object: Any) {
        guard let article = object as? Article else { return }
        let viewController = WebViewController(urlString: article.url)
        controller.navigationController?.pushViewController(viewController, animated: true)
    }
}
