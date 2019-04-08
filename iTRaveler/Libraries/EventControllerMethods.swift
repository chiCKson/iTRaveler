//
//  EventControllerMethods.swift
//  iTRaveler
//
//  Created by Erandra Jayasundara on 1/28/19.
//  Copyright © 2019 Erandra Jayasundara. All rights reserved.
//
import UIKit
import Firebase
import SVProgressHUD
import JSSAlertView

extension EventController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    @objc func handleeditEventImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    func updateEvents(){
        SVProgressHUD.setForegroundColor(UIColor(r:77,g:175,b:81))
        SVProgressHUD.show()
        Database.database().reference().child("events").observe(.childAdded, with: { (snapshot) in
            if let array:NSArray = snapshot.children.allObjects as NSArray{
                for child in array{
                    let snap = child as! DataSnapshot
                    if let dictionary = snap.value as? [String:AnyObject]{
                        let event = Event()
                        event.name = dictionary["name"] as? String
                        event.date = dictionary["date"] as? String
                        event.description = dictionary["description"] as? String
                        event.location = dictionary["location"] as? String
                        event.eventImageName = dictionary["eventImage"] as? String
                        self.events.append(event)
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                        
                    }
                }
                SVProgressHUD.dismiss()
            }else{
                SVProgressHUD.dismiss()
            }
        }, withCancel: nil)
        
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
            eventImage.image = selectImage
        }
        dismiss(animated: true, completion: nil)
    }
    func updateDBWithEvent(){
        SVProgressHUD.setForegroundColor(UIColor(r:77,g:175,b:81))
        SVProgressHUD.show()
        let ref = Database.database().reference()
        let imageName  = NSUUID().uuidString
        let sRef = Storage.storage().reference().child("eventImages").child("\(imageName).jpg")
        if let profileImagelink = eventImage.image ,let uploadData = UIImageJPEGRepresentation(profileImagelink, 0.1){
            sRef.putData(uploadData, metadata: nil, completion: {(metadata,error) in
                if error != nil{
                    print(error)
                    return
                }
                
                let urlt="eventImages/\(imageName).jpg"
                let values = ["name":self.eventNameTextField.text,
                              "date":self.eventDateTextField.text,
                              "description":self.eventDescTextField.text,
                              "latitude" : self.latitude as? String,
                              "longitude" : self.longitude as? String,
                              "location":self.location as? String,
                              "eventImage":urlt as? String]
                ref.child("events").child((Auth.auth().currentUser?.uid)!).child(imageName).setValue(values) {
                    (error:Error?, ref:DatabaseReference) in
                    if let error = error {
                        print("Data could not be saved: \(error).")
                        self.showEventView()
                        SVProgressHUD.dismiss()
                    } else {
                        print("Data saved successfully!")
                        SVProgressHUD.dismiss()
                        self.showEventView()
                        DispatchQueue.main.async{
                            self.collectionView?.reloadData()
                        }
                      
                    }
                    
                }
            })
        }
    }
}
