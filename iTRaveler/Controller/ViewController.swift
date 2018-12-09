//
//  ViewController.swift
//  iTRaveler
//
//  Created by Erandra Jayasundara on 11/19/18.
//  Copyright © 2018 Erandra Jayasundara. All rights reserved.
//

import UIKit
import Firebase

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
        button.setTitle("Share", for: .normal)
        button.setTitleColor(UIColor(r:77,g:175,b:81), for: .normal)
        return button
    }()
    let profileImageOnNewPost:UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "erandra")
        imageView.image = image
        imageView.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.clipsToBounds = true
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
    @objc func newPostHide(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations:{
            self.newPost.transform = self.newPost.transform.translatedBy(x: 0, y: 200)
            self.newPost.alpha = 0
        },completion:{(_) in
            self.newPost.removeFromSuperview()
            self.newStatusLabel.text = "What's on your mind"
            self.newStatusLabel.textColor = .lightGray
        })
    }

    @objc func newPostPresent(){
        view.addSubview(newPost)
        newPost.addSubview(newPostSubmitButton)
        newPost.addSubview(profileImageOnNewPost)
        newPost.addSubview(newPostNameLabel)
        newPost.addSubview(newPostScrollView)
        newPostScrollView.addSubview(newStatusLabel)
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
        
        newPostNameLabel.setAnchor(top: newPost.topAnchor, left: profileImageOnNewPost.rightAnchor, bottom: nil, right: newPostSubmitButton.leftAnchor, paddingTop: 13, paddingLeft: 4, paddingBottom: 0, paddingRight: 0)
        profileImageOnNewPost.setAnchor(top: newPost.topAnchor, left: newPost.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        newPost.layer.shadowColor = UIColor(white: 0.4, alpha: 0.4).cgColor
        newPost.layer.shadowRadius = 8
        newPost.layer.shadowOpacity = 0.5
        newPost.setAnchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: (view.frame.height/3)*2)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.newPost.alpha=1
             self.newPost.transform = .identity
        })
        newPostSubmitButton.setAnchor(top: newPost.topAnchor, left: nil, bottom: nil, right: newPost.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 70, height: 30)
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
       
        
        let erandra = Mission()
        erandra.name = "Erandra Jayasundara"
        erandra.status = "Clean Kandy city this month end.Kandy city has the most polluted air in Sri Lanka."
        erandra.profileImageName = "erandra"
        erandra.statusImageName = "kandy"
        erandra.date = "December 18"
        erandra.location = "Kandy"
        
        
        let mark = Mission()
        mark.date = "January 31"
        mark.location = "Hatton"
        mark.name = "Mark Anthony"
        mark.status = "Graw some plantation in sinharaja forest."
        mark.profileImageName = "marc"
        mark.statusImageName = "sinharaja"
        
        
        let nisal = Mission()
        nisal.date = "January 31"
        nisal.location = "Hatton"
        nisal.name = "Nisal Perera"
        nisal.status = "Graw some plantation in sinharaja forest."
        nisal.profileImageName = "marc"
        nisal.statusImageName = "sinharaja"
        
        
        missions.append(erandra)
        missions.append(mark)
        missions.append(nisal)
        
        
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        
        
        navigationItem.title = "Home"
        let profileImage = UIButton(type: .system)
        profileImage.setImage(UIImage(named: "era")?.withRenderingMode(.alwaysOriginal), for: .normal)
        profileImage.addTarget(self, action:#selector(clickProfileImage), for: .touchUpInside)
        profileImage.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.layer.masksToBounds = true
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImage)
       
        let imag = UIImage(named: "logout")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: imag, style: .plain, target: self, action:  #selector(handleLogout))
    
        view.addSubview(newPostButton)
        newPostButton.setAnchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 10, width: 60, height: 60)
        
       
        if Auth.auth().currentUser?.uid==nil{
            perform(#selector(handleLogout), with: nil,afterDelay: 0)
            handleLogout()
        }
        
    }
    @objc func clickProfileImage(){
        let profileController=ProfileController()
        present(profileController,animated:true,completion:nil)
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

    let cellId = "cellId"
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return missions.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let missionCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        missionCell.mission = missions[indexPath.item]
        return missionCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let statusText = missions[indexPath.item].status{
            let rect = NSString(string: statusText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14)], context: nil)
            let knownHeight:CGFloat = 8+44+4+4+200
            return CGSize(width: view.frame.width, height: rect.height+knownHeight+24)
        }
        return CGSize(width:view.frame.width,height:500)
    }
    


}
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
                profileImageView.image = UIImage(named: profileImageName)
            }
            if let statusImageName = mission?.statusImageName{
                statusImage.image = UIImage(named: statusImageName)
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
        let image = UIImage(named: "erandra")
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
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor(r:77,g:175,b:81).cgColor
        button.layer.borderWidth = 1
        button.setTitleColor(UIColor(r:77,g:175,b:81), for: .normal)
        button.setImage(UIImage(named: "follow"), for: .normal)
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
        imageView.image = UIImage(named: "sinharaja")
        imageView.contentMode = .scaleAspectFill
        
        imageView.layer.masksToBounds = true
        return imageView
    }()
    func setupViews(){
        backgroundColor = UIColor.white
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(joinButton)
        addSubview(statusLabel)
        addSubview(statusImage)
        addConstrainsWithFormat(format: "H:|-8-[v0(44)]-8-[v1]-8-[v2(40)]-8-|", views: profileImageView, nameLabel,joinButton)
        addConstrainsWithFormat(format: "V:|-8-[v0(30)]", views: joinButton)
        addConstrainsWithFormat(format: "H:|-4-[v0]-4-|", views: statusLabel)
        addConstrainsWithFormat(format: "H:|[v0]", views: statusImage)
        addConstrainsWithFormat(format: "V:|-8-[v0]", views: nameLabel)
        addConstrainsWithFormat(format:  "V:|-8-[v0(44)]-4-[v1]-4-[v2(200)]|", views: profileImageView,statusLabel,statusImage)
     
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
class Mission {
    var name: String?
    var status: String?
    var profileImageName: String?
    var statusImageName: String?
    var location: String?
    var date:String?
}

