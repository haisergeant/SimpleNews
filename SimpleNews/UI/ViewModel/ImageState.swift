//
//  ImageState.swift
//
//  Created by Hai Le Thanh.
//  
//
	
import UIKit

// MARK: - ImageState
enum ImageState: Equatable {
    case none
    case loading
    case fail
    case loadedImage(image: UIImage)
}
