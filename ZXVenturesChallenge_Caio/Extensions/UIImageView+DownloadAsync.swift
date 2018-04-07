//
//  UIImageView+DownloadAsync.swift
//  ZXVenturesChallenge_Caio
//
//  Created by Caio de Souza on 05/04/2018.
//  Copyright © 2018 Caio de Souza. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    public func imageFromServerURL(urlString: String, completionHandler: (() -> Void)?) {
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
                if let _completionHandler = completionHandler{
                    _completionHandler()
                }
            })
            
        }).resume()
    }}
