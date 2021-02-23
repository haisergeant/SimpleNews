//
//  FeedViewControllerUITests.swift
//
//  Created by Hai Le Thanh.
//  
//
	

import XCTest

class FeedViewControllerUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    /**
     Test navigation from first screen to webViewController, and going back to first screen
     */
    func testCollectionViewLoadData() throws {
        let app = XCUIApplication()
        app.launch()
        let collectionViewsQuery = app.collectionViews
        let element = collectionViewsQuery.children(matching: .cell).element(boundBy: 0)
        expectation(for: .init(format: "exists == true"), evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }

    /**
     Test navigation from first screen to webViewController, and going back to first screen
     */
    func testNavigation() throws {
        let app = XCUIApplication()
        app.launch()
        
        let collectionViewsQuery = app.collectionViews
        var element = collectionViewsQuery.children(matching: .cell).element(boundBy: 0)
        element.tap()
        
        let webViewsQuery = app.webViews.webViews.webViews
        let bannerElement = webViewsQuery/*@START_MENU_TOKEN@*/.otherElements["banner"]/*[[".otherElements.matching(identifier: \"ASX dividends to hit $73b as it rains upgrades\").otherElements[\"banner\"]",".otherElements[\"banner\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        
        expectation(for: .init(format: "exists == true"), evaluatedWith: bannerElement, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        let backButton = app.navigationBars["SimpleNews.WebView"].buttons["Back"]
        backButton.tap()
        
        element = collectionViewsQuery.children(matching: .cell).element(boundBy: 1)
        expectation(for: .init(format: "exists == true"), evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
}
