//
//  PublishTrendingViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/29.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import SnapKit
import Alamofire
import SwiftyJSON

class TrendingPublishController: BasicViewController {
    
    @IBOutlet weak var tvContent: UITextView!
    @IBOutlet weak var laWords: UILabel!
    
    var countWords = 0
    
    var ivAdd: UIImageView?
    var width = 0
    
    var images = [UIImage]()
    var imageViews = [UIImageView]()
    
    var content = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvContent.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hidKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        width = Int((self.view.frame.width - 32 - 16)) / 3
    }
    
    @objc func hidKeyboard(){
        tvContent.resignFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if images.count <= 0{
            if ivAdd != nil {
                ivAdd?.removeFromSuperview()
            }
            createAddImage(0)
        }else{
            if ivAdd != nil {
                ivAdd?.removeFromSuperview()
            }
            for i in 0..<images.count{
                let left = i % 3 * width + i % 3 * 8 + 16
                var top = 0
                if i < 3 {
                    top = 8
                }else{
                    top = width + 16
                }
                
                let ivPreview = UIImageView.init()
                ivPreview.image = images[i]
                ivPreview.contentMode = .scaleAspectFill
                ivPreview.clipsToBounds = true
                self.view.addSubview(ivPreview)
                ivPreview.snp.makeConstraints {
                    $0.left.equalTo(view).offset(left)
                    $0.top.equalTo(laWords.snp.bottom).offset(top)
                    $0.width.equalTo(width)
                    $0.height.equalTo(width)
                }
                imageViews.append(ivPreview)
            }
            if images.count < 6{
                createAddImage(images.count)
            }
        }
    }
    
    
    func createAddImage(_ index: Int){
        let left = index % 3 * width + 16 + (index % 3 * 8)
        var top = 0
        if index < 3 {
            top = 8
        }else{
            top = width + 16
        }
        ivAdd = UIImageView.init()
        ivAdd?.image = #imageLiteral(resourceName: "add_image_50")
        ivAdd?.backgroundColor = UIColor.white
        ivAdd?.contentMode = .center
        self.view.addSubview(ivAdd!)
        ivAdd?.snp.makeConstraints {
            $0.left.equalTo(view).offset(left)
            $0.top.equalTo(laWords.snp.bottom).offset(top)
            $0.width.equalTo(width)
            $0.height.equalTo(width)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pickPhoto))
        ivAdd?.addGestureRecognizer(tapGesture)
        ivAdd?.isUserInteractionEnabled = true
    }

}



extension TrendingPublishController: UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == ""{
            self.laWords.text = "\(textView.text.count)"
            return true
        }
        if textView.text.count > 500{
            return false
        }
        self.laWords.text = "\(textView.text.count)"
        return true
    }
    
}




extension TrendingPublishController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imagePreview = info[UIImagePickerControllerEditedImage] as? UIImage
        if let newImage = imagePreview {
            self.images.append(newImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func pickPhoto() {
        if self.images.count >= 6{
            return
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.showPhotoMenu()
        } else {
            self.choosePhotoFromLibrary()
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
        self.present(alertController, animated: true, completion: nil)
    }
    
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: false, completion: nil)
    }
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
}


extension TrendingPublishController{
    
    @IBAction func publish(){
        if userId <= 0 {
            hudError(with: NSLocalizedString("has no sign in", comment: ""))
            return
        }
        let hud = hudLoading()
        let url = "\(Constant.url_trending)/\(userId)"
        let content = tvContent.text
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append((content?.data(using: String.Encoding.utf8)!)!, withName: "content")
                for i in 0..<self.images.count{
                    let imageData = UIImageJPEGRepresentation(self.images[i], 0.5)
                    let fileName = "\(userId)_\(TimeUtil.getUnixTimestamp())_\(i).jpg"
                    multipartFormData.append(imageData!, withName: "files", fileName: fileName, mimeType: "image/jpeg")
                }
        },
            to: url,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        let result = JSON(data: response.data!)
                        hud.dismiss()
                        if result[Constant.code].intValue == 200 {
                            self.dismiss(animated: false, completion: nil)
                        }else{
                            self.hudError(with: result[Constant.msg].stringValue)
                        }
                    }
                case .failure(let encodingError):
                    hud.dismiss()
                    self.hudError(with: encodingError.localizedDescription)
                }
        }
        )
    }
}
