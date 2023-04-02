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
    var diners: Int
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
