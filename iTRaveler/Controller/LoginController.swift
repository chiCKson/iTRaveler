//
//  LoginController.swift
//  iTRaveler
//
//  Created by Erandra Jayasundara on 11/22/18.
//  Copyright © 2018 Erandra Jayasundara. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    let inputContainerView:UIView={
        let view=UIView()
        view.backgroundColor=UIColor.white
        view.translatesAutoresizingMaskIntoConstraints=false
        view.layer.cornerRadius=5
        view.layer.masksToBounds=true
        return view
    }()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor=UIColor(r:34,g:139,b:34)
        
        view.addSubview(inputContainerView)
       setupInputContainerView()
    }
    func setupInputContainerView(){
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        inputContainerView.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive=true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor,constant:-24).isActive=true
        inputContainerView.heightAnchor.constraint(equalToConstant: 150).isActive=true
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return.lightContent
    }
}
extension UIColor{
    convenience init(r:CGFloat,g:CGFloat,b:CGFloat){
        self.init(red:r/255,green:g/255,blue:b/255,alpha:1)
    }
}
