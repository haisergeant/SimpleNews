//
//  FileManagerProtocol.swift
//
//  Created by Hai Le Thanh.
//

import Foundation

// MARK: - FileManagerProtocol
protocol FileManagerProtocol {
    func fileExists(atPath path: String) -> Bool
    func createDirectory(atPath path: String, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]?) throws
}

// MARK: - FileManager
extension FileManager: FileManagerProtocol {
    
}
