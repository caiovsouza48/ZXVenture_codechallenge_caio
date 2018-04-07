//
//  BeerGateway.swift
//  ZXVenturesChallenge_Caio
//
//  Created by Caio de Souza on 05/04/2018.
//  Copyright © 2018 Caio de Souza. All rights reserved.
//

import UIKit
import Foundation



typealias BeerPOCCompletionHandler = ([PocSearchMethodQuery.Data.PocSearch?]?, Error?) -> Void
typealias BeerCategorySearchCompletionHandler = ([PocCategorySearchQuery.Data.Poc.Product.ProductVariant?]?, Error?) -> Void
typealias BeerCategoryTitlesCompletionHandler = ([AllCategoriesSearchQuery.Data.AllCategory?]?, Error?) -> Void

/// Protocolo generico para definir uma interface de request
protocol BeerGateway: class {
    
    func findPOC(latitude: Double, longitude: Double, completionHandler: @escaping BeerPOCCompletionHandler)
    func categorySearch(pocID: String, search: String?, categoryID: Int?, completionHandler: @escaping BeerCategorySearchCompletionHandler)
    func allCategoriesTitle(completionHandler: @escaping BeerCategoryTitlesCompletionHandler)
    
}
