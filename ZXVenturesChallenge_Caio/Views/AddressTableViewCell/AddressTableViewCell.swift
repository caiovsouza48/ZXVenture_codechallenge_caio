//
//  AdressTableViewCell.swift
//  ZXVenturesChallenge_Caio
//
//  Created by Caio de Souza on 03/04/2018.
//  Copyright © 2018 Caio de Souza. All rights reserved.
//

import UIKit

class AddressTableViewCell: UITableViewCell, ReusableView, NibLoadableView {
    @IBOutlet weak var adressTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(title: String){
        self.adressTitleLabel.text = title
    }
}
