//
//  ViewController.swift
//  Project4
//
//  Created by Emir Arıkan on 1.02.2023.
//

import UIKit
import WebKit
class ViewController: UIViewController,WKNavigationDelegate {
    var webView:WKWebView!
    var progressView: UIProgressView!
    var websites = ["apple.com", "google.com", "microsoft.com"]
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        self.view = webView
        

    }

    override func viewDidLoad() {
       
        super.viewDidLoad()
        let url = URL(string: "http://www.apple.com")!
        webView.load(URLRequest(url:url))
        

        webView.frame.size = webView.sizeThatFits(CGSize.init(width: 500, height: 300))
        webView.allowsBackForwardNavigationGestures = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshTapped))
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        toolbarItems = [progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        webView.addObserver(self, forKeyPath: "estimatedProgress", context: nil)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    @objc func refreshTapped() {
            webView.reload()
        }
    @objc func openTapped(){
        let ac = UIAlertController(title: "Open Page..", message: nil, preferredStyle: .alert)
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
                }
        ac.addAction(UIAlertAction(title: "Back", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    func openPage(action:UIAlertAction){
        guard let actionTitle = action.title else{return }
        let url = (URL(string: "https://\(actionTitle)"))!
        webView.load(URLRequest(url: url))
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
      let url = navigationAction.request.url

      if let host = url?.host{
          for webSite in websites {
              if host.contains(webSite){
                  decisionHandler(.allow)
                  return
              }
          }
      }
      decisionHandler(.cancel)
    }
}

