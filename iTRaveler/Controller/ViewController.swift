//
//  ViewController.swift
//  iTRaveler
//
//  Created by Erandra Jayasundara on 11/19/18.
//  Copyright © 2018 Erandra Jayasundara. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout,UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        newStatusLabel.textColor = .black
         self.newStatusLabel.text = ""
    }
    
    var missions = [Mission]()
    let newPostButton:UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named:"new_post"), for: .normal)
        button.addTarget(self, action: #selector(newPostPresent), for: .touchUpInside)
        return button
    }()
    let menu:UIView = {
        let v = UIView()
        v.backgroundColor = .red
        return v
    }()
    let newPost:UIView = {
        let post =  UIView()
        post.backgroundColor = .white
        return post
    }()
    let newPostSubmitButton:UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor(r:77,g:175,b:81).cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(newPostHide), for: .touchUpInside)
        button.setImage(UIImage(named: "share"), for: .normal)
        button.setTitleColor(UIColor(r:77,g:175,b:81), for: .normal)
        return button
    }()
    let postCloseButton:UIButton = {
       let btn = UIButton()
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = UIColor(r:77,g:175,b:81).cgColor
        btn.layer.borderWidth = 1
        btn.addTarget(self, action: #selector(newPostClose), for: .touchUpInside)
        btn.setImage(UIImage(named: "close"), for: .normal)
        btn.setTitleColor(UIColor(r:77,g:175,b:81), for: .normal)
        return btn
    }()
    let profileImageOnNewPost:UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let newPostNameLabel:UILabel = {
        let label = UILabel()
        label.text = "Erandra Jayasundara"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    let newStatusLabel:UITextView = {
        let textView = UITextView()
       
        textView.text = "What's on your mind"
        textView.textColor = .lightGray
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    let newPostScrollView:UIScrollView = {
        let scrollView = UIScrollView()
       
        scrollView.isExclusiveTouch = true
        
        return scrollView
    
    }()
    let galleryButton:UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = UIColor(r:77,g:175,b:81).cgColor
        btn.layer.borderWidth = 1
        btn.addTarget(self, action: #selector(handleUploadPostImage), for: .touchUpInside)
        btn.setImage(UIImage(named: "gallery"), for: .normal)
       
        return btn
    }()
    let statusImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    let statusImageViewCloseButton:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "close"), for: .normal)
        btn.addTarget(self, action: #selector(closeStatusImageView), for: .touchUpInside)
        return btn
    }()
    let postItemContainer:UIView = {
       let v = UIView()
        v.backgroundColor = .white
        v.isUserInteractionEnabled = true
        return v
    }()
    let profileImage:UIImageView = {
        let imageView = UIImageView()
        
        
        
        //profileImage.addTarget(self, action:#selector(self.clickProfileImage), for: .touchUpInside)
        
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    @objc func newPostClose(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations:{
            self.newPost.transform = self.newPost.transform.translatedBy(x: 0, y: 200)
            self.newPost.alpha = 0
        },completion:{(_) in
            self.newPost.removeFromSuperview()
            self.newStatusLabel.text = "What's on your mind"
            self.newStatusLabel.textColor = .lightGray
            self.statusImageView.removeFromSuperview()
        })
    }
    @objc func newPostHide(){
        SVProgressHUD.setForegroundColor(UIColor(r:77,g:175,b:81))
        SVProgressHUD.show()
        let imageName  = NSUUID().uuidString
        let sRef = Storage.storage().reference().child("statusImages").child("\(imageName).jpg")
        if let profileImagelink = statusImageView.image ,let uploadData = UIImageJPEGRepresentation(profileImagelink, 0.1){
                sRef.putData(uploadData, metadata: nil, completion: {(metadata,error) in
                    if error != nil{
                        print(error)
                        return
                    }
                let date = Date()
                let day = (date.month as? String)! + " " + date.dateOnly as? String
                    let ref = Database.database().reference().child("posts").child(self.uid!).child(imageName)
                    let urlt="statusImages/\(imageName).jpg"
                    let values = ["post":self.newStatusLabel.text,"fullName":self.newPostNameLabel.text,"date":day,"profileImage":self.imageURL as? String,"statusImage":urlt as? String]
                    ref.setValue(values) {
                        (error:Error?, ref:DatabaseReference) in
                        if let error = error {
                            print("Data could not be saved: \(error).")
                        } else {
                            print("Data saved successfully!")
                            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations:{
                                self.newPost.transform = self.newPost.transform.translatedBy(x: 0, y: 200)
                                self.newPost.alpha = 0
                            },completion:{(_) in
                                self.newPost.removeFromSuperview()
                                self.newStatusLabel.text = "What's on your mind"
                                self.newStatusLabel.textColor = .lightGray
                                self.statusImageView.image = nil
                            })
                            SVProgressHUD.dismiss()
                            self.missions.removeAll()
                            self.updatePost()
                            
                        }
                    }
                })
            }
        
    }
    

    @objc func newPostPresent(){
        view.addSubview(newPost)
        
        newPost.addSubview(newPostScrollView)
        newPost.addSubview(postItemContainer)
        postItemContainer.addSubview(newPostSubmitButton)
        postItemContainer.addSubview(profileImageOnNewPost)
        postItemContainer.addSubview(newPostNameLabel)
        postItemContainer.addSubview(postCloseButton)
        newPostScrollView.addSubview(newStatusLabel)
        postItemContainer.addSubview(galleryButton)
        
        
        newStatusLabel.delegate = self
        
        newPostScrollView.setAnchor(top:  profileImageOnNewPost.bottomAnchor, left: newPost.leftAnchor, bottom:newPost.bottomAnchor, right: newPost.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
      
        newStatusLabel.leadingAnchor.constraint(equalTo: newPostScrollView.leadingAnchor).isActive = true
        newStatusLabel.topAnchor.constraint(equalTo: newPostScrollView.topAnchor).isActive = true
        newStatusLabel.widthAnchor.constraint(equalTo: newPostScrollView.widthAnchor).isActive = true
        newStatusLabel.heightAnchor.constraint(equalToConstant:100 ).isActive = true
        
     
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        newPostScrollView.contentSize = CGSize(width: screenWidth, height: 1000)
        newPostScrollView.setContentOffset(CGPoint(x: 0, y: -10), animated: true)
        postItemContainer.setAnchor(top: newPost.topAnchor, left: newPost.leftAnchor, bottom: nil, right: newPost.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        newPostNameLabel.setAnchor(top: postItemContainer.topAnchor, left: profileImageOnNewPost.rightAnchor, bottom: nil, right: newPostSubmitButton.leftAnchor, paddingTop: 13, paddingLeft: 4, paddingBottom: 0, paddingRight: 0)
       
        profileImageOnNewPost.setAnchor(top: postItemContainer.topAnchor, left: postItemContainer.leftAnchor, bottom: postItemContainer.bottomAnchor, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 0, width: 40, height: 40)
       
        newPost.layer.shadowColor = UIColor(white: 0.4, alpha: 0.4).cgColor
        newPost.layer.shadowRadius = 8
        newPost.layer.shadowOpacity = 0.5
        newPost.setAnchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height:0)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.newPost.alpha=1
             self.newPost.transform = .identity
        })
        newPostSubmitButton.setAnchor(top: postItemContainer.topAnchor, left: nil, bottom: nil, right: postItemContainer.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 30, height: 30)
        postCloseButton.setAnchor(top: postItemContainer.topAnchor, left: nil, bottom: nil, right: galleryButton.leftAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 30, height: 30)
        galleryButton.setAnchor(top: postItemContainer.topAnchor, left: nil, bottom: nil, right: newPostSubmitButton.leftAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 30, height: 30)
        
        
    }
    
  
   let uid = Auth.auth().currentUser?.uid
    var imageURL:String = ""
    
    func updateProfileOfUser(){
        let puid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        ref.child("users").child(puid!).observeSingleEvent(of: .value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let fullName = (dictionary["fname"] as! String) + " " + (dictionary["lname"] as! String)
                self.imageURL = dictionary["profileImage"] as! String
                self.newPostNameLabel.text = fullName
                self.profileImageOnNewPost.loadImageUsingCacheWithUrl(urlString: dictionary["profileImage"] as! String)
                self.navigationItem.title = "Home"
                SVProgressHUD.dismiss()
                self.profileImage.loadImageUsingCacheWithUrl(urlString: dictionary["profileImage"] as! String)
                
                let imageItem = UIBarButtonItem(customView: self.profileImage)
                let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action:nil )
                negativeSpacer.width = -30
                self.navigationItem.leftBarButtonItem = imageItem
                
                let imag = UIImage(named: "logout")
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: imag, style: .plain, target: self, action:  #selector(self.handleLogout))
                self.profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickProfileImage)))
                self.view.addSubview(self.newPostButton)
                self.newPostButton.setAnchor(top: nil, left: nil, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 10, width: 60, height: 60)
            }
        }, withCancel:  nil)
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePost()
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        SVProgressHUD.setForegroundColor(UIColor(r:77,g:175,b:81))
        SVProgressHUD.show()
        if uid==nil{
            SVProgressHUD.dismiss()
            perform(#selector(handleLogout), with: nil,afterDelay: 0)
            handleLogout()
        }else{
            updateProfileOfUser()
        }
    }
    let cellId = "cellId"
    var firstTime = true
    override func viewWillAppear(_ animated: Bool) {
       
        if Auth.auth().currentUser?.uid != nil{
            if firstTime{
                updateProfileOfUser()
                firstTime = false
            }
            
        }else{
            print("else is running")
        }
    }
}


class Mission {
    var name: String?
    var status: String?
    var profileImageName: String?
    var statusImageName: String?
    var location: String?
    var date:String?
}

