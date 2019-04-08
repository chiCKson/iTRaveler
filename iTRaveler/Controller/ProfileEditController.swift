//
//  ProfileEditController.swift
//  iTRaveler
//
//  Created by Erandra Jayasundara on 12/24/18.
//  Copyright © 2018 Erandra Jayasundara. All rights reserved.
//

import UIKit
import JSSAlertView
import SVProgressHUD
import Firebase

class ProfileEditController: UIViewController,UITextFieldDelegate {
    let coverImage:UIImageView = {
        let cover = UIImageView()
        cover.contentMode = .scaleAspectFill
        cover.isUserInteractionEnabled = true
        cover.translatesAutoresizingMaskIntoConstraints = false
        return cover
    }()
    let editCoverIcon:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "edit"), for: .normal)
        //btn.addTarget(self, action: #selector(handleeditProfileImage), for: .touchUpInside)
        return btn
    }()
    let editProfileImage:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(r:77,g:175,b:81)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("Edit", for: .normal)
        btn.addTarget(self, action: #selector(handleeditProfileImage), for: .touchUpInside)
        btn.alpha = 0.50
        return btn
    }()
   
    let profileScrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isExclusiveTouch = true
        
        return scrollView
    }()
    let profileImage:UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    let nameTextField:UITextField = {
        let tf=UITextField()
        tf.placeholder="User Name"
        tf.textColor=UIColor(r:77,g:175,b:81)
        tf.layer.borderColor = UIColor(r:77,g:175,b:81).cgColor
        tf.layer.borderWidth = 1.0
        tf.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        return tf
    }()
    let fnameTextField:UITextField = {
        let tf=UITextField()
        tf.placeholder="First Name"
        tf.textColor=UIColor(r:77,g:175,b:81)
        tf.layer.borderColor = UIColor(r:77,g:175,b:81).cgColor
        tf.layer.borderWidth = 1.0
        tf.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        return tf
    }()
    let lnameTextField:UITextField = {
        let tf=UITextField()
        tf.placeholder="Last Name"
        tf.textColor=UIColor(r:77,g:175,b:81)
        tf.layer.borderColor = UIColor(r:77,g:175,b:81).cgColor
        tf.layer.borderWidth = 1.0
        tf.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        return tf
    }()
    let emailTextField:UITextField = {
        let tf=UITextField()
        tf.placeholder="E-mail"
        tf.textColor=UIColor(r:77,g:175,b:81)
        tf.layer.borderColor = UIColor(r:77,g:175,b:81).cgColor
        tf.layer.borderWidth = 1.0
        tf.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        return tf
    }()
    let phoneNoField:UITextField = {
        let tf=UITextField()
        let prefix = UILabel()
        prefix.text = "+94"
        prefix.textColor = UIColor(r:77,g:175,b:81)
        prefix.sizeToFit()
        tf.leftView = prefix
        tf.leftViewMode = .always
        tf.textColor=UIColor(r:77,g:175,b:81)
        tf.layer.borderColor = UIColor(r:77,g:175,b:81).cgColor
        tf.layer.borderWidth = 1.0
        tf.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        return tf
    }()
    let contactDetailsLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r:77,g:175,b:81)
        label.text = "CONTACT DETAILS"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    let securityDetailsLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r:77,g:175,b:81)
        label.text = "SECURITY DETAILS"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    let updateButton:UIButton={
        let button=UIButton(type: .system)
        button.backgroundColor=UIColor(r:77,g:175,b:81)
        button.setTitle("Update Profile", for: .normal)
        button.layer.cornerRadius=5
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.masksToBounds=true
        button.titleLabel?.font=UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints=false
        button.addTarget(self, action: #selector(updateProfile), for: .touchUpInside)
        return button
    }()
    let passwordChangeButton:UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor(r:77,g:175,b:81).cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(changePassword), for: .touchUpInside)
        button.setTitle("Change Password", for: .normal)
        button.setTitleColor(UIColor(r:77,g:175,b:81), for: .normal)
        return button
    }()
    let ref = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    var typeOfUser = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(r:77,g:175,b:81)
        navigationItem.title = "Edit Profile"
        view.backgroundColor = .white
        
        SVProgressHUD.setForegroundColor(UIColor(r:77,g:175,b:81))
        SVProgressHUD.show()
        
    
        fetchUser(uid: uid!,ref: ref)
    }
    
    
    @objc func updateProfile(){
        updateDBWithProfile(uid: uid!,ref: ref)
    }
    
    
    
    func populateUi(profile:String,coverImageName:String,name:String,email:String,fname:String,lname:String,phone:String){
      
        view.addSubview(profileScrollView)
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        profileScrollView.contentSize = CGSize(width: screenWidth, height: 1000)
        profileScrollView.setAnchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        profileScrollView.addSubview(coverImage)
        profileScrollView.addSubview(profileImage)
        
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: coverImage.bottomAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        
        profileImage.addSubview(editProfileImage)
        editProfileImage.setAnchor(top: nil, left: profileImage.leftAnchor, bottom: profileImage.bottomAnchor, right: profileImage.rightAnchor
            , paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
        
        
        
        coverImage.leadingAnchor.constraint(equalTo: profileScrollView.leadingAnchor).isActive = true
        coverImage.topAnchor.constraint(equalTo: profileScrollView.topAnchor).isActive = true
        coverImage.widthAnchor.constraint(equalTo: profileScrollView.widthAnchor).isActive = true
        coverImage.heightAnchor.constraint(equalToConstant:view.frame.height/3 ).isActive = true
        coverImage.image = UIImage(named: coverImageName)
        
        coverImage.addSubview(editCoverIcon)
        editCoverIcon.setAnchor(top: coverImage.topAnchor, left:nil, bottom: nil, right: coverImage.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 30, height: 30)
        
        profileScrollView.addSubview(contactDetailsLabel)
        contactDetailsLabel.setAnchor(top: profileImage.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        profileScrollView.addSubview(nameTextField)
        nameTextField.setAnchor(top: contactDetailsLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 40)
        nameTextField.text = name
        profileScrollView.addSubview(fnameTextField)
        profileScrollView.addSubview(lnameTextField)
        fnameTextField.setAnchor(top: nameTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 5, width: (view.frame.size.width-30)/2, height: 40)
        fnameTextField.text = fname
        fnameTextField.delegate = self
        lnameTextField.setAnchor(top: nameTextField.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 10, width: (view.frame.size.width-30)/2, height: 40)
        lnameTextField.text = lname
        lnameTextField.delegate = self
        profileScrollView.addSubview(emailTextField)
        emailTextField.setAnchor(top: fnameTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 40)
        emailTextField.text = email
        profileScrollView.addSubview(phoneNoField)
        phoneNoField.setAnchor(top: emailTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 40)
        phoneNoField.text = phone
        phoneNoField.delegate = self
        profileScrollView.addSubview(securityDetailsLabel)
        securityDetailsLabel.setAnchor(top: phoneNoField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        profileScrollView.addSubview(passwordChangeButton)
        passwordChangeButton.setAnchor(top: securityDetailsLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 40)
        profileScrollView.addSubview(updateButton)
        updateButton.setAnchor(top: passwordChangeButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 40)
    }
    

  

}
