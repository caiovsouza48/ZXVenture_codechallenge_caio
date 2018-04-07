//
//  ProductDetailsPresenter.swift
//  ZXVenturesChallenge_Caio
//
//  Created by Caio de Souza on 07/04/2018.
//  Copyright © 2018 Caio de Souza. All rights reserved.
//
import Foundation
//MARK: - Presenter Protocols
protocol ProductDetailsView : class{
    func setup(infoLabel: String)
    func setup(title: String)
    func setup(description: String)
    func setup(imageURL: String)
}

protocol ProductDetailsPresenter : class{
    func attach(view: ProductDetailsView?)
    func detachView()
    func viewDidLoad()
    init(product: PocCategorySearchQuery.Data.Poc.Product.ProductVariant)
    
}

//MARK: - Protocol Implemetation
class ProductDetailsPresenterImplementation : ProductDetailsPresenter{
     private weak var view: ProductDetailsView?
     private let product : PocCategorySearchQuery.Data.Poc.Product.ProductVariant!

     required init(product: PocCategorySearchQuery.Data.Poc.Product.ProductVariant) {
        self.product = product
     }
    
     func attach(view: ProductDetailsView?){
        self.view = view
     }
    
     func detachView(){
        self.view = nil
     }
    
     func viewDidLoad() {
        
        self.view?.setup(infoLabel: formatProductToInfo())
        self.view?.setup(title: formattedTitle())
        self.view?.setup(description: product.description ?? "")
        self.view?.setup(imageURL: product.imageUrl ?? "")
     }
    
    //MARK: - Private Methods
    private func formatProductToInfo() -> String{
        var price = ""
        if let _price = product.price{
            price = "$\(_price)"
        }
        // Split by [WhiteSpace][Non-character][WhiteSpace]
        let splittedTitle = product.title.split(regex: "\\s\\W\\s")
        
        return "\(price) • \(splittedTitle[1]) • \(splittedTitle[0])"
    }
    
    private func formattedTitle() -> String{
        let regex = try! NSRegularExpression(pattern: "\\w+", options: NSRegularExpression.Options.allowCommentsAndWhitespace)
        if let match = regex.firstMatch(in: product.title, options: .anchored, range: NSMakeRange(0, product.title.count)){
            let nsrange = match.range
            return String(product.title[Range(nsrange, in: product.title)!])
        }
        return product.title
    }
    
   
}
