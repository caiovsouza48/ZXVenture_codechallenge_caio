//
//  ProductCollectionViewCell.swift
//  ZXVenturesChallenge_Caio
//
//  Created by Caio de Souza on 05/04/2018.
//  Copyright © 2018 Caio de Souza. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell, ReusableView, NibLoadableView {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var imageActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 1.0
        layer.borderColor = UIColor(white: 0.0, alpha: 0.2).cgColor
        layer.cornerRadius = 4.0
        clipsToBounds = true
        
    }
    func configure(model: PocCategorySearchQuery.Data.Poc.Product.ProductVariant?){
        if let _model = model{
            configure(imageURL: model?.imageUrl ?? "",
                price: model?.price ?? Double.nan,
                title: _model.title ,
                description: _model.description ?? "")
        }
    }
    
    func configure(imageURL: String, price: Double, title: String, description: String){
        productImage.imageFromServerURL(urlString: imageURL) {
            self.imageActivityIndicatorView.stopAnimating()
        }
        priceLabel.text = price != Double.nan ? String.localizedStringWithFormat("$%.2f", price) : ""
        descriptionLabel.text = title
        quantityLabel.text = description
    }

}
