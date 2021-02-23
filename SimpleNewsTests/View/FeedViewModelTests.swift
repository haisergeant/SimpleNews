//
//  FeedViewModelTests.swift
//
//  Created by Hai Le Thanh.
//  Copyright © 2020 Hai Le. All rights reserved.
//
	

import XCTest
@testable import SimpleNews

class MockFeedView: FeedViewProtocol {
    var viewModel: FeedViewModelProtocol? = nil
    var didFetchDataCalled = false
    var displayErrorCalled = false
    var completion: (() -> Void)?
    
    func configure(with viewModel: BaseViewModelProtocol) {
        didFetchDataCalled = true
        completion?()
    }
    
    func handleError(_ error: Error) {
        displayErrorCalled = true
        completion?()
    }
}

class MockImageService: ImageServiceProtocol {
    func downloadImage(at url: URL, completionHandler: @escaping ((Result<UIImage, Error>) -> Void)) {
        
    }
    
    func cancelDownloadImage(at url: URL) {
        
    }
}

class FeedViewModelTests: XCTestCase {
    var session: MockURLSession = MockURLSession()
    var service: WebService!
    var imageService: ImageServiceProtocol = MockImageService()
    var view: MockFeedView = MockFeedView()
    var viewModel: FeedViewModel!    
    
    override func setUp() {
        service = LocalMockService(session: session)
        viewModel = FeedViewModel(service: service, imageService: imageService)
        
        viewModel.bind(to: view)
        
    }
    
    /**
     Fetch data from stub file home.json success
     */
    func testViewModelFetchDataSuccess() {
        session.data = StubData.loadStubData(fileName: "home", ext: "json")
        
        let expectation = self.expectation(description: "Request data successfully")
        viewModel.requestData(forceLoad: true)
        view.completion = {
            XCTAssertTrue(self.view.didFetchDataCalled)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    /**
     Test viewModel request data but has API error
     */
    func testViewModelFetchDataFail() {
        session.error = APIError.invalidAPIError
        
        let expectation = self.expectation(description: "Request data fail")
        viewModel.requestData(forceLoad: true)
        view.completion = {
            XCTAssertTrue(self.view.displayErrorCalled)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
