//
//  CustomTabBarController.swift
//  iTRaveler
//
//  Created by Erandra Jayasundara on 12/2/18.
//  Copyright © 2018 Erandra Jayasundara. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
        let feedController = ViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let navigationController = UINavigationController(rootViewController: feedController)
        UITabBar.appearance().tintColor = UIColor(r:77,g:175,b:81)
        navigationController.title = "Misison Feed"
        navigationController.tabBarItem.image = UIImage(named: "mission")
        
        let mapController = MapController()
        let secondNavigationController = UINavigationController(rootViewController: mapController)
        secondNavigationController.title = "Map"
        secondNavigationController.tabBarItem.image = UIImage(named: "map")
        
         let messageController = UIViewController()
       
        let thirdNavigationController = UINavigationController(rootViewController: messageController)
        thirdNavigationController.title = "Message"
        thirdNavigationController.tabBarItem.image = UIImage(named: "msg")
        
        let notificationController = UIViewController()
        let forthNavigationController = UINavigationController(rootViewController: notificationController)
        forthNavigationController.title = "Notification"
        forthNavigationController.tabBarItem.image = UIImage(named: "bell")
        
        let  settingsController = SettingsController()
        let fifthNavigationController = UINavigationController(rootViewController: settingsController)
        fifthNavigationController.title = "More"
        fifthNavigationController.tabBarItem.image = UIImage(named: "more_icon")
        
        viewControllers = [navigationController,secondNavigationController,thirdNavigationController,forthNavigationController,fifthNavigationController]
        tabBar.isTranslucent = false
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
        topBorder.backgroundColor = UIColor(r: 229, g: 231, b: 235).cgColor
        tabBar.layer.addSublayer(topBorder)
        tabBar.clipsToBounds = true
    }
}
