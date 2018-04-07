//
//  ZXConstants.swift
//  ZXVenturesChallenge_Caio
//
//  Created by Caio de Souza on 04/04/2018.
//  Copyright © 2018 Caio de Souza. All rights reserved.
//
import Foundation


struct ZXConstants{
    public static let GraphQLURLKey = "ApolloURL"
    static var graphQLUrl : URL?{
        if let projectDefaultsApolloUrl = ZXFileManager.loadProjectDefaults()[ZXConstants.GraphQLURLKey]{
            return URL(string:projectDefaultsApolloUrl as! String)
        }
        return nil
    }
}
