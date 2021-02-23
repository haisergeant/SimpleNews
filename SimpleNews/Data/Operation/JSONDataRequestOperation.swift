//
//  JSONDataRequestOperation.swift
//
//  Created by Hai Le Thanh.
//

import Foundation

// MARK: - JSONDataRequestOperation
final class JSONDataRequestOperation<Element: Decodable>: BaseOperation<Element> {
    private let urlSession: URLSessionProtocol
    private let url: URL
    private let httpMethod: String
    private let body: Data?
    private let forceLoad: Bool
    private let cacheService: CacheServiceProtocol?
    private let dateFormatter: DateFormatter?
    private var dataTask: URLSessionDataTaskProtocol?
    
    
    init(url: URL,
         httpMethod: String = "GET",
         body: Data? = nil,
         urlSession: URLSessionProtocol = URLSession.shared,
         forceLoad: Bool = false,
         cacheService: CacheServiceProtocol? = CacheService.shared,
         dateFormatter: DateFormatter? = nil) {
        self.url = url
        self.body = body
        self.httpMethod = httpMethod
        self.urlSession = urlSession
        self.forceLoad = forceLoad
        self.cacheService = cacheService
        self.dateFormatter = dateFormatter
    }
    
    override func main() {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod
        urlRequest.httpBody = body
        
        if !forceLoad, let value = cacheService?.cacheValue(for: url.absoluteString) as? Data {
            do {
                try decodeData(value)
            } catch {
                self.complete(result: .failure(APIError.jsonFormatError))
            }
            return
        }
        
        #if !MOCK
        guard Reachability.isConnectedToNetwork() else {
            complete(result: .failure(APIError.noInternetConnection))
            return
        }
        #endif
        
        dataTask = urlSession.dataTask(with: urlRequest as URLRequest) { [weak self] (data, response, error) in
            guard let self = self else { return }
            do {
                if let error = error {
                    self.complete(result: .failure(error))
                } else if let data = data {
                    self.cacheService?.cache(value: data, for: self.url.absoluteString, for: 180)
                    try self.decodeData(data)
                }
            } catch {
                self.complete(result: .failure(APIError.jsonFormatError))
            }
        }
        
        dataTask?.resume()
    }
    
    private func decodeData(_ data: Data) throws {
        let decoder = JSONDecoder()
        if let dateFormatter = self.dateFormatter {
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
        }
        let result = try decoder.decode(Element.self, from: data)
        
        self.complete(result: .success(result))
    }
    
    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
}
