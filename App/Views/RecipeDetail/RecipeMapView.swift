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
        Button {
            viewModel.showingDetail = true
        } label: {
            MapAnnotatedView(annotation: viewModel.recipe, coordinate: \.origin.coordinate)
                .allowsHitTesting(false)
        }
        .navigationLink(isActive: $viewModel.showingDetail) {
            detailView
        }
    }

    var detailView: some View {
        VStack {
            MapAnnotatedView(annotation: viewModel.recipe, coordinate: \.origin.coordinate)
        }
        .edgesIgnoringSafeArea(.all)
        .navigationTitle("Location")
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.white, for: .navigationBar)
    }
    
    init(recipe: Recipe) {
        self.viewModel = .init(recipe: recipe)
    }
}

extension RecipeMapView {
    class ViewModel: ObservableObject {
        @Published var recipe: Recipe
        @Published var showingDetail: Bool = false

        init(recipe: Recipe) {
            self.recipe = recipe
        }
    }
}

struct MapAnnotatedView<Item: Identifiable>: View {
    let annotation: Item
    let coordinate: (Item) -> CLLocationCoordinate2D
    @State private var region: MKCoordinateRegion

    init(annotation: Item, coordinate: @escaping (Item) -> CLLocationCoordinate2D) {
        self.annotation = annotation
        self.coordinate = coordinate
        self._region = .init(wrappedValue: MKCoordinateRegion(center: coordinate(annotation), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)))
    }
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [annotation]) { _ in
            MapMarker(coordinate: coordinate(annotation))
        }
    }
}
