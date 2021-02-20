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
    }
}
