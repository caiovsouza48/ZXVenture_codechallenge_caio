//
//  GoogleMapsGateway.swift
//  ZXVenturesChallenge_Caio
//
//  Created by Caio de Souza on 07/04/2018.
//  Copyright © 2018 Caio de Souza. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationGeocodeGateway {
    func  getLocation(address: String, completionHandler: @escaping (CLLocationCoordinate2D?) -> Void)
}
