//
//  PushViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/16.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import libksygpulive
import Alamofire
import SwiftyJSON
import Starscream
import Kingfisher
import JGProgressHUD
import RxSwift
import RxCocoa

class PushViewController: BasicViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var btLight: UIButton!
    @IBOutlet weak var btMute: UIButton!
    @IBOutlet weak var btCamera: UIButton!
    @IBOutlet weak var btBeauty: UIButton!
    @IBOutlet weak var btRecord: UIButton!
    @IBOutlet weak var btStart: UIButton!
    @IBOutlet weak var laViewers: UILabel!
    @IBOutlet weak var controlMaskView: UIView!
    @IBOutlet weak var settingMaskView: UIView!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfContent: UITextField!
    @IBOutlet weak var tfLink: UITextField!
    @IBOutlet weak var laPrice: UILabel!
    @IBOutlet weak var laRating: UILabel!
    @IBOutlet weak var ivPreview: UIImageView!
    @IBOutlet weak var tvComment: UITextView!
    @IBOutlet weak var laRecordTime: UILabel!


    var currentPrice: Float = 0.00
    var currentPriceRow = 0
    var currentRating: Int = 2
    var currentRatingRow = 2
    var ratings = ["G", "PG", "PG-13", "R", "NC-17"]
    var pricePickerView: UIPickerView!
    var ratingPickerView: UIPickerView!

    var webSocket: WebSocket?
    var comment = ""

    var recordSeconds = 0
    let bag = DisposeBag()
    var timer: Observable<Int>!
    var subscription1: Disposable?
    var subscription2: Disposable?

    override var prefersStatusBarHidden: Bool{
        return true
    }


    var pushUrl = UserDefaults.standard.string(forKey: Constant.key_channel_push_url)!
    var isPushing = false
    var isBeauty = false
    var isRecording = false
    var isLightOn = false
    var isMuted = false

    fileprivate lazy var pusher: KSYGPUStreamerKit = {
        let pusher = KSYGPUStreamerKit()
        pusher.streamerBase.videoCodec = KSYVideoCodec.AUTO
        pusher.streamerProfile = KSYStreamerProfile._360p_1
        pusher.cameraPosition = .back
        pusher.setupFilter(KSYBeautifyFaceFilter())
        pusher.streamerBase.bwEstimateMode = .estMode_Default
        pusher.streamerBase.shouldEnableKSYStatModule = true
        pusher.cameraPosition  = .back
        pusher.startPreview(self.view)
        return pusher
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(gestureRecognizer)

        let priceGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(btPriceClick))
        laPrice.addGestureRecognizer(priceGestureRecognizer)
        laPrice.isUserInteractionEnabled = true

        let ratingGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(btRatingClick))
        laRating.addGestureRecognizer(ratingGestureRecognizer)
        laRating.isUserInteractionEnabled = true
        
        if userId >= 6 {
            btRecord.isHidden = false
        }else{
            btRecord.isHidden = true
        }
        initChannelInfo()
    }

    func initChannelInfo(){
        if userLevel >= 6{
            tfLink.isHidden = false
        }else{
            tfLink.isHidden = true
        }
        tfTitle.delegate = self
        tfContent.delegate = self
        tfLink.delegate = self
        tfTitle.setValue(UIColor.darkGray, forKeyPath: "_placeholderLabel.textColor")
        tfContent.setValue(UIColor.darkGray, forKeyPath: "_placeholderLabel.textColor")
        tfLink.setValue(UIColor.darkGray, forKeyPath: "_placeholderLabel.textColor")
        if let title = UFUtils.getString(Constant.key_channel_title) {
            tfTitle.text = title
        }
        if let content = UFUtils.getString(Constant.key_channel_message) {
            tfContent.text = content
        }
        if let link = UFUtils.getString(Constant.key_channel_link) {
            tfLink.text = link
        }
        if let preview = UFUtils.getString(Constant.key_channel_preview) {
            ivPreview.kf.setImage(with: URL(string: preview), placeholder: #imageLiteral(resourceName: "hold_bvision"))
        }
        ivPreview.isUserInteractionEnabled = true
        let previewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showPickPhoto))
        ivPreview.addGestureRecognizer(previewGestureRecognizer)
    }

    @objc func showPickPhoto(){
        self.showPhotoMenu()
    }

    @objc func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
        tfTitle.resignFirstResponder()
        tfContent.resignFirstResponder()
        tfLink.resignFirstResponder()
    }

    @objc func btPriceClick(){
        let alertController:UIAlertController=UIAlertController(title: "", message: "\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.actionSheet)
        pricePickerView = UIPickerView()
        pricePickerView.dataSource = self
        pricePickerView.delegate = self
        pricePickerView.selectRow(0, inComponent:0, animated:true)

        alertController.view.addSubview(pricePickerView)
        alertController.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default){
            (alertAction) -> Void in
            print("price confirm")
            self.currentPrice = Float(self.currentPriceRow)
            self.laPrice.text = "$\(self.currentPrice)"
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }


    @objc func btRatingClick(){
        let alertController:UIAlertController=UIAlertController(title: "", message: "\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.actionSheet)
        ratingPickerView = UIPickerView()
        ratingPickerView.dataSource = self
        ratingPickerView.delegate = self
        ratingPickerView.selectRow(2, inComponent:0, animated:true)

        alertController.view.addSubview(ratingPickerView)
        alertController.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default){
            (alertAction) -> Void in
            print("rating confirm")
            self.currentRating = self.currentRatingRow
            self.laRating.text = self.ratings[self.currentRating]
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pricePickerView {
            return 101
        }
        if pickerView == ratingPickerView {
            return ratings.count
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
        if pickerView == pricePickerView {
            return "\(row).00"
        }
        if pickerView == ratingPickerView {
            return ratings[row]
        }
        return ""
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pricePickerView {
            print("price row: \(row)")
            currentPriceRow = row
        }
        if pickerView == ratingPickerView {
            print("rating row: \(row)")
            currentRatingRow = row
        }
    }


    deinit {
        pusher.streamerBase.stopStream()
        closeWS()
        closeCountRecordTime()
        NotificationCenter.default.removeObserver(self)
        UIApplication.shared.isIdleTimerDisabled = false
    }
}

//MARK: - Notifaction
extension PushViewController{

    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(onStreamStateChange), name: Notification.Name.KSYStreamStateDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onCaptureStateChange), name: NSNotification.Name.KSYCaptureStateDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onOrientationChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

    @objc func onStreamStateChange(){
        if pusher.streamerBase.streamState == KSYStreamState.idle{
            print("stream idle")
            return
        }
        if pusher.streamerBase.streamState == KSYStreamState.connecting{
            print("stream connecting")
            return
        }
        if pusher.streamerBase.streamState == KSYStreamState.connected{

            print("stream connected")
            return
        }
        if pusher.streamerBase.streamState == KSYStreamState.disconnecting{
            print("stream disconnecting")
            return
        }
        if pusher.streamerBase.streamState == KSYStreamState.error{
            print("stream error")
            return
        }
    }


    @objc func onCaptureStateChange() {

    }

    @objc fileprivate func onOrientationChange() {
        let orientation = UIDevice.current.orientation
        if orientation == UIDeviceOrientation.faceUp || orientation == UIDeviceOrientation.faceDown || orientation == UIDeviceOrientation.unknown {
            return
        }
        pusher.videoOrientation = UIApplication.shared.statusBarOrientation
        pusher.streamOrientation = UIApplication.shared.statusBarOrientation
        pusher.rotatePreview(to: UIApplication.shared.statusBarOrientation)
    }

    func onRecordStateChange(){
        pusher.streamerBase.bypassRecordStateChange = {state in
            switch state {
            case .idle:
                print("record idle")
                break
            case .recording:
                print("record recording")
                break
            case .stopped:
                print("record stopped")
                break
            case .error:
                print("record error")
                break
            default:
                break
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        close()
    }

}



//MARK: - control mask click action
extension PushViewController{

    @IBAction func start(){
        updateChannelInfo()
        updateChannelStatus(1)
        initWS()
        startPush()
    }

    func startPush(){
        print(pushUrl)
        if let url = URL(string: pushUrl) {
            pusher.streamerBase.startStream(url);
        }
        isPushing = !isPushing
        settingMaskView.isHidden = true
        controlMaskView.isHidden = false
    }

    @IBAction func light(){
        guard let vCapDev = pusher.vCapDev, pusher.isTorchSupported() else { return }
        if vCapDev.cameraPosition() == .back {
            pusher.toggleTorch()
            isLightOn = !isLightOn
            if isLightOn{
                btLight.setImage(#imageLiteral(resourceName: "light_on"), for: .normal)
            }else{

                btLight.setImage(#imageLiteral(resourceName: "light_off"), for: .normal)
            }
        } else {}
    }

    @IBAction func mute(){
        if isMuted{
            pusher.aCapDev.start()
            btMute.setImage(#imageLiteral(resourceName: "mic_grey_on"), for: .normal)
        }else{
            pusher.aCapDev.stop()
            btMute.setImage(#imageLiteral(resourceName: "mic_grey_off"), for: .normal)
        }
        isMuted = !isMuted
    }

    @IBAction func changeCamera(){
        pusher.switchCamera()
    }

    @IBAction func beauty(){
        if isBeauty{
            pusher.setupFilter(nil)
        }else{
            pusher.setupFilter(KSYBeautifyFaceFilter())
        }
        isBeauty = !isBeauty
    }

    @IBAction func record(){
        if !isPushing{return}
        self.onRecordStateChange()
        let videoPath = FileUtils.createDic("video")
        let fileName = "record_\(TimeUtil.getUnixTimestamp()).mp4"
        let filePath = "\(videoPath)/\(fileName)"
        if isRecording{
            pusher.streamerBase.stopBypassRecord()
            btRecord.setImage(#imageLiteral(resourceName: "record_30"), for: .normal)
        }else{
            pusher.streamerBase.startBypassRecord(URL(string: filePath))
            btRecord.setImage(#imageLiteral(resourceName: "record_stop_30"), for: .normal)
        }
        isRecording = !isRecording
    }

    @IBAction func close(){
        if isPushing {
            pusher.stopPreview()
        }
        if isRecording{
            pusher.streamerBase.stopBypassRecord()
        }
        closeWS()
        updateChannelStatus(0)
        closeCountRecordTime()
        isPushing = !isPushing
        self.dismiss(animated: true, completion: nil)
    }

    func startCountRecordTime(){
        laRecordTime.isHidden = false
        timer = Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
        subscription1 = timer.subscribe(onNext: { msecs -> Void in
            print("\(msecs)00ms")
        })
        subscription2 = timer.map(stringFromTimeInterval)
            .bind(to: laRecordTime.rx.text)
    }

    func closeCountRecordTime(){
        subscription1?.dispose()
        subscription2?.dispose()
    }

    func stringFromTimeInterval(ms: NSInteger) -> String {
        return String(format: "%0.2d:%0.2d:%0.2d.%0.1d",
                      arguments: [(ms / 3600) % 3600, (ms / 600) % 600, (ms % 600 ) / 10, ms % 10])
    }

}


//MARK: - channel control
extension PushViewController{

    func updateChannelInfo(){
        let hud = hudLoading()
        let title = tfTitle.text
        let message = tfContent.text
        let link = tfLink.text
        let parameters = ["userId": UFUtils.getInt(Constant.key_user_id),
                          "title": title ?? "", "message": message ?? "", "link": link ?? "",
                          "price": currentPrice, "rating": currentRating] as [String : Any]
        print(parameters)
        Alamofire.request(Constant.url_channel_update_all_info, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: Constant.jsonHeaders)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success:
                    let result = JSON(data: response.data!)
                    hud.dismiss()
                    if(result["code"].intValue == 200){
                        UFUtils.set(result["data"]["title"].stringValue, key: Constant.key_channel_title)
                        UFUtils.set(result["data"]["message"].stringValue, key: Constant.key_channel_message)
                        UFUtils.set(result["data"]["price"].stringValue, key: Constant.key_channel_price)
                        UFUtils.set(result["data"]["rating"].stringValue, key: Constant.key_channel_rating)
                        UFUtils.set(result["data"]["link"].stringValue, key: Constant.key_channel_link)
                    }else{
                        self.hudError(with: result["message"].stringValue)
                    }
                case .failure(let error):
                    hud.dismiss()
                    self.hudError(with: error.localizedDescription)
                }
        }
    }

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
                        if status == 1 {
                            self.startCountRecordTime()
                        }
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
extension PushViewController: WebSocketDelegate{

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



//MARK: - text field delegate
extension PushViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfTitle {
            tfContent.becomeFirstResponder()
            return false
        }
        if textField == tfContent {
            tfLink.becomeFirstResponder()
            return false
        }
        if textField == tfLink {
            tfLink.resignFirstResponder()
            return false
        }
        return true
    }
}


//MARK: - image picker and update preview
extension PushViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imagePreview = info[UIImagePickerControllerEditedImage] as? UIImage {
            uploadPreview(imagePreview)
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }


    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }

    func showPhotoMenu() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let takePhotoAction = UIAlertAction(title: NSLocalizedString("Take Photo", comment: ""), style: .default, handler:  { _ in self.takePhotoWithCamera() })
        alertController.addAction(takePhotoAction)
        let chooseFromLibraryAction = UIAlertAction(title:
            NSLocalizedString("Choose From Library", comment: ""), style: .default, handler:  { _ in self.choosePhotoFromLibrary() })
        alertController.addAction(chooseFromLibraryAction)
        present(alertController, animated: true, completion: nil)
    }

    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: false, completion: nil)
    }

    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }

    func uploadPreview(_ image: UIImage){
        if userId <= 0 {
            hudError(with: NSLocalizedString("has no sign in", comment: ""))
            return
        }
        let hud = hudLoading()
        let url = "\(Constant.url_channel_upload_preview)\(userId)"
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        let fileName = "\(userId)_\(TimeUtil.getUnixTimestamp()).jpg"
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData!, withName: "file", fileName: fileName, mimeType: "image/jpeg")
        },
            to: url,
            encodingCompletion: { encodingResult in
                hud.dismiss()
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        let result = JSON(data: response.data!)
                        if result["code"].intValue == 200 {
                            UFUtils.set(result["data"]["preview"].stringValue, key: Constant.key_channel_preview)
                            self.ivPreview.image = image
                        }else{
                            self.hudError(with: result["message"].stringValue)
                        }
                    }
                case .failure(let encodingError):
                    self.hudError(with: encodingError.localizedDescription)
                }
        }
        )
    }
}
