//
//  MockURLSession.swift
//
//  Created by Hai Le Thanh.
//

import Foundation
import UIKit
@testable import SimpleNews

class MockURLSession: URLSessionProtocol {
    var nextDataTask = MockURLSessionDataTask()
    private (set) var lastURLRequest: URLRequest?
    var data: Data?
    var error: Error?
    
    func successHttpURLResponse(_ url: URL) -> URLResponse {
        return HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        lastURLRequest = request
        DispatchQueue.global().async {
            completionHandler(self.data, self.successHttpURLResponse(request.url!), self.error)
        }
        return nextDataTask
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    private (set) var cancelWasCalled = false
    func resume() {
        resumeWasCalled = true
    }
    
    func cancel() {
        cancelWasCalled = true
    }
}
