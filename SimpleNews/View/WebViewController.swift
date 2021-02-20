//
//  WebViewController.swift
//
//  Created by Hai Le Thanh.
//  
//
	
import UIKit
import WebKit

final class WebViewController: UIViewController {
    private let webView = WKWebView()
    private var url: URL?
    
    
    init(urlString: String) {
        super.init(nibName: nil, bundle: nil)
        self.url = URL(string: urlString)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        
        webView.navigationDelegate = self
        
        webView.disableTranslatesAutoResizing()
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
        
        if let url = url {
            webView.load(URLRequest(url: url))
        }
    }
}

extension WebViewController: WKNavigationDelegate {
    
}
