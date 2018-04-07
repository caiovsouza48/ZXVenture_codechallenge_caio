//
//  ZXFileManager.swift
//  ZXVenturesChallenge_Caio
//
//  Created by Caio de Souza on 04/04/2018.
//  Copyright © 2018 Caio de Souza. All rights reserved.
//

import UIKit

struct ZXFileManager{
    private static var projectDefaultCache : Dictionary<String, Any>?
    
    static func loadPlist(resourceName: String, bundle : Bundle = Bundle.main) -> Dictionary<String, Any>?{
        if let filePath = bundle.url(forResource: resourceName, withExtension: "plist"),
           let data = try? Data(contentsOf: filePath) {
            if let result = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] {
                return result
            }
        }
        return nil
    }
    
    static func loadProjectDefaults() -> Dictionary<String, Any>{
        if projectDefaultCache == nil{
            projectDefaultCache = loadPlist(resourceName: "projectDefaults")
            return projectDefaultCache!
        }
        return projectDefaultCache!
    }
    
    static func loadPProjectDefaultsConstant(_ constant : String) -> String{
        return (loadProjectDefaults()[constant] as? String) ?? ""
    }

}
