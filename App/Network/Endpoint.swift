//
//  Endpoint.swift
//  YapeMobileChallenge
//
//  Created by Lara Dubs on 31/03/2023.
//

import Foundation

struct Endpoint {
    public let urlString: String
    public let keyEncodingStrategy: JSONDecoder.KeyDecodingStrategy
    
    public init(_ urlString: String, keyEncodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase) {
        self.urlString = urlString
        self.keyEncodingStrategy = keyEncodingStrategy
    }
    
    static var recipes: Self {
        .init("recipes")
    }
}
