//
//  WebViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/13.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import WebKit
import JGProgressHUD
import Instructions
import Popover_OC

class WebViewController: BasicViewController {
    
    @IBOutlet weak var btMore: UIButton!
    
    var url = "https://blive.bvision.live"
    var hud: JGProgressHUD?
    var wkWebView: WKWebView?
    
    let coachMarksController = CoachMarksController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coachMarksController.dataSource = self
        coachMarksController.delegate = self
        print(url)
        do{
            initWebView()
        }catch{
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let showWebGuideView: Bool = UFUtils.getBool("showWebGuideView")
        if(!showWebGuideView){
            self.coachMarksController.start(on: self)
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

extension WebViewController: WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hud?.dismiss()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.hud?.dismiss()
    }
    
}


extension WebViewController: WKScriptMessageHandler{
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "AppModel" {
            print(message.body)
        }
    }
    
    //swift调用js
    func wishSeed() {
    }
    
    
}


//MARK:- CoachMarks
extension WebViewController: CoachMarksControllerDataSource, CoachMarksControllerDelegate{

    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 1
    }

    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        return coachMarksController.helper.makeCoachMark(for: btMore, pointOfInterest: nil, cutoutPathMaker: nil)
    }

    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        coachViews.bodyView.hintLabel.text = NSLocalizedString("click more select 'Open in browser' if web page can not load", comment: "")
        coachViews.bodyView.nextLabel.text = NSLocalizedString("Got It", comment: "")
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }

    func coachMarksController(_ coachMarksController: CoachMarksController, didEndShowingBySkipping skipped: Bool) {
        UFUtils.set(true, key: "showWebGuideView")
    }

}



extension WebViewController{
    
    @IBAction func showPopupMenu(){
        let popOpen = PopoverAction.init(image: #imageLiteral(resourceName: "safari_30"), title: "Open in browser", handler: {action in
            self.showInSafari(self.url)
        })
        let popView = PopoverView()
        popView.style = .dark
        popView.show(to: btMore, with: [popOpen!])
    }
    
    func showInSafari(_ url: String){
        if let u = URL(string: url)  {
            UIApplication.shared.open(u)
        }
    }
}
