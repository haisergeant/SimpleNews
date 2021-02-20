//
//  Collection.swift
//
//  Created by Hai Le Thanh.
//  
//
	

import Foundation

/// Safe subscripting read only.
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

/// Safe subscripting read/write.
extension MutableCollection {
    subscript(safe index: Index) -> Element? {
        get {
            return indices.contains(index) ? self[index] : nil
        }

        set(newValue) {
            if let newValue = newValue, indices.contains(index) {
                self[index] = newValue
            }
        }
    }
}
