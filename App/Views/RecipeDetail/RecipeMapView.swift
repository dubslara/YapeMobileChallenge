//
//  RecipeMapView.swift
//  YapeMobileChallenge
//
//  Created by Lara Dubs on 02/04/2023.
//

import SwiftUI
import MapKit

struct RecipeMapView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        Map(coordinateRegion: $viewModel.region, annotationItems: [viewModel.recipe]) {
            MapMarker(coordinate: $0.origin.coordinate)
        }
        .frame(width: 400, height: 300)
    }
    
    init(recipe: Recipe) {
        self.viewModel = .init(recipe: recipe)
    }
}

extension RecipeMapView {
    class ViewModel: ObservableObject {
        @Published var recipe: Recipe
        @Published var region: MKCoordinateRegion

        init(recipe: Recipe) {
            self.recipe = recipe
            self.region = MKCoordinateRegion(center: recipe.origin.coordinate, span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
            
        }
    }
}
