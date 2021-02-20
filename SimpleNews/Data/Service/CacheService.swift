//
//  CacheService.swift
//
//  Created by Hai Le Thanh.
//  Copyright © 2020 Hai Le. All rights reserved.
//
	

import Foundation

protocol CacheServiceProtocol {
    func cache(value: Any?, for key: String, for interval: TimeInterval)
    func cacheValue(for key: String) -> Any?
    func clearCache()
}

class CacheService {
    static let shared = CacheService()
    
    private let userDefaults = UserDefaults.standard
    private init() {
        
    }
}

extension CacheService: CacheServiceProtocol {
    func cache(value: Any?, for key: String, for interval: TimeInterval) {
        userDefaults.set(value, forKey: key)
        userDefaults.set(Date(), forKey: key.timeKey)
        userDefaults.set(interval, forKey: key.intervalKey)
    }
    
    func cacheValue(for key: String) -> Any? {
        guard let date = userDefaults.value(forKey: key.timeKey) as? Date,
            let interval = userDefaults.value(forKey: key.intervalKey) as? TimeInterval,
            Date().timeIntervalSince(date) < interval
            else { return nil }
        return userDefaults.value(forKey: key)
    }
    
    func clearCache() {
        UserDefaults.resetStandardUserDefaults()
    }
}

private extension String {
    var timeKey: String {
        return self + "-timestamp"
    }
    
    var intervalKey: String {
        return self + "-interval"
    }
}
