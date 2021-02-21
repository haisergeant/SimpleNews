//
//  AppDelegate.swift
//
//  Created by Hai Le Thanh.
//  
//
	

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let coordinator = AppCoordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = coordinator.initialViewController
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

