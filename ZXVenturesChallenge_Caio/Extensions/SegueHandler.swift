//
//  ActivityIndicatorTextField.swift
//  ZXVenturesChallenge_Caio
//
//  Created by Caio de Souza on 04/04/2018.
//  Copyright © 2018 Caio de Souza. All rights reserved.
//

/* The SegueHandlerType pattern, as seen on [1, 2], adapted for the changed Swift 3 syntax.
 [1] https://developer.apple.com/library/content/samplecode/Lister/Listings/Lister_SegueHandlerType_swift.html
 [2] https://www.natashatherobot.com/protocol-oriented-segue-identifiers-swift/
 */
import UIKit
import Foundation

protocol SegueHandlerType {
    
    // `typealias` has been changed to `associatedtype` for Protocols in Swift 3.
    associatedtype SegueIdentifier: RawRepresentable
}

extension SegueHandlerType where Self: UIViewController, SegueIdentifier.RawValue == String {
    
    // This used to be `performSegueWithIdentifier(...)`.
    func performSegue(withIdentifier identifier: SegueIdentifier, sender: Any?) {
        performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }
    
    func segueIdentifier(for segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier, let segueIdentifier = SegueIdentifier(rawValue: identifier) else {
            fatalError("Couldn't handle segue identifier \(String(describing: segue.identifier)) for view controller of type \(type(of: self)).")
        }
        
        return segueIdentifier
    }
}

