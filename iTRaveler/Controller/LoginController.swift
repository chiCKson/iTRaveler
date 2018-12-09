//
//  LoginController.swift
//  iTRaveler
//
//  Created by Erandra Jayasundara on 11/22/18.
//  Copyright © 2018 Erandra Jayasundara. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import JSSAlertView

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
        button.addTarget(self, action: #selector(handleLoginRegisterSegment), for: .touchUpInside)
        return button
    }()
    @objc func handleLoginRegisterSegment(){
        if loginRegisterSegmentCOntrol.selectedSegmentIndex == 0{
            handleLogin()
        }else{
            handleRegister()
        }
    }
    let customIcon = UIImage(named: "testlg")
    let customColor = UIColor(r:77,g:175,b:81)
    func handleLogin(){
        
        
        guard let email=emailTextField.text,let password=passwordTextField.text else{
            print("form is not valid")
            return
        }
        if isValidEmail(testStr: email){
            if password.count>6{
                SVProgressHUD.setForegroundColor(UIColor(r:77,g:175,b:81))
                SVProgressHUD.show()
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    
                    if error != nil{
                        SVProgressHUD.dismiss()
                        
                        return
                    }
                    
                    self.dismiss(animated: true, completion: SVProgressHUD.dismiss)
                }
            }else{
                // base color for the alert
                JSSAlertView().show(
                    self,
                    title: "Error in Password",
                    text: "Please re enter the password.",
                    buttonText: "OK",
                    color: customColor,
                    iconImage: customIcon).setTextTheme(.light)
            }
        }else{
            JSSAlertView().show(
                self,
                title: "Error in Email",
                text: "Please re enter the email.",
                buttonText: "OK",
                color: customColor,
                iconImage: customIcon).setTextTheme(.light)
        }
    }
    func handleRegister(){
        guard let email=emailTextField.text,let password=passwordTextField.text,let name=nameTextField.text else{
            print("form is not valid")
            return
        }
        if name.isEmpty{
            JSSAlertView().show(
                self,
                title: "Error",
                text: "Name Should not be empty.",
                buttonText: "OK",
                color: customColor,
                iconImage: customIcon).setTextTheme(.light)
        }else{
            if isValidEmail(testStr: email){
                if password.count>6{
                    SVProgressHUD.setForegroundColor(UIColor(r:77,g:175,b:81))
                    SVProgressHUD.show()
                    Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, error) in
                        if error != nil{
                            SVProgressHUD.dismiss()
                            print(error!)
                            return
                        }
                            var ref: DatabaseReference!
                            ref = Database.database().reference()
                        
                            let values = ["name":name,"email":email]
                        ref.child("users").child((authResult?.user.uid)!).setValue(values) {
                                (error:Error?, ref:DatabaseReference) in
                                if let error = error {
                                    print("Data could not be saved: \(error).")
                                } else {
                                    print("Data saved successfully!")
                                    SVProgressHUD.dismiss()
                                }
                            }
                        
                        
                        guard (authResult?.user) != nil else { return }
                         self.dismiss(animated: true, completion: SVProgressHUD.dismiss)
                        
                    }
                }else{
                    JSSAlertView().show(
                        self,
                        title: "Error",
                        text: "Please re enter the password.",
                        buttonText: "OK",
                        color: customColor,
                        iconImage: customIcon).setTextTheme(.light)
                }
            }else{
                JSSAlertView().show(
                    self,
                    title: "Error",
                    text: "Please re enter the email.",
                    buttonText: "OK",
                    color: customColor,
                    iconImage: customIcon).setTextTheme(.light)
            }
        }
    }
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
    let loginRegisterSegmentCOntrol:UISegmentedControl={
        let sc=UISegmentedControl(items:["Login","Register"])
        sc.translatesAutoresizingMaskIntoConstraints=false
        sc.tintColor=UIColor(r:77,g:175,b:81)
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegister), for: .valueChanged)
        return sc
    }()
    @objc func handleLoginRegister(){
        let title=loginRegisterSegmentCOntrol.titleForSegment(at: loginRegisterSegmentCOntrol.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        inputContainerViewHeightAnchor?.constant=loginRegisterSegmentCOntrol.selectedSegmentIndex == 0 ? 100 : 150
        
        nameTextFieldHeightAnchor?.isActive=false
        nameTextFieldHeightAnchor=nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentCOntrol.selectedSegmentIndex == 0 ? 0: 1/3)
        nameTextFieldHeightAnchor?.isActive=true
        
        passwordTextFieldHeightAnchor?.isActive=false
        passwordTextFieldHeightAnchor=passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentCOntrol.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive=true
        
        emailTextFieldHeightAnchor?.isActive=false
        emailTextFieldHeightAnchor=emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentCOntrol.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive=true
        
        
    }
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor=UIColor.white
        view.addSubview(inputContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(logoImageView)
        view.addSubview(loginRegisterSegmentCOntrol)
        setupInputContainerView()
        setupLginRegisterButton()
        setupLogoImageView()
        setupLofinRegisterSegmentCOntrol()
        
    }
    func setupLofinRegisterSegmentCOntrol(){
        loginRegisterSegmentCOntrol.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        loginRegisterSegmentCOntrol.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive=true
        loginRegisterSegmentCOntrol.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive=true
        loginRegisterSegmentCOntrol.heightAnchor.constraint(equalToConstant: 36).isActive=true
    }
    func setupLogoImageView(){
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        logoImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentCOntrol.topAnchor, constant: -12).isActive=true
        logoImageView.widthAnchor.constraint(equalToConstant: 150).isActive=true
        logoImageView.heightAnchor.constraint(equalToConstant: 150).isActive=true
    }
    var inputContainerViewHeightAnchor:NSLayoutConstraint?
    var nameTextFieldHeightAnchor:NSLayoutConstraint?
    var emailTextFieldHeightAnchor:NSLayoutConstraint?
    var passwordTextFieldHeightAnchor:NSLayoutConstraint?
    func setupInputContainerView(){
        //input box
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        inputContainerView.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive=true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor,constant:-24).isActive=true
        inputContainerViewHeightAnchor=inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputContainerViewHeightAnchor?.isActive=true
        
        inputContainerView.addSubview(nameTextField)
        inputContainerView.addSubview(nameSeperatorView)
        inputContainerView.addSubview(emailTextField)
        inputContainerView.addSubview(emailSeperatorView)
        inputContainerView.addSubview(passwordTextField)
        passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive=true
        passwordTextField.topAnchor.constraint(equalTo: emailSeperatorView.bottomAnchor).isActive=true
        passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive=true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive=true
        
        emailSeperatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor
            ).isActive=true
        emailSeperatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive=true
        emailSeperatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive=true
        emailSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive=true
        
        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive=true
        emailTextField.topAnchor.constraint(equalTo: nameSeperatorView.bottomAnchor).isActive=true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive=true
       emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive=true
        nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor,constant:12).isActive=true
        nameTextField.topAnchor.constraint(equalTo:inputContainerView.topAnchor).isActive=true
        nameTextField.widthAnchor.constraint(equalTo:inputContainerView.widthAnchor).isActive=true
        nameTextFieldHeightAnchor=nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive=true
        
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
