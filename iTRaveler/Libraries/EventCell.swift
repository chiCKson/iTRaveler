import UIKit

class EventCell: UICollectionViewCell {
    var event:Event?{
        didSet{
            if let eventName = event?.name{
                let attributeText = NSMutableAttributedString(string: eventName, attributes:[NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 14)])
                attributeText.append(NSAttributedString(string:"\n"+(event?.date!)!+" • "+(event?.location!)!+" • ",attributes:[NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 12),NSAttributedStringKey.foregroundColor:UIColor(r: 155, g: 161, b: 171)]))
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4
                attributeText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributeText.string.count))
                
                let attachment = NSTextAttachment()
                attachment.image = UIImage(named: "globe_icon")
                attachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
                attributeText.append(NSAttributedString(attachment: attachment))
                attributeText.append(NSAttributedString(string:"\n"+(event?.description!)!,attributes:[NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 13),NSAttributedStringKey.foregroundColor:UIColor(r: 155, g: 161, b: 171)]))
                nameLabel.attributedText=attributeText
            }
           
            if let eventImageName = event?.eventImageName {
               eventImageView.loadImageUsingCacheWithUrl(urlString: eventImageName)
               
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
        label.numberOfLines = 3
        return label
    }()
    let eventImageView:UIImageView = {
        let imageView = UIImageView()
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
    
   
    func setupViews(){
        backgroundColor = UIColor.white
        addSubview(nameLabel)
        addSubview(eventImageView)
        addSubview(joinButton)
        
  
        addConstrainsWithFormat(format: "H:|-8-[v0(60)]-8-[v1]-8-[v2(40)]-8-|", views: eventImageView, nameLabel,joinButton)
        addConstrainsWithFormat(format: "V:|-8-[v0(30)]", views: joinButton)
       
        addConstrainsWithFormat(format: "V:|-8-[v0]", views: nameLabel)
        addConstrainsWithFormat(format:  "V:|-8-[v0(60)]", views: eventImageView)
      
    }
}

