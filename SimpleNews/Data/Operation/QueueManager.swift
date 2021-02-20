//
//  QueueManager.swift
//
//  Created by Hai Le.
//  Copyright © 2020 Hai Le. All rights reserved.
//

import Foundation

// MARK: - QueueManager
final class QueueManager {
    static let shared = QueueManager()
    
    private let queue = OperationQueue()
    
    init(maxConcurrentOperationCount: Int = 10) {
        queue.maxConcurrentOperationCount = maxConcurrentOperationCount
    }
    
    func queue(_ operation: Operation) {
        queue.addOperation(operation)
    }
    
    func cancelAllOperations() {
        queue.cancelAllOperations()
    }
    
    var isEmptyOperation: Bool {
        queue.operations.isEmpty
    }
    
    func pauseAllDownload() {
        if !queue.isSuspended {
            queue.isSuspended = true
        }
    }
    
    func resumeAllDownload() {
        if queue.isSuspended {
            queue.isSuspended = false
        }
    }
    
    var isSuspended: Bool {
        queue.isSuspended
    }
}
