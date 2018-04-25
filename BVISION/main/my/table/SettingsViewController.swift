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
import MMPopupView


class SettingsViewController: BasicTableViewController {

    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var laGender: UILabel!
    @IBOutlet weak var laProfile: UILabel!
    
    lazy var userSetGenderProvider = {
        return UserSetGenderProvider()
    }()
    
    lazy var userSetProfileProvider = {
        return UserSetProfileProvider()
    }()
    
    var hud: JGProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userSetGenderProvider.loadDelegate = self
        userSetProfileProvider.loadDelegate = self
        self.ivIcon.layer.cornerRadius = ivIcon.frame.width / 2
        self.ivIcon.layer.masksToBounds = true
        if let icon = UFUtils.getString(Constant.key_user_icon) {
            let url = URL(string: icon)
            ivIcon.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "hold_person"))
        }
        let gender = UFUtils.getInt(Constant.key_user_gender)
        if gender == 1{
            laGender.text = NSLocalizedString("Male", comment: "")
        }else{
            laGender.text = NSLocalizedString("Female", comment: "")
        }
        if let profile = UFUtils.getString(Constant.key_user_profile){
            laProfile.text = profile
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            pickPhoto()
        }
        if indexPath.section == 1 && indexPath.row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            self.showSetGenderDialog()
        }
        if indexPath.section == 1 && indexPath.row == 1 {
            tableView.deselectRow(at: indexPath, animated: true)
            self.showSetProfileDialog()
        }
    }
    
    @IBAction func signOut(){
        UFUtils.clean()
        self.showSignBoard()
    }
}



extension SettingsViewController: UserSetGenderProviderDelegate, UserSetProfileProviderDelegate{
    
    func showSetGenderDialog(){
        var alertItems = [MMPopupItem]()
        let maleItem = MMItemMake(NSLocalizedString("Male", comment: ""), .normal) { (position) in
            self.hud = self.hudLoading()
            self.userSetGenderProvider.load(gender: 1)
        }
        let femaleItem = MMItemMake(NSLocalizedString("Female", comment: ""), .normal) { (position) in
            self.hud = self.hudLoading()
            self.userSetGenderProvider.load(gender: 0)
        }
        alertItems.append(maleItem!)
        alertItems.append(femaleItem!)
        let alertSheetView = MMSheetView .init(title: "", items: alertItems)
        alertSheetView?.backgroundColor = UIColor.darkGray
        alertSheetView?.show()
    }
    
    func loadSuccess(gender: Int) {
        self.hud?.dismiss()
        hudSuccess(with: "successfully")
        UFUtils.set(gender, key: Constant.key_user_gender)
        if gender == 1{
            self.laGender.text = NSLocalizedString("Male", comment: "")
        }else{
            self.laGender.text = NSLocalizedString("Female", comment: "")
        }
    }
    
    func showSetProfileDialog(){
        let alertView = MMAlertView.init(inputTitle:  NSLocalizedString("Set profile", comment: ""), detail: "", placeholder:  NSLocalizedString("type in profile", comment: "")) { (alias) in
            var profile = ""
            if (alias?.count)! > 0{
                profile = alias!
            }else{
                return
            }
            self.hud = self.hudLoading()
            self.userSetProfileProvider.load(profile: profile)
        }
        alertView?.show()
    }
    
    func loadSuccess(profile: String) {
        self.hud?.dismiss()
        hudSuccess(with: NSLocalizedString("Successfully", comment: ""))
        UFUtils.set(profile, key: Constant.key_user_profile)
        self.laProfile.text = profile
    }
    
    func loadFailure(_ message: String, _ error: Error?) {
        self.hud?.dismiss()
        hudError(with: message)
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
    
    func uploadUserIcon(_ image: UIImage){
        if userId <= 0 {
            hudError(with: NSLocalizedString("has no sign in", comment: ""))
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
