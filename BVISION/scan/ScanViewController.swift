//
//  ScanViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/13.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox
import EFQRCode
import PopupDialog

private let scanAnimationDuration = 3.0

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{
    
    @IBOutlet weak var ivScan: UIImageView!
//    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    lazy var scanLine : UIImageView = {
        let scanLine = UIImageView()
        scanLine.frame = CGRect(x: 0, y: 0, width: self.ivScan.bounds.width, height: 3)
        scanLine.image = UIImage(named: "scan_line")
        return scanLine
    }()
    
    var scanSession :  AVCaptureSession?
    var lightOn = false
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        view.layoutIfNeeded()
        ivScan.addSubview(scanLine)
        setupScanSession()
    }
    
    func setupScanSession(){
        do{
            let device = AVCaptureDevice.default(for: AVMediaType.video)
            let input = try AVCaptureDeviceInput(device: device!)
            let output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            let  scanSession = AVCaptureSession()
            scanSession.canSetSessionPreset(AVCaptureSession.Preset.high)
            
            if scanSession.canAddInput(input){
                scanSession.addInput(input)
            }
            if scanSession.canAddOutput(output){
                scanSession.addOutput(output)
            }
            output.metadataObjectTypes = [
                AVMetadataObject.ObjectType.qr,
                AVMetadataObject.ObjectType.code39,
                AVMetadataObject.ObjectType.code128,
                AVMetadataObject.ObjectType.code39Mod43,
                AVMetadataObject.ObjectType.ean13,
                AVMetadataObject.ObjectType.ean8,
                AVMetadataObject.ObjectType.code93]
            let scanPreviewLayer = AVCaptureVideoPreviewLayer(session:scanSession)
            scanPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            scanPreviewLayer.frame = view.layer.bounds
            
            view.layer.insertSublayer(scanPreviewLayer, at: 0)
            if (device?.isFocusModeSupported(.autoFocus))!{
                do { try input.device.lockForConfiguration() } catch{ }
                input.device.focusMode = .autoFocus
                input.device.unlockForConfiguration()
            }
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVCaptureInputPortFormatDescriptionDidChange, object: nil, queue: nil, using: { (noti) in
                output.rectOfInterest = (scanPreviewLayer.metadataOutputRectConverted(fromLayerRect: self.ivScan.frame))
            })
            self.scanSession = scanSession
        }
        catch{
            print("camera can not work")
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        startScan()
    }
    
    fileprivate func startScan() {
        scanLine.layer.add(scanAnimation(), forKey: "scan")
        guard let scanSession = scanSession else { return }
        if !scanSession.isRunning{
            scanSession.startRunning()
        }
    }
    
    private func scanAnimation() -> CABasicAnimation{
        let startPoint = CGPoint(x: scanLine .center.x  , y: 1)
        let endPoint = CGPoint(x: scanLine.center.x, y: ivScan.bounds.size.height - 2)
        let translation = CABasicAnimation(keyPath: "position")
        translation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        translation.fromValue = NSValue(cgPoint: startPoint)
        translation.toValue = NSValue(cgPoint: endPoint)
        translation.duration = scanAnimationDuration
        translation.repeatCount = MAXFLOAT
        translation.autoreverses = true
        return translation
    }
    
    @IBAction func light(_ sender: UIButton){
        lightOn = !lightOn
        sender.isSelected = lightOn
        turnTorchOn()
    }
    
    private func turnTorchOn(){
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else{
            if lightOn{
                print("flash light can not work")
            }
            return
        }
        if device.hasTorch{
            do{
                try device.lockForConfiguration()
                if lightOn && device.torchMode == .off{
                    device.torchMode = .on
                }
                if !lightOn && device.torchMode == .on{
                    device.torchMode = .off
                }
                device.unlockForConfiguration()
            }
            catch{ }
        }
    }
    
    @IBAction func generateQRCode(){
        let inviteCode = AESUtil.encrypt("\(TimeUtil.getUnixTimestamp())\(userId)")!
        if let tryImage = EFQRCode.generate(content: "\(Constant.link_app_qrcode)\(inviteCode)", watermark: #imageLiteral(resourceName: "bvision2").toCGImage()) {
            let title = "B·VISION in App Store"
            let message = ""
            let popup = PopupDialog(title: title, message: message, image: UIImage(cgImage: tryImage))
            let dialogAppearance = PopupDialogDefaultView.appearance()
            dialogAppearance.backgroundColor = UIColor(rgb: Color.primary, alpha: 0.9)
            dialogAppearance.titleColor = UIColor.orange
            self.present(popup, animated: true, completion: nil)
        }
    }
    
    
    //相册
    @IBAction func photo(){
        //        Tool.shareTool.choosePicture(self, editor: true, options: .photoLibrary) {[weak self] (image) in
        //            self!.activityIndicatorView.startAnimating()
        //            DispatchQueue.global().async {
        //                let recognizeResult = image.recognizeQRCode()
        //                let result = recognizeResult?.characters.count > 0 ? recognizeResult : "无法识别"
        //                DispatchQueue.main.async {
        //                    self!.activityIndicatorView.stopAnimating()
        //                    Tool.confirm(title: "扫描结果", message: result, controller: self!)
        //                }
        //            }
        //        }
    }
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection){
        self.scanLine.layer.removeAllAnimations()
        self.scanSession!.stopRunning()
        //播放声音
        playAlertSound(sound: "noticeMusic")
        if metadataObjects.count > 0{
            if let resultObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject{
                if let url = resultObj.stringValue{
                    self.showWebView(url)
                }else{
                    showScanErrorDialog()
                }
            }
        }
    }
    
    func playAlertSound(sound: String){
        guard let soundPath = Bundle.main.path(forResource: sound, ofType: "caf") else { return }
        guard let soundUrl = NSURL(string: soundPath) else { return }
        var soundID: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundUrl, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
    
    
    func showScanErrorDialog(){
        let alert = UIAlertController(
            title: NSLocalizedString("Notice", comment: ""),
            message: NSLocalizedString("Unrecognized QRCode format", comment: ""),
            preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Contiune", style: .default) { (_) in
            alert.dismiss(animated: true, completion: nil)
            self.scanSession?.startRunning()
            self.scanLine.layer.add(self.scanAnimation(), forKey: "scan")
        }
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
    }
    
    deinit{
        ///移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
}
