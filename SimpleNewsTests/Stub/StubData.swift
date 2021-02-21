//
//  StubData.swift
//
//  Created by Hai Le Thanh.
//  
//
	

import Foundation

struct StubData {
    static func loadStubData(fileName: String, ext: String) -> Data {
        let bundle = Bundle(identifier: "com.haile.SimpleNewsTests")!
        let url = bundle.url(forResource: fileName, withExtension: ext)
        return try! Data(contentsOf: url!)
    }
}
