//
//  GrayQuestPaymentVC.swift
//  Handles the webview loading part, once an user clicks on view payment button
//
//  Created by admin on 02/08/22.
//

import UIKit
import WebKit

class GrayQuestPaymentVC: UIViewController, WKUIDelegate, WKScriptMessageHandler, WKNavigationDelegate {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("LOGPayment: \(message.body)")
    }
    
    var webView: WKWebView!
    
    var paymentURL: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func willMove(toParent: UIViewController? ) {
        print("Something")
    }
    
    override func loadView() {
        if (paymentURL == nil) {return}
        let wkPreferences = WKPreferences()
        wkPreferences.javaScriptCanOpenWindowsAutomatically = true
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences = wkPreferences
        webConfiguration.userContentController.add(self, name: "Gqsdk")
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.configuration.preferences.javaScriptEnabled = true
        webView.navigationDelegate = self
        webView.uiDelegate = self
        view = webView
        
        let url = URL(string: paymentURL!)
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        var redirectURL = "\(navigationAction.request.url)"
        
        if (redirectURL.contains("cf_token")) {
            decisionHandler(.cancel)
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        } else {
            decisionHandler(.allow)
        }
    }
}
