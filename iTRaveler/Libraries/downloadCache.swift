//
//  downloadCache.swift
//  iTRaveler
//
//  Created by Erandra Jayasundara on 12/26/18.
//  Copyright © 2018 Erandra Jayasundara. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView{
    func loadImageUsingCacheWithUrl(urlString:String){
        SVProgressHUD.setForegroundColor(UIColor(r:77,g:175,b:81))
        SVProgressHUD.show()
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject){
            self.image = cachedImage as! UIImage
            SVProgressHUD.dismiss()
            return
        }
        let sRef = Storage.storage().reference().child(urlString)
        sRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
                return
            } else {
                if let downloadedImage = UIImage(data: data!){
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
                
                SVProgressHUD.dismiss()
            }
        }
    }
}

