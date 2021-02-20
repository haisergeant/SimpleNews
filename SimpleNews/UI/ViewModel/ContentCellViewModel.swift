//
//  ContentCellViewModel.swift
//
//  Created by Hai Le Thanh.
//  
//
	
import Foundation

class ContentCellViewModel: BaseViewModel {
    let imageState: Observable<ImageState>
    let topTitle: String
    let title: String
    let subtitle: String
    let dateString: String
    
    init(imageState: Observable<ImageState>,
         topTitle: String,
         title: String,
         subtitle: String,
         dateString: String) {
        self.imageState = imageState
        self.topTitle = topTitle
        self.title = title
        self.subtitle = subtitle
        self.dateString = dateString
    }
}
