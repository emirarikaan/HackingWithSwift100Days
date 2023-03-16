//
//  WebViewController.swift
//  Project16
//
//  Created by Emir Arıkan on 19.02.2023.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate{
    var webView : WKWebView!
    var countryName: String = ""
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let url = URL(string: "https://tr.wikipedia.org/wiki/" + countryName)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        // Do any additional setup after loading the view.
    }
}
