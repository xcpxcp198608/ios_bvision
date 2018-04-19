//
//  LocalPushViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/19.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import libksygpulive
import Alamofire
import SwiftyJSON
import Starscream
import Kingfisher
import JGProgressHUD

class LocalPushViewController: UIViewController {
    
    @IBOutlet weak var laViewers: UILabel!
    @IBOutlet weak var tvComment: UITextView!
    
    let userId = UFUtils.getInt(Constant.key_user_id)
    
    var pushUrl = UFUtils.getString(Constant.key_channel_push_url)!
    var videoUrl: URL?
    
    var webSocket: WebSocket?
    var comment = ""
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    fileprivate lazy var pusher: KSYGPUPipStreamerKit = {
        let pusher = KSYGPUPipStreamerKit()
        return pusher
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPusher()
        initWS()
    }
    
    func initPusher(){
        if let video = videoUrl{
            let bgPic = URL.init(string: "https://s1.ax1x.com/2018/04/19/CuJ0XT.png")
//            let bgPic = URL.init(fileURLWithPath: FileUtils.getDocmentsPath() + "/push_bg.png")
            pusher.startPreview(self.view)
            pusher.startPip(withPlayerUrl: video, bgPic: bgPic)
            pusher.player.shouldLoop = true
            pusher.player.play()
            pusher.pipRect = CGRect.init(x: 0, y: 0, width: 1, height: 1)
            pusher.cameraPosition = .back
            pusher.cameraRect = CGRect.init(x: 1, y: 1, width: 0, height: 0)
            pusher.streamerBase.startStream(URL(string: pushUrl))
            updateChannelStatus(1)
        }
    }
    
    
    @IBAction func close(){
        updateChannelStatus(0)
        closeWS()
        pusher.stopPip()
        pusher.streamerBase.stopStream()
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        close()
    }
    
}


//MARK: - channel control
extension LocalPushViewController{
    
    func updateChannelStatus(_ status: Int){
        if userId <= 0 {return}
        let url = "\(Constant.url_channel_update_status)\(status)/\(userId)"
        Alamofire.request(url, method: .put, encoding: JSONEncoding.default, headers: Constant.jsonHeaders)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success:
                    let restult = JSON(data: response.data!)
                    if(restult["code"].intValue == 200){
                        print(restult["message"])
                    }else{
                        self.hudError(with: restult["message"].stringValue)
                    }
                case .failure(let error):
                    self.hudError(with: error.localizedDescription)
                }
        }
    }
}


// MARK:- WebSocket
extension LocalPushViewController: WebSocketDelegate{
    
    func initWS(){
        let url = "\(Constant.url_wss_live)\(userId)/\(userId)"
        print(url)
        webSocket = WebSocket(url: URL(string: url)!)
        webSocket?.delegate = self
        webSocket?.connect()
    }
    
    func closeWS(){
        webSocket?.disconnect()
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("connect")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print(error ?? "error")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print(text)
        if text.starts(with: "blive group count:") {
            self.laViewers.text = text.substring(from: text.index(text.startIndex, offsetBy: 18))
            return
        }
        tvComment.isHidden = false
        comment += text+"\n"
        tvComment.text = comment
        tvComment.scrollRangeToVisible(NSMakeRange(tvComment.text.count, 1))
        tvComment.layoutManager.allowsNonContiguousLayout = false;
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print(data)
    }
    
}
