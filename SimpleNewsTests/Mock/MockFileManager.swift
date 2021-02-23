//
//  MockFileManager.swift
//
//  Created by Hai Le Thanh.
//

import Foundation
@testable import SimpleNews

class MockFileManager: FileManagerProtocol {
    let fileExist: Bool
    
    init(fileExist: Bool) {
        self.fileExist = fileExist
    }
    
    func fileExists(atPath path: String) -> Bool {
        return fileExist
    }
    
    func createDirectory(atPath path: String, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]?) throws {
        
    }
}
