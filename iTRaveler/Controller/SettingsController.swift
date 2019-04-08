//
//  SettingsController.swift
//  iTRaveler
//
//  Created by Erandra Jayasundara on 12/2/18.
//  Copyright © 2018 Erandra Jayasundara. All rights reserved.
//

import UIKit
import Firebase
class SettingsController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let settingscellId = "settingscellId"
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  section == 1 {
            return generalSettingsArray.count
        }
        return privacySettingsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: settingscellId, for: indexPath) as!  SettingCell
        if indexPath.section == 1 {
            cell.pictureImageView.image = UIImage(named: generalSettingsArray[indexPath.item].image!)
            cell.titleLabel.text = generalSettingsArray[indexPath.item].title
            
            return cell
        }
        cell.pictureImageView.image = UIImage(named: privacySettingsArray[indexPath.item].image!)
        cell.titleLabel.text = privacySettingsArray[indexPath.item].title
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Profile"
        }
        return "General"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0{
                let profileEditController = ProfileEditController()
                navigationController?.pushViewController(profileEditController, animated: true)
                
            }
            if indexPath.row == 1{
                do{
                    try Auth.auth().signOut()
                }catch let logoutError{
                    print(logoutError)
                }
                
                let loginController=LoginController()
                present(loginController,animated:true,completion:nil)
                
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.allowsSelection = true
        return tv
    }()
    
    let generalSettingsArray = [Info(image:"profile",title:"Edit Profile"),
                                Info(image:"setting",title:"Profile Settings"),
                                Info(image:"map",title:"Map Settings")]
    let privacySettingsArray = [Info(image:"mission",title:"Misison Settings"),
                                Info(image:"map",title:"Help"),
                                Info(image:"profile",title:"About"),
                                Info(image:"setting",title:"Settings")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "More"
        setupTableView()
        
    }
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingCell.self, forCellReuseIdentifier: settingscellId)
        view.addSubview(tableView)
        tableView.setAnchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
       
    }
    

    

}
class SettingCell:UITableViewCell{
    
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.setCellShadow()
        return view
    }()
    let arrow: UIImageView = {
        let arrowImage = UIImageView()
        arrowImage.image = UIImage(named: "arrow_right")
        arrowImage.contentMode = .scaleAspectFit
        return arrowImage
    }()
    let pictureImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        
        return iv
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style:style,reuseIdentifier:reuseIdentifier)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)has not implemented")
    }
   
    func setup(){
        backgroundColor = UIColor(r: 246, g: 245, b: 245)
        
        addSubview(cellView)
        cellView.addSubview(pictureImageView)
        cellView.addSubview(titleLabel)
        cellView.addSubview(arrow)
        
        cellView.setAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8)
        
        pictureImageView.setAnchor(top: nil, left: cellView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        pictureImageView.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        
        titleLabel.setAnchor(top: nil, left: pictureImageView.rightAnchor, bottom: nil, right: arrow.leftAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 30)
        titleLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        
        arrow.setAnchor(top: nil, left: nil, bottom: nil, right: cellView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 15, height: 15)
        arrow.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        
        
    }
    
}
