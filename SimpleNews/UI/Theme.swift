//
//  Theme.swift
//
//  Created by Hai Le Thanh.
//  
//
	

import UIKit

struct Theme {
    static let font: FontTheme = AppFontTheme()
    static let color: ColorTheme = AppColorTheme()
}

protocol ColorTheme {
    var contentCellTopTitleColor: UIColor { get }
    var contentCellTitleColor: UIColor { get }
    var contentCellSubtitleColor: UIColor { get }
    var contentCellDateColor: UIColor { get }
    var contentCellSeparator: UIColor { get }
}

protocol FontTheme {
    var contentCellTopTitleFont: UIFont { get }
    var contentCellTitleFont: UIFont { get }
    var contentCellSubtitleFont: UIFont { get }
    var contentCellDateFont: UIFont { get }
}

struct AppColorTheme: ColorTheme {
    var contentCellTopTitleColor: UIColor { .appDarkBlue }
    var contentCellTitleColor: UIColor { .appBrightBlue }
    var contentCellSubtitleColor: UIColor { .appLightGreen }
    var contentCellDateColor: UIColor { .appDarkGreen }
    var contentCellSeparator: UIColor { .appDarkGrey }
}

struct AppFontTheme: FontTheme {
    private let smallRegular = UIFont.systemFont(ofSize: 14)
    private let mediumRegular = UIFont.systemFont(ofSize: 16)
    private let largeRegular = UIFont.systemFont(ofSize: 18)
    
    private let smallSemibold = UIFont.boldSystemFont(ofSize: 14)
    private let mediumSemibold = UIFont.boldSystemFont(ofSize: 16)
    private let largeSemibold = UIFont.boldSystemFont(ofSize: 18)
    
    var contentCellTopTitleFont: UIFont { mediumSemibold }
    var contentCellTitleFont: UIFont { smallRegular }
    var contentCellSubtitleFont: UIFont { smallRegular }
    var contentCellDateFont: UIFont { smallRegular }
}
