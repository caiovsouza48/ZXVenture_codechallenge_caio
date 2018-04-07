//
//  LocationGateway.swift
//  ZXVenturesChallenge_Caio
//
//  Created by Caio de Souza on 04/04/2018.
//  Copyright © 2018 Caio de Souza. All rights reserved.
//
import Foundation
import Apollo


class BeerApolloGateway : BeerGateway{
    
    //MARK: - Variables
    private var client : ApolloClient!
    
    //MARK: - Init
    init() {
        client = ApolloClient(url: ZXConstants.graphQLUrl!)
    }

    //MARK: - Methods
    func findPOC(latitude: Double, longitude: Double, completionHandler: @escaping (BeerPOCCompletionHandler)){
        
        //Formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SSSSZ"
        
        //Constants
        let algorithm = "NEAREST"
        let now = Date()
        client.fetch(query: PocSearchMethodQuery(now: formatter.string(from: now),
                                                 algorithm: algorithm,
                                                 lat: String(latitude),
                                                 long: String(longitude)),
                     cachePolicy:  CachePolicy.fetchIgnoringCacheData,
                     queue: DispatchQueue.main)
        { (result, error) in
            if let error = error{
                print("FindPOC -> \(error.localizedDescription)")
                completionHandler(nil,error)
                return
                
            }
            guard let result = result else {
                print("FindPOC -> No query result")
                completionHandler(nil,nil)
                return
                
            }
            
            if let errors = result.errors {
                print("FindPOC -> Errors in query result: \(errors)")
                completionHandler(nil,nil)
            }
            guard let data = result.data else {
                print("FindPOC -> No query result data")
                completionHandler(nil,nil)
                return
                
            }
            completionHandler(data.pocSearch,nil)
                        
        }
    }
    //MARK: - Category Search
    func categorySearch(pocID: String, search: String?, categoryID: Int?, completionHandler: @escaping BeerCategorySearchCompletionHandler) {
        client.fetch(query: PocCategorySearchQuery(id: pocID,
                                                   search: search ?? "",
                                                   categoryId: categoryID ?? 0) ,
                     cachePolicy: CachePolicy.fetchIgnoringCacheData,
                     queue: DispatchQueue.main) { (result, error) in
                        if let error = error{
                            print("categorySearch -> \(error.localizedDescription)")
                            completionHandler(nil,error)
                            return
                            
                        }
                        guard let result = result else {
                            print("categorySearch -> No query result")
                            completionHandler(nil,nil)
                            return
                            
                        }
                        
                        if let errors = result.errors {
                            print("categorySearch -> Errors in query result: \(errors)")
                            completionHandler(nil,nil)
                        }
                        guard let data = result.data else {
                            print("categorySearch -> No query result data")
                            completionHandler(nil,nil)
                            return
                            
                        }
                        let arrayOfProductVariantArray = data.poc?.products?.compactMap({ (product) -> [PocCategorySearchQuery.Data.Poc.Product.ProductVariant?]? in
                                return product?.productVariants
                        })
                        let productVariantFlattenArray = arrayOfProductVariantArray?.flatMap{ $0 }
                        completionHandler(productVariantFlattenArray,nil)
        }
    }
    // MARK: - Category Titles
    func allCategoriesTitle(completionHandler: @escaping BeerCategoryTitlesCompletionHandler){
        client.fetch(query: AllCategoriesSearchQuery(),
                     cachePolicy: CachePolicy.fetchIgnoringCacheData,
                     queue: DispatchQueue.main) { (result, error) in
                        
                        if let error = error{
                            print("allCategoriesTitle -> \(error.localizedDescription)")
                            completionHandler(nil,error)
                            return
                            
                        }
                        guard let result = result else {
                            print("allCategoriesTitle -> No query result")
                            completionHandler(nil,nil)
                            return
                            
                        }
                        
                        if let errors = result.errors {
                            print("allCategoriesTitle -> Errors in query result: \(errors)")
                            completionHandler(nil,nil)
                        }
                        guard let data = result.data else {
                            print("allCategoriesTitle -> No query result data")
                            completionHandler(nil,nil)
                            return
                        }
                        completionHandler(data.allCategory,nil)
                        
        }
    }
}
