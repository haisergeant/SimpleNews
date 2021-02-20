//
//  ServiceFactory.swift
//
//  Created by Hai Le Thanh.
//  
//
	

import Foundation

enum ServiceType {
    case mock
    case api
}

struct ServiceFactory {
    static func webService(with type: ServiceType) -> WebService {
        switch type {
        case .mock:
            return LocalMockService()
        case .api:
            return NewsService()
        }
    }
}

protocol WebService {
    func requestNews(forceLoad: Bool, completionHandler: @escaping ((Result<Feed, Error>) -> Void))
}
