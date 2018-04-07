//
//  GoogleMapsRestGateway.swift
//  ZXVenturesChallenge_Caio
//
//  Created by Caio de Souza on 07/04/2018.
//  Copyright © 2018 Caio de Souza. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

class GoogleMapsRestGateway : LocationGeocodeGateway{
    
    func getLocation(address: String, completionHandler: @escaping (CLLocationCoordinate2D?) -> Void){
        let url = URL(string: String(format: "https://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", (address.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)))!
        
        let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else{
                completionHandler(nil)
                return
            }
            guard let _data = data else{
                completionHandler(nil)
                return
            }
            do{
                let json = try JSON(data: _data)
                let lat = json["results"][0]["geometry"]["location"]["lat"].doubleValue
                let lon = json["results"][0]["geometry"]["location"]["lng"].doubleValue
                completionHandler(CLLocationCoordinate2D(latitude: lat, longitude: lon))
            }
            catch {
                completionHandler(nil)
                return
            }
        }
        session.resume()
    }
    
    
}
