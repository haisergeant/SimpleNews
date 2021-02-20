//
//  LocalMockService.swift
//
//  Created by Hai Le Thanh.
//  
//
	

import Foundation

struct LocalMockEndpoints {
    enum EndPoint {
        case home
    }
    
    func fileName(for endPoint: EndPoint) -> URL? {
        switch endPoint {
        case .home:
            return fileUrl("home.json")
        }
    }
    
    private func fileUrl(_ fileName: String) -> URL? {
        Bundle(identifier: "com.haile.SimpleNewsTests")?.url(forResource: fileName, withExtension: nil)
    }
}

class LocalMockService: WebService {
    func requestNews(forceLoad: Bool, completionHandler: ((Result<Feed, Error>) -> Void)) {
        
    }
}
