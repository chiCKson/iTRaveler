//
//  ProfileEditControllerMethods.swift
//  iTRaveler
//
//  Created by Erandra Jayasundara on 12/26/18.
//  Copyright © 2018 Erandra Jayasundara. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import JSSAlertView

extension ProfileEditController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    @objc func handleeditProfileImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker:UIImage?
        if let edittedImage = info["UIImagePickerControllerEditedImage"]{
            selectedImageFromPicker = edittedImage as? UIImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"]{
            selectedImageFromPicker = originalImage as? UIImage
        }
        if let selectImage = selectedImageFromPicker{
            profileImage.image = selectImage
        }
        dismiss(animated: true, completion: nil)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    func updateDBWithProfile(uid:String,ref:DatabaseReference){
        SVProgressHUD.setForegroundColor(UIColor(r:77,g:175,b:81))
        SVProgressHUD.show()
        let imageName  = NSUUID().uuidString
        let sRef = Storage.storage().reference().child("profileImages").child("\(imageName).jpg")
        if let profileImagelink = profileImage.image ,let uploadData = UIImageJPEGRepresentation(profileImagelink, 0.1){
            sRef.putData(uploadData, metadata: nil, completion: {(metadata,error) in
                if error != nil{
                    print(error)
                    return
                }
                
                    let urlt="profileImages/\(imageName).jpg"
                    let values = ["name":self.nameTextField.text,"email":self.emailTextField.text,"fname":self.fnameTextField.text,"lname":self.lnameTextField.text,"phone":self.phoneNoField.text,"type":self.typeOfUser as? String,"profileImage":urlt as? String]
                    ref.child("users").child(uid).setValue(values) {
                        (error:Error?, ref:DatabaseReference) in
                        if let error = error {
                            print("Data could not be saved: \(error).")
                        } else {
                            print("Data saved successfully!")
                            SVProgressHUD.dismiss()
                            self.dismiss(animated: true, completion: nil)
                        }
                    
                }
            })
        }
       
    }
    func fetchUser(uid:String,ref:DatabaseReference){
        
        
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let coverImageName = "kandy"
                let profile = "erandra"
                if dictionary["type"] == nil{
                    self.typeOfUser = "user"
                }else{
                    self.typeOfUser = "admin"
                }
                if dictionary["fname"] == nil{
                    self.populateUi(profile: profile, coverImageName: coverImageName, name: (dictionary["name"] as? String)!, email: (dictionary["email"] as? String)!, fname: "Not yet Updated", lname: "Not yet Updated", phone: "Not yet updated")
                    self.profileImage.image = UIImage(named: "erandra")
                    SVProgressHUD.dismiss()
                    
                }else{
                    self.populateUi(profile: profile, coverImageName: coverImageName,name: (dictionary["name"] as? String)!,email: (dictionary["email"] as? String)!,fname:(dictionary["fname"] as? String)!,lname:(dictionary["lname"] as? String)!,phone: (dictionary["phone"] as? String)!)
                    SVProgressHUD.dismiss()
                    self.profileImage.loadImageUsingCacheWithUrl(urlString: dictionary["profileImage"] as! String)
                }
            }
        }, withCancel:  nil)
    }
    @objc func changePassword(){
        let customIcon = UIImage(named: "testlg")
        let customColor = UIColor(r:77,g:175,b:81)
        JSSAlertView().show(
            self,
            title: "Change password",
            text: "Password change link is send to your email, please check your inbox.",
            buttonText: "OK",
            color: customColor,
            iconImage: customIcon).setTextTheme(.light)
    }
}
