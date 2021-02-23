//
//  BaseViewModel.swift
//
//  Created by Hai Le Thanh.
//
	

import Foundation

protocol BaseViewModel { }

protocol ViewConfigurable {
    func configure(with viewModel: BaseViewModel)
}

/**
 BaseViewModelProtocol & BaseViewProtocol is for ViewController and its ViewModel
 */
protocol BaseViewModelProtocol {
    func bind(to view: BaseViewProtocol)
    func requestData(forceLoad: Bool)
}

protocol BaseViewProtocol {
    func configure(with viewModel: BaseViewModelProtocol)
    func handleError(_ error: Error)
}
