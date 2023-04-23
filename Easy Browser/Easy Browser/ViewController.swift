//
//  ViewController.swift
//  Easy Browser
//
//  Created by Nathan Getachew on 4/21/23.
//

import UIKit
import WebKit

class ViewController:  UIViewController, WKNavigationDelegate {
    
    var webView : WKWebView!
    var progressView : UIProgressView!
    var websites = ["apple.com", "google.com"]
    var observation: NSKeyValueObservation?
    
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    override func viewDidDisappear(_ animated: Bool) {
        observation?.invalidate()
        observation = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //MARK: - navbar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        //MARK: - toolbar
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let goBack = UIBarButtonItem(title: "Back", image: nil, target: webView, action: #selector(webView.goBack))
        let goForward = UIBarButtonItem(title: "Forward", image: nil, target: webView, action: #selector(webView.goForward))
        
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [progressButton, spacer, goBack, goForward, refresh]
        navigationController?.isToolbarHidden = false
        
        //MARK: -  webView
        let url = URL(string: "https://" + websites[0])!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        observation = webView.observe(\.estimatedProgress, options: [.new]) { (webView, change) in
            // Update progress view with new progress value
            self.progressView.progress = Float(webView.estimatedProgress)
        }
        
        
    }
    
    @objc
    func openTapped(){
        let ac = UIAlertController(title: "Open page", message: nil, preferredStyle: .actionSheet)
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default,handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func openPage(action : UIAlertAction){
        let url = URL(string:"https://" + action.title!)!
        webView.load(URLRequest(url:url))
    }
    
    
    //MARK: - Delegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title =  webView.title
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        
        let alert = UIAlertController(title: "Not allowed", message: "URL is not allowed in Easy Browser", preferredStyle: .alert)
        present(alert, animated: true)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        decisionHandler(.cancel)
    }
    
    
}
