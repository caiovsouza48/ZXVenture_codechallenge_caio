//
//  String+SplitRegex.swift
//  ZXVenturesChallenge_Caio
//
//  Created by Caio de Souza on 07/04/2018.
//  Copyright © 2018 Caio de Souza. All rights reserved.
//

import Foundation

extension String {
    
    func split(regex pattern: String) -> [String] {
        
        guard let re = try? NSRegularExpression(pattern: pattern, options: [])
            else { return [] }
        
        let nsString = self as NSString // needed for range compatibility
        let stop = "<SomeStringThatYouDoNotExpectToOccurInSelf>"
        let modifiedString = re.stringByReplacingMatches(
            in: self,
            options: [],
            range: NSRange(location: 0, length: nsString.length),
            withTemplate: stop)
        return modifiedString.components(separatedBy: stop)
    }
}
