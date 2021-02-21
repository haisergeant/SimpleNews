//
//  CachServiceTests.swift
//
//  Created by Hai Le Thanh.
//  Copyright © 2020 Hai Le. All rights reserved.
//
	

import XCTest
@testable import SimpleNews

class CachServiceTests: XCTestCase {
    
    let cacheService = CacheService.shared

    override func setUp() {
        cacheService.clearCache()
    }

    func testCacheSmallData() {
        cacheService.cache(value: 5,
                           for: "key",
                           for: 5)
        let expectation = self.expectation(description: "Test value within the cache interval")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let value = self.cacheService.cacheValue(for: "key") as! Int
            XCTAssertTrue(value == 5)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCacheSmallDataAndTryToAccessAfterInterval() {
        cacheService.cache(value: 5,
                           for: "key",
                           for: 1)
        let expectation = self.expectation(description: "Test value over the cache interval")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let value = self.cacheService.cacheValue(for: "key")
            XCTAssertTrue(value == nil)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
