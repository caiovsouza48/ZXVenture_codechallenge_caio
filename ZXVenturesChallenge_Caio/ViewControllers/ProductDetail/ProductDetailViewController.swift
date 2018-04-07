//
//  ProductDetailViewController.swift
//  ZXVenturesChallenge_Caio
//
//  Created by Caio de Souza on 06/04/2018.
//  Copyright © 2018 Caio de Souza. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    //Outlets 
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productInfoLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    
    //Presenter
    var presenter : ProductDetailsPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Presenter
        presenter.attach(view: self)
        presenter.viewDidLoad()
        
        //Navigation
        let customBarButton = UIBarButtonItem()
        customBarButton.title = ""
        navigationController?.navigationBar.topItem?.backBarButtonItem = customBarButton
        
    }
    
    deinit {
        presenter.detachView()
    }
}

extension ProductDetailViewController : ProductDetailsView{
    func setup(infoLabel: String) {
        productInfoLabel.text = infoLabel
    }
    
    func setup(title: String) {
        productNameLabel.text = title
    }
    
    func setup(description: String) {
        productDescriptionLabel.text = description
    }
    
    func setup(imageURL: String) {
        productImageView.imageFromServerURL(urlString: imageURL, completionHandler: nil)
    }
    
    
}
