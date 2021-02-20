//
//  LoadingView.swift
//
//  Created by Hai Le Thanh.
//  
//
	
import UIKit

// MARK: - LoadingView
final class LoadingView: UIView {
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSubviews() {
        addSubview(blurView)
        blurView.contentView.addSubview(loadingIndicator)
        
        backgroundColor = .clear
        blurView.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = false
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: self.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    // Public functions
    func showLoading(on view: UIView) {
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        loadingIndicator.startAnimating()
    }
    
    func hideLoading() {
        loadingIndicator.stopAnimating()
        self.removeFromSuperview()
    }
}
