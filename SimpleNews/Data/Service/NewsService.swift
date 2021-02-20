//
//  NewsService.swift
//
//  Created by Hai Le Thanh.
//  
//
	

import Foundation

struct NewsEndpoints {
    enum EndPoint {
        case home
    }
    
    func url(for endPoint: EndPoint) -> URL? {
        var urlString: String
        switch endPoint {
        case .home:
            urlString = "https://bruce-v2-mob.fairfaxmedia.com.au/1/coding_test/13ZZQX/full"
        }
        
        return URL(string: urlString)
    }
}

class NewsService: WebService {
    private let queueManager: QueueManager
    private let session: URLSessionProtocol
    private var currentOperation: Operation? = nil
    private let endPoint = NewsEndpoints()
    
    init(queueManager: QueueManager = .shared,
         session: URLSessionProtocol = URLSession.shared) {
        self.queueManager = queueManager
        self.session = session
    }
    
    func requestNews(forceLoad: Bool, completionHandler: @escaping ((Result<Feed, Error>) -> Void)) {
        guard let url = endPoint.url(for: .home) else {
            completionHandler(.failure(APIError.invalidAPIError))
            return
        }
        
        let operation = JSONDataRequestOperation<Feed>(url: url,
                                                       urlSession: session,
                                                       forceLoad: forceLoad)
        operation.completionHandler = { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let feed):
                    completionHandler(.success(feed))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
        queueManager.queue(operation)
        currentOperation = operation
    }
}
