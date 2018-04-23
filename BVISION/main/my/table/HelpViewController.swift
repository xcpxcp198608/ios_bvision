//
//  HelpViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/18.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import WebKit
import JGProgressHUD

class HelpViewController: BasicViewController {

    let url = "https://blive.bvision.live/Resource/html/ios_help.html"
    var hud: JGProgressHUD?
    var wkWebView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(url)
        do{
            initWebView()
        }catch{
        }
    }
    
    func initWebView() {
        let config = WKWebViewConfiguration()
        config.preferences = WKPreferences()
        config.preferences.minimumFontSize = 10
        config.preferences.javaScriptEnabled = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = false
        config.processPool = WKProcessPool()
        config.userContentController = WKUserContentController()
        config.userContentController.add(self, name: "AppModel")
        wkWebView = WKWebView(frame: view.bounds, configuration: config)
        view.addSubview(wkWebView!)
        wkWebView!.load(URLRequest(url: URL(string: url)!))
        wkWebView!.navigationDelegate = self
        wkWebView!.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A356 Safari/604.1";
        hud = hudLoading()
    }
    
}

extension HelpViewController: WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hud?.dismiss()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.hud?.dismiss()
    }
    
}


extension HelpViewController: WKScriptMessageHandler{
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "AppModel" {
            print(message.body)
        }
    }
    
    //swift调用js
    func wishSeed() {
    }


}
