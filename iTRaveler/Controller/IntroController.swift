//
//  IntroController.swift
//  iTRaveler
//
//  Created by Erandra Jayasundara on 11/30/18.
//  Copyright © 2018 Erandra Jayasundara. All rights reserved.
//

import UIKit

class IntroController: UIViewController {
    let titleLabel = UILabel()
    let bodyLabel = UILabel()
    fileprivate func setupLabels() {
        view.backgroundColor = UIColor(r:77,g:175,b:81)

        //titleLabel.backgroundColor = .red
        //bodyLabel.backgroundColor = .green
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .white
        titleLabel.text = "Welcome to iTRaveler"
        titleLabel.font = UIFont(name: "Futura", size: 34)
        bodyLabel.textColor = .white
        
        bodyLabel.text = "Hello there! Thanks you so much for downloading our app and giving a try. And always remember you are helping to save the world!"
        bodyLabel.numberOfLines = 0
    }
    
    fileprivate func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel,bodyLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        view.addSubview(stackView)
        
        //enables auto layout
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
        setupStackView()
        
        //animation
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapAnimations)))
        

    }
    @objc func handleTapAnimations(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.titleLabel.transform = CGAffineTransform(translationX: -30, y: 0)
        }, completion: { (_) in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.titleLabel.alpha = 0
                self.titleLabel.transform = self.titleLabel.transform.translatedBy(x: 0, y: -200)
            })
        })
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.bodyLabel.transform = CGAffineTransform(translationX: -30, y: 0)
        }, completion: { (_) in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.bodyLabel.alpha = 0
                self.bodyLabel.transform = self.bodyLabel.transform.translatedBy(x: 0, y: -200)
            },completion:{ (_) in
                
                let loginController=LoginController()
                self.present(loginController,animated:true,completion:nil)
            })
        })
    }
}
