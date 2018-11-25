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
        view.backgroundColor=UIColor(r:77,g:175,b:81)
        view.translatesAutoresizingMaskIntoConstraints=false
        view.layer.cornerRadius=5
        view.layer.masksToBounds=true
        return view
    }()
    let loginRegisterButton:UIButton={
        let button=UIButton(type: .system)
        button.backgroundColor=UIColor(r:77,g:175,b:81)
        button.setTitle("Register", for: .normal)
        button.layer.cornerRadius=5
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.masksToBounds=true
        button.titleLabel?.font=UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints=false
        return button
    }()
    let nameTextField:UITextField={
        let tf=UITextField()
        tf.placeholder="Name"
        tf.textColor=UIColor.white
        tf.translatesAutoresizingMaskIntoConstraints=false
        return tf
    }()
    let nameSeperatorView:UIView={
        let view=UIView()
        view.backgroundColor=UIColor.white
        view.translatesAutoresizingMaskIntoConstraints=false
        return view
    }()
    let emailTextField:UITextField={
        let tf=UITextField()
        tf.placeholder="Email"
        tf.textColor=UIColor.white
        tf.translatesAutoresizingMaskIntoConstraints=false
        return tf
    }()
    let emailSeperatorView:UIView={
        let view=UIView()
        view.backgroundColor=UIColor.white
        view.translatesAutoresizingMaskIntoConstraints=false
        return view
    }()
    let passwordTextField:UITextField={
        let tf=UITextField()
        tf.placeholder="Password"
        tf.textColor=UIColor.white
        tf.isSecureTextEntry=true
        tf.translatesAutoresizingMaskIntoConstraints=false
        return tf
    }()
    let logoImageView:UIImageView={
        let logoView=UIImageView()
        logoView.image=UIImage(named:"logo")
        logoView.translatesAutoresizingMaskIntoConstraints=false
        logoView.contentMode = .scaleAspectFill
        return logoView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor=UIColor.white
        view.addSubview(inputContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(logoImageView)
        setupInputContainerView()
        setupLginRegisterButton()
        setupLogoImageView()
        
    }
    func setupLogoImageView(){
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        logoImageView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive=true
        logoImageView.widthAnchor.constraint(equalToConstant: 150).isActive=true
        logoImageView.heightAnchor.constraint(equalToConstant: 150).isActive=true
    }
   
    func setupInputContainerView(){
        //input box
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        inputContainerView.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive=true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor,constant:-24).isActive=true
        inputContainerView.heightAnchor.constraint(equalToConstant: 200).isActive=true
        
        inputContainerView.addSubview(nameTextField)
        inputContainerView.addSubview(nameSeperatorView)
        inputContainerView.addSubview(emailTextField)
        inputContainerView.addSubview(emailSeperatorView)
        inputContainerView.addSubview(passwordTextField)
        passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive=true
        passwordTextField.topAnchor.constraint(equalTo: emailSeperatorView.bottomAnchor).isActive=true
        passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive=true
        passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive=true
        emailSeperatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor
            ).isActive=true
        emailSeperatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive=true
        emailSeperatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive=true
        emailSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive=true
        
        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive=true
        emailTextField.topAnchor.constraint(equalTo: nameSeperatorView.bottomAnchor).isActive=true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive=true
        emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive=true
        nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor,constant:12).isActive=true
        nameTextField.topAnchor.constraint(equalTo:inputContainerView.topAnchor).isActive=true
        nameTextField.widthAnchor.constraint(equalTo:inputContainerView.widthAnchor).isActive=true
        nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive=true
        
        nameSeperatorView.leftAnchor.constraint(equalTo:inputContainerView.leftAnchor).isActive=true
        nameSeperatorView.topAnchor.constraint(equalTo:nameTextField.bottomAnchor).isActive=true
        nameSeperatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive=true
        nameSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive=true
    }
    func setupLginRegisterButton() {
        loginRegisterButton.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive=true
        loginRegisterButton.topAnchor.constraint(equalTo:inputContainerView.bottomAnchor,constant:12).isActive=true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive=true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive=true
        
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
