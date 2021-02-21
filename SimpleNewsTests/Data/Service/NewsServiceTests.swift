//
//  NewsServiceTests.swift
//
//  Created by Hai Le Thanh.
//  Copyright © 2020 Hai Le. All rights reserved.
//


import XCTest
@testable import SimpleNews

class NewsServiceTests: XCTestCase {
    private let queueManager = QueueManager.shared
    private let session = MockURLSession()
    
    override func setUp() {
        queueManager.cancelAllOperations()
        session.data = nil
        session.error = nil
    }
    
    func testRequestDataSuccess() {
        session.data = StubData.loadStubData(fileName: "home", ext: "json")
        let service = NewsService(queueManager: QueueManager.shared,
                                  session: session)
        
        let expectation = self.expectation(description: "Receive valid JSON")
        
        service.requestNews(forceLoad: true) { result in
            switch result {
            case .success(let feed):
                XCTAssertTrue(!feed.assets.isEmpty)
                expectation.fulfill()
            case .failure:
                XCTFail("Should receive valid response")
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testRequestDataFail() {
        session.data = StubData.loadStubData(fileName: "home-invalid", ext: "json")
        let service = NewsService(queueManager: QueueManager.shared,
                                  session: session)
        
        let expectation = self.expectation(description: "Receive invalid JSON")
        service.requestNews(forceLoad: true) { result in
            switch result {
            case .success:
                XCTFail("Should receive invalid response")
            case .failure(let error):
                if case APIError.jsonFormatError = error {
                    XCTAssertTrue(true)
                } else {
                    XCTFail("Should return invalid JSON")
                }
                
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }
}
