//
//  ViewController.swift
//  iTRaveler
//
//  Created by Erandra Jayasundara on 11/19/18.
//  Copyright © 2018 Erandra Jayasundara. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem=UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
    @objc func handleLogout(){
        let loginController=LoginController()
        present(loginController,animated:true,completion:nil)
    }

   
    


}

