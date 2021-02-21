//
//  JSONDataRequestOperationTests.swift
//
//  Created by Hai Le Thanh.
//  Copyright © 2020 Hai Le Thanh. All rights reserved.
//

import XCTest
@testable import SimpleNews

class JSONDataRequestOperationTests: XCTestCase {
    let queue = OperationQueue()
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return dateFormatter
    }()
    
    override func setUp() {
        queue.cancelAllOperations()
    }
    
    func testAPIRequestSuccess() {
        let session = MockURLSession()
        session.data = StubData.loadStubData(fileName: "home", ext: "json")
        
        let url = URL(string: "www.google.com")!
        
        let expectation = self.expectation(description: "Calling API which returns correct format")
        let operation = JSONDataRequestOperation<Feed>(url: url,
                                                                   urlSession: session,
                                                                   forceLoad: true,
                                                                   cacheService: nil,
                                                                   dateFormatter: dateFormatter)
        operation.completionHandler = { result in
            XCTAssertTrue(operation.isFinished, "Operation must be finished")

            XCTAssert(session.lastURLRequest?.url?.absoluteString == "www.google.com", "URL should be www.google.com")
            XCTAssert(session.nextDataTask.resumeWasCalled, "Data task should be called")
            
            if case .success(let feed) = result {
                XCTAssertTrue(!feed.assets.isEmpty)
                expectation.fulfill()
            } else if case .failure = result {
                XCTAssertFalse(true, "API should be success")
            }
            
        }
        
        queue.addOperation(operation)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testAPIRequestReturnError() {
        let session = MockURLSession()
        session.error = APIError.invalidAPIError
        
        let url = URL(string: "www.google.com")!
        
        let expectation = self.expectation(description: "Calling API which returns error")
        let operation = JSONDataRequestOperation<Feed>(url: url,
                                                                   urlSession: session,
                                                                   forceLoad: true,
                                                                   cacheService: nil,
                                                                   dateFormatter: dateFormatter)
        operation.completionHandler = { result in
            XCTAssertTrue(operation.isFinished, "Operation must be finished")
            XCTAssert(session.lastURLRequest?.url?.absoluteString == "www.google.com", "URL should be www.google.com")
            XCTAssert(session.nextDataTask.resumeWasCalled, "Data task should be called")
            
            if case .success = result {
                XCTAssertFalse(true, "API should be fail")
                
            } else if case .failure(let error) = result {
                XCTAssertEqual(error as? APIError, APIError.invalidAPIError)
                expectation.fulfill()
            }
            
        }
        
        queue.addOperation(operation)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testAPIRequestReturnInvalidFormat() {
        let session = MockURLSession()
        session.data = StubData.loadStubData(fileName: "home-invalid", ext: "json")
        
        let url = URL(string: "www.google.com")!
        
        let expectation = self.expectation(description: "Calling API which returns invalid format")
        let operation = JSONDataRequestOperation<Feed>(url: url,
                                                                   urlSession: session,
                                                                   forceLoad: true,
                                                                   cacheService: nil,
                                                                   dateFormatter: dateFormatter)
        operation.completionHandler = { result in
            XCTAssertTrue(operation.isFinished, "Operation must be finished")
            XCTAssert(session.lastURLRequest?.url?.absoluteString == "www.google.com", "URL should be www.google.com")
            XCTAssert(session.nextDataTask.resumeWasCalled, "Data task should be called")
            
            if case .success = result {
                XCTAssertFalse(true, "API should be fail")
            } else if case .failure(let error) = result {
                XCTAssertEqual(error as? APIError, APIError.jsonFormatError)
                expectation.fulfill()
            }
            
        }
        
        queue.addOperation(operation)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testAPIRequestIntArray() {
        let session = MockURLSession()
        session.data = "[1,2,3,4,5]".data(using: .ascii)
        
        let url = URL(string: "www.google.com")!
        
        let expectation = self.expectation(description: "Calling API which returns Int array")
        let operation = JSONDataRequestOperation<[Int]>(url: url,
                                                        urlSession: session,
                                                        forceLoad: true,
                                                        cacheService: nil,
                                                        dateFormatter: dateFormatter)
        operation.completionHandler = { result in
            XCTAssertTrue(operation.isFinished, "Operation must be finished")
            if case .success(let values) = result {
                XCTAssertTrue(values.count == 5)
                expectation.fulfill()
            } else if case .failure = result {
                XCTAssertFalse(true, "API should be fail")
            }
        }
        
        queue.addOperation(operation)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
}
