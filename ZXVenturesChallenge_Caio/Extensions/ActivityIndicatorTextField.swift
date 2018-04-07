//
//  ActivityIndicatorTextField.swift
//  ZXVenturesChallenge_Caio
//
//  Created by Caio de Souza on 04/04/2018.
//  Copyright © 2018 Caio de Souza. All rights reserved.
//

import UIKit
import Foundation

///TextField Evitando que a RightView sobreponha o clear button
class ActivityIndicatorTextField: UITextField {
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let superclassBounds = super.rightViewRect(forBounds: bounds)
        let textSize = NSString(string: text ?? "").size(withAttributes: nil)
        return CGRect(x: textSize.width + 10,
                      y: superclassBounds.origin.y + 3,
                      width: textSize.width,
                      height: textSize.height)
    }
}
