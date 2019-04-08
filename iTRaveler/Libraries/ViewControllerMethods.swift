//
//  ViewControllerMethods.swift
//  iTRaveler
//
//  Created by Erandra Jayasundara on 12/27/18.
//  Copyright © 2018 Erandra Jayasundara. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import JSSAlertView

extension ViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @objc func handleUploadPostImage(){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: {() in
            self.addImagetoStatus()
        })
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
            statusImageView.image = selectImage
        }
        dismiss(animated: true, completion: nil)
    }
    func checkProfileUpdated(uid:String){
        
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with:{(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                if dictionary["fname"] == nil{
                    let profileEditController = ProfileEditController()
                    self.navigationController?.pushViewController(profileEditController, animated: true)
                }
            }
        })
    }
    @objc func closeStatusImageView(){
       self.statusImageView.removeFromSuperview()
    }
    func addImagetoStatus(){
        newPostScrollView.addSubview(statusImageView)
        
   
        statusImageView.addSubview(statusImageViewCloseButton)
        statusImageView.contentMode = .scaleAspectFit
        statusImageView.clipsToBounds = true
        statusImageView.topAnchor.constraint(equalTo: newStatusLabel.bottomAnchor).isActive = true
        statusImageView.widthAnchor.constraint(equalTo: newPostScrollView.widthAnchor).isActive = true
        statusImageView.bottomAnchor.constraint(equalTo: newPost.bottomAnchor).isActive = true
        
        statusImageViewCloseButton.setAnchor(top: statusImageView.topAnchor, left: nil, bottom: nil, right: statusImageView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 20, height: 20)
    }
    func updatePost(){
        
        Database.database().reference().child("posts").observe(.childAdded, with: { (snapshot) in
            if let array:NSArray = snapshot.children.allObjects as NSArray{
                for child in array{
                    let snap = child as! DataSnapshot
                    if let dictionary = snap.value as? [String:AnyObject]{
                        let mission = Mission()
                        mission.name = dictionary["fullName"] as? String
                        mission.status = dictionary["post"] as? String
                        mission.profileImageName = dictionary["profileImage"] as? String
                        mission.statusImageName = dictionary["statusImage"] as? String
                        mission.date = dictionary["date"] as? String
                        mission.location = "Kandy"
                        
                        self.missions.append(mission)
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                        
                    }
                }
            }
        }, withCancel: nil)
    }
    @objc func clickProfileImage(){
        let profileController=ProfileController()
         present(profileController,animated:true,completion:nil)
       // profileImage.removeFromSuperview()
       // navigationController?.pushViewController(profileController, animated: true)
      //  view.addSubview(menu)
      //  menu.setAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,width: (view.frame.width/3)*2,height: 0)
    }
    @objc func handleLogout(){
        do{
            try Auth.auth().signOut()
        }catch let logoutError{
            print(logoutError)
        }
        
        let loginController=LoginController()
        present(loginController,animated:true,completion:nil)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let statusText = missions[indexPath.item].status{
            let rect = NSString(string: statusText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14)], context: nil)
            let knownHeight:CGFloat = 8+44+4+4+300
            return CGSize(width: view.frame.width, height: rect.height+knownHeight+24)
        }
        return CGSize(width:view.frame.width,height:600)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return missions.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let missionCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        missionCell.mission = missions[indexPath.item]
        return missionCell
    }
    
}
extension Date{
    var month:String{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMMM"
        return dateformatter.string(from: self)
    }
    var dateOnly:String{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd"
        return dateformatter.string(from: self)
    }
}

extension UIView{
    func  addConstrainsWithFormat(format :String, views: UIView...){
        var viewDictionary = [String: UIView]()
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            viewDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary))
    }
}
