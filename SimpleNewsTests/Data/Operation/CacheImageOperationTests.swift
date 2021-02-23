//
//  CacheImageOperationTests.swift
//
//  Created by Hai Le Thanh.
//

import XCTest

@testable import SimpleNews

class CacheImageOperationTests: XCTestCase {
    
    let queue = OperationQueue()
    
    override func setUp() {
        queue.cancelAllOperations()
        
        let cacheDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                                 .userDomainMask,
                                                                 true).first!
        let downloadFolder = cacheDirectory + "/" + "Download"
        try? FileManager.default.removeItem(atPath: downloadFolder)
    }

    /**
     Test download image successfully from URL (using MockURLSession)
     */
    func testImageDownloadSuccess() {
        let session = MockURLSession()
        let bundle = Bundle(for: CacheImageOperationTests.self)
        let imageData = UIImage(named: "tick", in: bundle, compatibleWith: nil)?.pngData()
        let imageJPGData = UIImage(named: "tick", in: bundle, compatibleWith: nil)?.jpegData(compressionQuality: 1)
        session.data = imageData
        
        let fileManager = MockFileManager(fileExist: false)
        let urlString = "https://www.fairfaxstatic.com.au/content/dam/images/h/1/c/r/m/h/image.imgtype.afrWoodcutAuthorImage.140x140.png/1553477420914.png"
        let url = URL(string: urlString)!
        
        let expectation = self.expectation(description: "Calling API which returns image")
        let operation = CacheImageOperation(url: url,
                                            urlSession: session,
                                            fileManager: fileManager)
        operation.completionHandler = { result in
            XCTAssertTrue(operation.isFinished, "Operation must be finished")
            XCTAssert(session.lastURLRequest?.url?.absoluteString == urlString, "URL should be \(urlString)")
            XCTAssert(session.nextDataTask.resumeWasCalled, "Data task should be called")
            
            if case .success(let image) = result {
                XCTAssert(image.size == UIImage(data: imageJPGData!)!.size, "The loaded image should be `tick` image")
                expectation.fulfill()
            } else if case .failure = result {
                XCTAssertFalse(true, "API should be success")
            }
        }
        
        queue.addOperation(operation)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    /**
     Test download image fail because invalid image link
     */
    func testImageDownloadFail() {
        let session = MockURLSession()
        session.error = APIError.invalidImageLink
        
        let fileManager = MockFileManager(fileExist: false)
        let urlString = "https://www.fairfaxstatic.com.au/content/dam/images/h/1/c/r/m/h/image.imgtype.afrWoodcutAuthorImage.140x140.png/1553477420914.png"
        let url = URL(string: urlString)!
        
        let expectation = self.expectation(description: "Calling API returns error")
        let operation = CacheImageOperation(url: url, urlSession: session, fileManager: fileManager)
        operation.completionHandler = { result in
            XCTAssertTrue(operation.isFinished, "Operation must be finished")
            XCTAssert(session.lastURLRequest?.url?.absoluteString == urlString, "URL should be \(urlString)")
            XCTAssert(session.nextDataTask.resumeWasCalled, "Data task should be called")
            
            if case .success = result {
                XCTAssertFalse(true, "API should be fail")
            } else if case .failure(let error) = result {
                XCTAssertEqual(error as? APIError, APIError.invalidImageLink)
                expectation.fulfill()
            }
        }
        
        queue.addOperation(operation)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    /**
     Test retrieve image from cached file system fail
     */
    func testImageGetFromFileSystemFail() {
        let session = MockURLSession()
        
        let fileManager = MockFileManager(fileExist: true)
        let urlString = "https://www.fairfaxstatic.com.au/content/dam/images/h/1/c/r/m/h/image.imgtype.afrWoodcutAuthorImage.140x140.png/1553477420914.png"
        let url = URL(string: urlString)!
        
        let expectation = self.expectation(description: "Get image from file system but fail")
        let operation = CacheImageOperation(url: url, urlSession: session, fileManager: fileManager)
        operation.completionHandler = { result in
            XCTAssertTrue(operation.isFinished, "Operation must be finished")
            XCTAssert(session.lastURLRequest == nil, "Get file from file system, should not call URL")
            XCTAssert(!session.nextDataTask.resumeWasCalled, "Data task should not be called")
            
            if case .success = result {
                XCTAssertFalse(true, "API should be fail")
            } else if case .failure(let error) = result {
                XCTAssertEqual(error as? APIError, APIError.invalidImageLink)
                expectation.fulfill()
            }
        }
        
        queue.addOperation(operation)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    /**
     Test retrieve image from cached file system success
     */
    func testImageGetFromFileSystemSuccess() {
        // create the image file in file system
        let bundle = Bundle(for: CacheImageOperationTests.self)
        let imageData = UIImage(named: "tick", in: bundle, compatibleWith: nil)!.pngData()!
        let urlString = "https://www.fairfaxstatic.com.au/content/dam/images/h/1/c/r/m/h/image.imgtype.afrWoodcutAuthorImage.140x140.png/tick.png"
        let url = URL(string: urlString)!
        let cacheDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                                 .userDomainMask,
                                                                 true).first!
        let downloadFolder = cacheDirectory + "/" + "Download"
        
        let filePath = downloadFolder + "/" + FileNameHelper.fileName(for: urlString)!
        do {
            try FileManager.default.createDirectory(atPath: downloadFolder,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
            let url = URL(fileURLWithPath: filePath)
            try imageData.write(to: url)
        } catch {
            print("cannot write the image to file")
        }
        
        // begin the test
        let session = MockURLSession()
        
        let fileManager = MockFileManager(fileExist: true)
        
        
        let expectation = self.expectation(description: "Get image from file system")
        let operation = CacheImageOperation(url: url, urlSession: session, fileManager: fileManager)
        operation.completionHandler = { result in
            XCTAssertTrue(operation.isFinished, "Operation must be finished")
            XCTAssert(session.lastURLRequest == nil, "Get file from file system, should not call URL")
            XCTAssert(!session.nextDataTask.resumeWasCalled, "Data task should not be called")
            
            if case .success(let image) = result {
                XCTAssertEqual(image.pngData(), imageData)
                expectation.fulfill()
            } else if case .failure = result {
                XCTAssertFalse(true, "API should be success")
            }
        }
        
        queue.addOperation(operation)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
}
