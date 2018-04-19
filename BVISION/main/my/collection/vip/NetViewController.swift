//
//  LivePlayViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/18.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import JGProgressHUD
import WebKit

class NetViewController: BasicViewController {

    let url = "http://lp.ldlegacy.com/liveplay/channel/show"
    var hud: JGProgressHUD?
    
    var wkWebView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initWebView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ChannelToken.execute()
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
        wkWebView!.load(URLRequest.init(url: URL(string: url)!))
        wkWebView!.navigationDelegate = self
        hud = hudLoading()
    }
    
    
}


extension NetViewController: WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hud?.dismiss()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.hud?.dismiss()
    }
    
}


extension NetViewController: WKScriptMessageHandler{
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "AppModel" {
            print(message.body)
            play(message.body as! String)
        }
    }
    
    func play(_ url: String){
        if let playUrl = AESUtil.decrypt(url) {
            var u1 = ""
            if playUrl.contains("#"){
                u1 = playUrl.split(separator: "#").map(String.init)[0]
            }else{
                u1 = playUrl
            }
            if let token = UFUtils.getString(Constant.key_live_play_channel_token){
                if u1.contains("protv.company"){
                    u1 += "?token=\(token)"
                }
            }
            
            let mainBoard: UIStoryboard = UIStoryboard(name: "MyCollection", bundle: nil)
            let playViewController = mainBoard.instantiateViewController(withIdentifier: "KSYPlayerViewController") as! KSYPlayerViewController
            playViewController.playUrl = u1
            self.present(playViewController, animated: false, completion: nil)
        }
    }
    
    //swift调用js
    func wishSeed() {
        self.wkWebView!.evaluateJavaScript("fuction_name('params')", completionHandler: nil)
    }

}
