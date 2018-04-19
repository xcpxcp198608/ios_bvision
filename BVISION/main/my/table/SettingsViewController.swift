//
//  SettingsViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/18.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import JGProgressHUD
import Alamofire
import SwiftyJSON

class SettingsViewController: BasicTableViewController {

    @IBOutlet weak var ivIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ivIcon.layer.cornerRadius = ivIcon.frame.width / 2
        self.ivIcon.layer.masksToBounds = true
        if let icon = UFUtils.getString(Constant.key_user_icon) {
            let url = URL(string: icon)
            ivIcon.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "hold_person"))
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            pickPhoto()
        }
    }
    
    @IBAction func signOut(){
        UFUtils.clean()
        self.showSignBoard()
    }
}


extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imagePreview = info[UIImagePickerControllerEditedImage] as? UIImage
        if let newImage = imagePreview {
            uploadUserIcon(newImage)
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
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler:  { _ in self.takePhotoWithCamera() })
        alertController.addAction(takePhotoAction)
        let chooseFromLibraryAction = UIAlertAction(title:
            "Choose From Library", style: .default, handler:  { _ in self.choosePhotoFromLibrary() })
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
    
    func uploadUserIcon(_ image: UIImage){
        if userId <= 0 {
            hudError(with: "no sign in")
            return
        }
        let hud = hudLoading()
        let url = "\(Constant.url_user_upload_icon)/\(userId)"
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
                        print(result)
                        if result["code"].intValue == 200 {
                            UFUtils.set(result["data"]["icon"].stringValue, key: Constant.key_user_icon)
                            self.ivIcon.image = image
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
