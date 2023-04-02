//
//  Network+Recipes.swift
//  YapeMobileChallenge
//
//  Created by Lara Dubs on 31/03/2023.
//

import Alamofire

extension Network {
    func getRecipes() async throws -> [Recipe] {
        try await request(endpoint: .recipes, isAuthenticated: false)
    }
}
