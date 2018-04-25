//
//  LivePlayDetailViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/16.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import Kingfisher
import Starscream
import Alamofire
import SwiftyJSON
import PopupDialog

class LivePlayDetailViewController: BasicViewController, UITextFieldDelegate {
    
    var liveChannelInfo: LiveChannelInfo?
    
    @IBOutlet weak var tfComment: UITextField!
    @IBOutlet weak var ivUserIcon: UIImageView!
    @IBOutlet weak var laViewers: UILabel!
    @IBOutlet weak var laUsername: UILabel!
    @IBOutlet weak var btGift: UIButton!
    @IBOutlet weak var btFollow: UIButton!
    @IBOutlet weak var tvComment: UITextView!
    
    var userId = 0
    var pusherId = 0
    var webSocket: WebSocket?
    var comment: String = ""
    var isFriend = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ivUserIcon.layer.cornerRadius = ivUserIcon.frame.width / 2
        self.ivUserIcon.layer.masksToBounds = true
        userId = UFUtils.getInt(Constant.key_user_id)
        pusherId = (liveChannelInfo?.userId)!
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(gestureRecognizer)
        tfComment.delegate = self
        initDisplayData(liveChannelInfo)
        initWS()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfComment {
            if let comment = tfComment.text{
                tfComment?.resignFirstResponder()
                sendComment(comment)
                return false
            }
        }
        return true
    }
    
    @objc func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
        tfComment.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tvComment.scrollRangeToVisible(NSMakeRange(tvComment.text.count, 1))
        self.tvComment.layoutManager.allowsNonContiguousLayout = false;
    }
    
    func initDisplayData(_ liveChannelInfo: LiveChannelInfo?){
        if (liveChannelInfo?.link.count)! > 0{
            btGift.isHidden = false
        }else{
            btGift.isHidden = true
        }
        laUsername.text = liveChannelInfo?.username
        ivUserIcon.kf.setImage(with: URL(string: (liveChannelInfo?.userIcon)!), placeholder: #imageLiteral(resourceName: "hold_person"))
        checkFollowStatus()
    }
    
    @IBAction func gift(){
        if (liveChannelInfo?.link.count)! <= 0 {
            return
        }
        self.showWebView((liveChannelInfo?.link)!)
    }
    
    @IBAction func follow(){
        if(isFriend){
            follow(0)
        }else{
            follow(1)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.closeWS()
    }

}



extension LivePlayDetailViewController{
    func checkFollowStatus(){
        if(userId <= 0){
            return
        }
        let url = "\(Constant.url_user_follow_status)/\(userId)/\(pusherId)"
        Alamofire.request(url, method: .get)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success:
                    let result = JSON(data: response.data!)
                    if(result["code"].intValue == 200){
                        let status: String = result["message"].stringValue
                        if status == "true"{
                            self.btFollow.setBackgroundImage(#imageLiteral(resourceName: "follow_red_30"), for: .normal)
                            self.isFriend = true
                        }else{
                            self.btFollow.setBackgroundImage(#imageLiteral(resourceName: "follow_grey_30"), for: .normal)
                            self.isFriend = false
                        }
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func follow(_ action: Int){
        if(userId <= 0){
            hudError(with: NSLocalizedString("has no sign in", comment: ""))
            return
        }
        let url = "\(Constant.url_user_follow)\(action)/\(userId)/\(pusherId)"
        Alamofire.request(url, method: .post)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success:
                    let result = JSON(data: response.data!)
                    if(result["code"].intValue == 200){
                        if(action == 1){
                            self.btFollow.setBackgroundImage(#imageLiteral(resourceName: "follow_red_30"), for: .normal)
                            self.isFriend = true
                        }else if(action == 0){
                            self.btFollow.setBackgroundImage(#imageLiteral(resourceName: "follow_grey_30"), for: .normal)
                            self.isFriend = false
                        }
                    }else{
                        self.hudError(with: result["message"].stringValue)
                    }
                case .failure(let error):
                    print(error)
                    self.hudError(with: error.localizedDescription)
                }
        }
    }
}



// MARK:- WebSocket
extension LivePlayDetailViewController: WebSocketDelegate{
    
    func initWS(){
        let url = "\(Constant.url_wss_live)\(pusherId)/\(userId)"
        print(url)
        webSocket = WebSocket(url: URL(string: url)!)
        webSocket?.delegate = self
        webSocket?.connect()
    }
    
    func sendComment(_ comment: String){
        let c = "1/\(pusherId)/\(comment)"
        webSocket?.write(string: c)
        tfComment?.text = ""
    }
    
    func closeWS(){
        webSocket?.disconnect()
    }
    
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("ws connect")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print(error ?? "ws error")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        if text.starts(with: "blive group count:") {
            self.laViewers.text = text.substring(from: text.index(text.startIndex, offsetBy: 18))
            return
        }
        comment += text+"\n"
        tvComment.text = comment
        tvComment.scrollRangeToVisible(NSMakeRange(tvComment.text.count, 1))
        tvComment.layoutManager.allowsNonContiguousLayout = false;
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print(data)
    }
}



