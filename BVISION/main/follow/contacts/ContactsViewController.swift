//
//  ContactsViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/23.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import Contacts
import Messages
import MessageUI

class ContactsViewController: BasicViewController {
    
    var contactInfos = [ContactInfo]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cell = UINib.init(nibName: "ContactCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "ContactCell")
        tableView.dataSource = self
        tableView.delegate = self
        let status = CNContactStore.authorizationStatus(for: .contacts)
        if status != .authorized {
            requestAccessForContact()
        }else{
            getContacts()
        }
    }
    
    func getContacts(){
        let store = CNContactStore()
        let keys = [CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        do {
            try store.enumerateContacts(with: request, usingBlock: {(contact : CNContact, stop : UnsafeMutablePointer<ObjCBool>) -> Void in
                var contactInfo = ContactInfo()
                contactInfo.firstName = contact.givenName
                contactInfo.lastName = contact.familyName
                let phoneNumbers = contact.phoneNumbers
                for phoneNumber in phoneNumbers{
                    let number = phoneNumber.value.stringValue.replacingOccurrences(of: "-", with: "")
                    contactInfo.phones.append(number)
                }
//                let emailAddresses = contact.emailAddresses
//                for emailAddress in emailAddresses{
//                    print(emailAddress.label ?? "")
//                    print(emailAddress.value)
//                    contactInfo.emails.append(emailAddress.value as String)
//                }
                self.contactInfos.append(contactInfo)
                self.contactInfos.sort(by: { (c1, c2) -> Bool in
                    return "\(c1.lastName)\(c1.firstName)".compare("\(c2.lastName)\(c2.firstName)").rawValue == -1
                })
                self.tableView.reloadData()
            })
        } catch {
            print(error)
        }
        
    }

}



extension ContactsViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contactInfos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        cell.delegate = self
        let contactInfo = self.contactInfos[indexPath.row]
        cell.setContactInfo(contactInfo)
        return cell
    }
}


extension ContactsViewController: UITableViewDelegate{}


extension ContactsViewController{
    
    func requestAccessForContact() -> Void {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        switch status  {
        case .notDetermined:
            let store = CNContactStore()
            store.requestAccess(for: .contacts, completionHandler: { (isRight : Bool, error : Error?) in
                if isRight {
                    print("access success")
                    self.getContacts()
                } else {
                    print("access failure")
                }
            })
            break;
        case .authorized:
            DispatchQueue.main.async {
                self.getContacts()
            }
            break;
        case .denied:
            self.showOpenAuthDialog(NSLocalizedString("access contacts permission", comment: ""))
            break
        case .restricted:
            self.showOpenAuthDialog(NSLocalizedString("access contacts permission", comment: ""))
            break;
        }
    }
    
}



extension ContactsViewController: ContactCellDelegate{
    
    func sendMessage(_ contactInfo: ContactInfo) {
        let inviteCode = AESUtil.encrypt("\(TimeUtil.getUnixTimestamp())\(userId)")!
        self.showMessageComposeViewController(phones: contactInfo.phones as NSArray, title: "Join in us -> B·VISION:", body: "\(Constant.link_app_qrcode)\(inviteCode)")
    }
    
}



extension ContactsViewController: MFMessageComposeViewControllerDelegate{
    
    func showMessageComposeViewController(phones : NSArray, title : String, body: String){
        if MFMessageComposeViewController.canSendText() {
            let controller = MFMessageComposeViewController()
            controller.recipients = phones as? [String]
            controller.navigationBar.tintColor = UIColor.red
            controller.body = "\(title)\(body)"
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
            controller.viewControllers.last?.navigationItem.title = title
        } else{
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case .sent:
            hudSuccess(with: NSLocalizedString("send successfully", comment: ""))
            break
        case .failed:
            hudError(with: NSLocalizedString("send failure", comment: ""))
            break
        case .cancelled:
            break
        default:
            break
        }
        controller.dismiss(animated: false, completion: nil)
    }
    
}
