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
        Bundle(identifier: "com.haile.SimpleNews")?.url(forResource: fileName, withExtension: nil)
    }
}

class LocalMockService: WebService {
    private let queueManager: QueueManager
    private let session: URLSessionProtocol
    private var currentOperation: Operation? = nil
    private let endPoint = LocalMockEndpoints()
    
    init(queueManager: QueueManager = .shared,
         session: URLSessionProtocol = URLSession.shared) {
        self.queueManager = queueManager
        self.session = session
    }
    
    func requestNews(forceLoad: Bool, completionHandler: @escaping ((Result<Feed, Error>) -> Void)) {
        guard let url = endPoint.fileName(for: .home) else {
            completionHandler(.failure(APIError.invalidAPIError))
            return
        }
        
        let operation = JSONDataRequestOperation<Feed>(url: url,
                                                       urlSession: session,
                                                       cacheService: nil)
        operation.completionHandler = { result in
            completionHandler(result)
        }
        
        queueManager.queue(operation)
        
    }
}
