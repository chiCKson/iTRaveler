//
//  ProfileController.swift
//  iTRaveler
//
//  Created by Erandra Jayasundara on 12/6/18.
//  Copyright © 2018 Erandra Jayasundara. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
class ProfileController: UIViewController {

    let closeButton:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "close"), for: .normal)
        return btn
    }()
    let coverImage:UIImageView = {
        let cover = UIImageView()
        cover.contentMode = .scaleAspectFill
        cover.translatesAutoresizingMaskIntoConstraints = false
        return cover
    }()
    let profileScrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isExclusiveTouch = true
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()
    let profileName:UILabel = {
        let nameLAbel = UILabel()
        nameLAbel.translatesAutoresizingMaskIntoConstraints = false
        nameLAbel.font = UIFont.systemFont(ofSize: 18)
        nameLAbel.textAlignment = .center
        return nameLAbel
    }()
 
    let score:UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 77, g: 175, b: 81)
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let scoreLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 77, g: 175, b: 81)
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "Score"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
  
    let inputContainerView:UIView={
        let view=UIView()
  
        view.translatesAutoresizingMaskIntoConstraints=false
        view.layer.cornerRadius=5
        view.layer.masksToBounds=true
        return view
    }()
   
    let profileImage:UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.isUserInteractionEnabled = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setForegroundColor(UIColor(r:77,g:175,b:81))
        SVProgressHUD.show()
        
        score.text = "0000"
        profileName.text = "Erandra Jaysunadara"
        let coverImageName = "kandy"
        
        let ref = Database.database().reference()
       
        let uid = Auth.auth().currentUser?.uid
        ref.child("score").observeSingleEvent(of: .value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                self.score.text = dictionary[uid!] as! String
            }
        }, withCancel:  nil)
        ref.child("users").child(uid!).observeSingleEvent(of: .value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                self.profileImage.loadImageUsingCacheWithUrl(urlString: dictionary["profileImage"] as! String)
                var fullname = ""
                fullname.append(dictionary["fname"] as! String)
                fullname.append(" ")
                fullname.append(dictionary["lname"] as! String)
                self.profileName.text = fullname
            }
        }, withCancel:  nil)
        
        
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(r:77,g:175,b:81)
        view.backgroundColor = .white
        
        
        view.addSubview(profileScrollView)
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        profileScrollView.contentSize = CGSize(width: screenWidth, height: 1000)
        
        profileScrollView.setAnchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        profileScrollView.addSubview(coverImage)
        profileScrollView.addSubview(profileImage)
        profileScrollView.addSubview(profileName)
        profileScrollView.addSubview(inputContainerView)

        inputContainerView.addSubview(score)
       // inputContainerView.addSubview(scoreLabel)
        coverImage.addSubview(closeButton)
        coverImage.isUserInteractionEnabled = true
        closeButton.setAnchor(top: coverImage.topAnchor, left: nil, bottom: nil, right: coverImage.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 10,width: 20,height: 20)
        closeButton.addTarget(self, action:#selector(clickBackButton), for: .touchUpInside)
        inputContainerView.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 20).isActive = true
        inputContainerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        inputContainerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        inputContainerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
     
        
    
        
       
        
       
       
        
        
        profileName.topAnchor.constraint(equalTo: profileImage.bottomAnchor).isActive = true
        profileName.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor).isActive = true
        profileName.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: coverImage.bottomAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        score.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        score.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor).isActive = true
       
        
        coverImage.leadingAnchor.constraint(equalTo: profileScrollView.leadingAnchor).isActive = true
        coverImage.topAnchor.constraint(equalTo: profileScrollView.topAnchor).isActive = true
        coverImage.widthAnchor.constraint(equalTo: profileScrollView.widthAnchor).isActive = true
        coverImage.heightAnchor.constraint(equalToConstant:view.frame.height/3 ).isActive = true
       
        
        
       
        coverImage.image = UIImage(named: coverImageName)
    
        navigationItem.title = "Profile"
        let imag = UIImage(named: "logout")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: imag, style: .plain, target: self, action:  #selector(handleLogout))
       
      
        
    }
   
    @objc func clickBackButton(){
        self.dismiss(animated: true, completion: nil)
    }
    @objc func handleLogout(){
        
    }
    


}
extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}
