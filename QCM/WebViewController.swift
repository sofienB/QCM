//
//  WebViewController.swift
//  QCM
//
//  Created by Sofien Benharchache on 30/01/2023.
//

import WebKit

final class WebViewController: UIViewController {
    var webView: WKWebView?
    var content: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        self.view.addSubview(webView!)
        webView?.anchor(top: self.view.topAnchor,
                       bottom: self.view.bottomAnchor,
                       leading: self.view.leadingAnchor,
                       trailing: self.view.trailingAnchor)
        webView?.loadHTMLString(content, baseURL: nil)
    }
    
    func load(answer: String) {
        self.content = answer
    }
}
