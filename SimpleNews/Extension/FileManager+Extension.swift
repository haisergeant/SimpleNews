//
//  FileManager+Extension.swift
//
//  Created by Hai Le Thanh.
//
	

import Foundation

extension FileManager {
    func deleteCachesSubfolder(folderName: String) {
        if let cacheDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
            let downloadDirectory = cacheDirectory + "/" + folderName
            if FileManager.default.fileExists(atPath: downloadDirectory) {
                try? FileManager.default.removeItem(atPath: downloadDirectory)
            }
        }
    }
}
