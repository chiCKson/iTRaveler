//
//  FeedCell.swift
//  iTRaveler
//
//  Created by Erandra Jayasundara on 12/29/18.
//  Copyright © 2018 Erandra Jayasundara. All rights reserved.
//
import UIKit

class FeedCell: UICollectionViewCell {
    var mission: Mission? {
        didSet{
            if let missionName = mission?.name{
                let attributeText = NSMutableAttributedString(string: missionName, attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 14)])
                attributeText.append(NSAttributedString(string: "\n"+(mission?.date!)!+" • "+(mission?.location!)!+" • ", attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 12),NSAttributedStringKey.foregroundColor:UIColor(r: 155, g: 161, b: 171)]))
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4
                attributeText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributeText.string.count))
                
                let attachment = NSTextAttachment()
                attachment.image = UIImage(named: "globe_icon")
                attachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
                attributeText.append(NSAttributedString(attachment: attachment))
                nameLabel.attributedText=attributeText
            }
            if let statusText = mission?.status{
                statusLabel.text = statusText
                
            }
            if let profileImageName = mission?.profileImageName {
                profileImageView.loadImageUsingCacheWithUrl(urlString: profileImageName)
            }
            if let statusImageName = mission?.statusImageName{
                statusImage.frame = CGRect(x: 0, y: 0, width: frame.width, height: 300)
                statusImage.loadImageUsingCacheWithUrl(urlString: statusImageName)
                
              
            }
            if mission?.statusImageName == nil{
                
                willRemoveSubview(statusImage)
            }
            
            
        }
    }
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init coder has not been implemented")
    }
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    let profileImageView:UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "profile")
        imageView.image = image
        imageView.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let joinButton:UIButton = {
        let button = UIButton()
    
        button.setTitleColor(UIColor(r:77,g:175,b:81), for: .normal)
        button.setImage(UIImage(named: "more_menu"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    let statusLabel:UITextView = {
        let textView = UITextView()
        textView.text = "Clean kandy city on this month end."
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        textView.isEditable = false
        return textView
    }()
    let statusImage:UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    func setupViews(){
        backgroundColor = UIColor.white
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(joinButton)
        addSubview(statusLabel)
        addSubview(statusImage)
       addConstrainsWithFormat(format: "H:|-8-[v0(44)]-8-[v1]-8-[v2(15)]-2-|", views: profileImageView, nameLabel,joinButton)
        addConstrainsWithFormat(format: "V:|-8-[v0(15)]", views: joinButton)
        addConstrainsWithFormat(format: "H:|-4-[v0]-4-|", views: statusLabel)
       // addConstrainsWithFormat(format: "H:|[v0]", views: statusImage)
        addConstrainsWithFormat(format: "V:|-8-[v0]", views: nameLabel)
        addConstrainsWithFormat(format:  "V:|-8-[v0(44)]-4-[v1]", views: profileImageView,statusLabel)
        statusImage.setAnchor(top: statusLabel.bottomAnchor, left: nil, bottom: nil, right: window?.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,width: frame.width,height: 300)
    }
}

