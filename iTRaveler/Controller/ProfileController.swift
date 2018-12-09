//
//  ProfileController.swift
//  iTRaveler
//
//  Created by Erandra Jayasundara on 12/6/18.
//  Copyright © 2018 Erandra Jayasundara. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {

    let navigationBar:UINavigationBar = {
        let navigation = UINavigationBar()
        navigation.barTintColor = UIColor(r:77,g:175,b:81)
        navigation.isTranslucent = false
        return navigation
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
        
        return scrollView
    }()
    let profileName:UILabel = {
        let nameLAbel = UILabel()
        nameLAbel.translatesAutoresizingMaskIntoConstraints = false
        nameLAbel.font = UIFont.systemFont(ofSize: 18)
        nameLAbel.textAlignment = .center
        return nameLAbel
    }()
    let rank:UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 77, g: 175, b: 81)
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let level:UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 77, g: 175, b: 81)
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let levelLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 77, g: 175, b: 81)
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "Level"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let rankLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 77, g: 175, b: 81)
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "Global Rank"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        return imageView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        rank.text = "123"
        level.text = "30"
        profileName.text = "Erandra Jaysunadara"
        let coverImageName = "kandy"
        let profile = "erandra"
        
        
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(r:77,g:175,b:81)
        view.backgroundColor = .white
        
        view.addSubview(navigationBar)
        view.addSubview(profileScrollView)
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        profileScrollView.contentSize = CGSize(width: screenWidth, height: 1000)
        navigationBar.setAnchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        profileScrollView.setAnchor(top: navigationBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        profileScrollView.addSubview(coverImage)
        profileScrollView.addSubview(profileImage)
        profileScrollView.addSubview(profileName)
        profileScrollView.addSubview(rank)
        profileScrollView.addSubview(rankLabel)
        profileScrollView.addSubview(level)
        profileScrollView.addSubview(levelLabel)
        
        
        levelLabel.topAnchor.constraint(equalTo: level.bottomAnchor).isActive = true
        levelLabel.centerXAnchor.constraint(equalTo: level.centerXAnchor).isActive = true
        
        level.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 20).isActive = true
        level.leftAnchor.constraint(equalTo: rank.rightAnchor, constant: 50).isActive = true
        
        rankLabel.topAnchor.constraint(equalTo: rank.bottomAnchor).isActive = true
        rankLabel.centerXAnchor.constraint(equalTo: rank.centerXAnchor).isActive = true
        
        rank.topAnchor.constraint(equalTo: profileName.bottomAnchor,constant:20).isActive = true
        rank.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 50).isActive = true
       
        
        profileName.topAnchor.constraint(equalTo: profileImage.bottomAnchor).isActive = true
        profileName.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileName.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: coverImage.bottomAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        profileImage.image = UIImage(named: profile )
        
        coverImage.leadingAnchor.constraint(equalTo: profileScrollView.leadingAnchor).isActive = true
        coverImage.topAnchor.constraint(equalTo: profileScrollView.topAnchor).isActive = true
        coverImage.widthAnchor.constraint(equalTo: profileScrollView.widthAnchor).isActive = true
        coverImage.heightAnchor.constraint(equalToConstant:view.frame.height/3 ).isActive = true
       
        
        let backImage = UIButton(type: .system)
        backImage.setImage(UIImage(named: "arrow_left"), for: .normal)
        backImage.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        backImage.addTarget(self, action:#selector(clickBackButton), for: .touchUpInside)
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImage)
        coverImage.image = UIImage(named: coverImageName)
        let image = UIImage(named: "logout")
        let navItem = UINavigationItem(title: "Profile")
        let logoutItem = UIBarButtonItem(image: image, style: .plain, target: self, action:  #selector(handleLogout))
        navItem.rightBarButtonItem = logoutItem
        navItem.leftBarButtonItem = UIBarButtonItem(customView: backImage)
        navigationBar.setItems([navItem], animated: false)
        
    }
    @objc func clickBackButton(){
        self.dismiss(animated: true, completion: nil)
    }
    @objc func handleLogout(){
        
    }
    


}
extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector("statusBar")) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}
