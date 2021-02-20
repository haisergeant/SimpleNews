//
//  Feed.swift
//
//  Created by Hai Le Thanh.
//  
//
	
import Foundation

struct Feed: Decodable {
    let id: Double
    let displayName: String
    let assets: [Article]
}

struct Article: Decodable {
    let id: Double
    let url: String
    let headline: String
    let theAbstract: String
    let byLine: String
    let timeStamp: Double
    
    let relatedImages: [ArticleImage]
}

struct ArticleImage: Decodable {
    let width: Double
    let height: Double
    let url: String
}
