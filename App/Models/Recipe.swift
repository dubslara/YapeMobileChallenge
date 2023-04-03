//
//  Recipe.swift
//  YapeMobileChallenge
//
//  Created by Lara Dubs on 30/03/2023.
//

import Foundation
import MapKit

struct Recipe: Decodable, Identifiable {
    var id: String
    var name: String
    var image: String
    var summary: String
    var description: String
    var duration: Int
    var difficulty: String
    var servings: Int
    var ingredients: [String]
    var instructions: [String]
    var origin: Location

    struct Location: Decodable {
        var latitude: Double
        var longitude: Double

        var coordinate: CLLocationCoordinate2D {
            .init(latitude: latitude, longitude: longitude)
        }
    }
}

extension Recipe {
    var isFavorite: Bool {
        get {
            guard let favoriteRecipes = UserDefaultsService.array(key: .favorites, type: String.self) else {
                return false
            }
            return favoriteRecipes.contains(id)
        }

        set {
            var favoriteRecipes = UserDefaultsService.array(key: .favorites, type: String.self) ?? []
            if newValue {
                if !favoriteRecipes.contains(id) {
                    favoriteRecipes.append(id)
                }
            } else {
                favoriteRecipes.removeAll { $0 == id }
            }
            UserDefaultsService.set(favoriteRecipes, key: .favorites)
        }
    }

    static func clearFavorites() {
        UserDefaultsService.remove(key: .favorites)
    }
}
