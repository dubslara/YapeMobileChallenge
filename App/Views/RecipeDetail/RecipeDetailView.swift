//
//  RecipeDetailView.swift
//  YapeMobileChallenge
//
//  Created by Lara Dubs on 30/03/2023.
//

import SwiftUI

struct RecipeDetailView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var isPresentingLocation = false

    var body: some View {
        ZStack {
            backgroundView
            sheetView
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarBackground(Color.clear, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
    }

    var backgroundView: some View {
        VStack(spacing: 0) {
            Color.clear
                .frame(height: 500)
                .frame(maxWidth: .infinity)
                .background {
                    AsyncImage(url: viewModel.image) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        EmptyView()
                    }
                }
                .clipped()
            Spacer()
        }
        .background(.ultraThickMaterial)
        .edgesIgnoringSafeArea(.all)
    }

    var sheetView: some View {
        ScrollView {
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 500 - 200)
                contentView
                    .overlay(alignment: .topTrailing) {
                        favoriteButton
                            .padding(.trailing, 30)
                            .padding(.top, -20)
                    }
            }
        }
    }

    var contentView: some View {
        VStack(spacing: .margin * 2) {
            headerView
            descriptionView
            locationView
            ingredientsView
            preparationView
        }
        .padding(.horizontal, .margin)
        .padding(.top, .margin)
        .background(.ultraThickMaterial)
        .edgesIgnoringSafeArea(.bottom)
        .cornerRadius(.margin * 2, corners: [.topLeft, .topRight])
    }

    var headerView: some View {
        VStack(spacing: .margin) {
            VStack(spacing: .marginSmall * 0.5) {
                Text(viewModel.title)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .textCase(.uppercase)
                Text(viewModel.recipe.summary)
                    .font(.body)
                    .multilineTextAlignment(.center)
            }
            recipeMetrics
        }
    }
    
    var recipeMetrics: some View {
        HStack {
            Text(viewModel.duration)
                .textCase(.uppercase)
                .fontWeight(.medium)
                .padding(.trailing, 10)

            Divider()
                .frame(height: 20)

            HStack {
                Image(systemName: "person")
                    .fontWeight(.medium)
                Text(viewModel.servings)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 10)

            Divider()
                .frame(height: 20)

            Text(viewModel.difficulty)
                .textCase(.uppercase)
                .fontWeight(.medium)
                .padding(.leading, 10)
        }
    }

    var descriptionView: some View {
        sectionView(title: "Summary") {
            VStack(alignment: .leading, spacing: .marginSmall) {
                Text(viewModel.recipe.description)
                    .font(.body)
            }
        }
    }

    var locationView: some View {
        sectionView(title: "Origin") {
            RecipeMapView(recipe: viewModel.recipe)
                .frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: .marginSmall))
        }

    }
    
    var ingredientsView: some View {
        sectionView(title: "Ingredients") {
            VStack(alignment: .leading, spacing: .marginSmall) {
                ForEach(viewModel.ingredients, id: \.self) { ingredient in
                    Text("• \(ingredient)")
                        .font(.callout)
                }
            }
            .padding(.horizontal, .margin)
        }
    }
    
    var preparationView: some View {
        sectionView(title: "Preparation") {
            VStack(alignment: .leading, spacing: .margin) {
                ForEach(Array(viewModel.instructions.enumerated()), id: \.1) { index, instruction in
                    HStack(alignment: .top) {
                        Text("\(index+1))")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .offset(x: 0, y: 2)
                        Text(instruction)
                            .font(.body)
                    }
                }
            }
            .padding(.horizontal, .marginSmall)
        }
    }

    func sectionView<Content: View>(title: String, content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: .marginSmall) {
            Text(title)
                .font(.title)
                .fontWeight(.medium)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    

    var favoriteButton: some View {
        Button {
            viewModel.recipe.isFavorite.toggle()
        } label: {
            ZStack {
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                Image(systemName: viewModel.recipe.isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(.red)
                    .font(.system(size: 20))
                    .alignmentGuide(HorizontalAlignment.center) { d in d[HorizontalAlignment.center] }
                    .alignmentGuide(VerticalAlignment.center) { d in d[VerticalAlignment.center] }
            }
        }
    }
    
    init(recipe: Recipe) {
        self.viewModel = .init(recipe: recipe)
    }
}

extension RecipeDetailView {
    class ViewModel: ObservableObject {
        @Published var recipe: Recipe
        
        var title: String {
            recipe.name
        }
        
        var description: String {
            recipe.description
        }
        
        var image: URL? {
            URL(string: recipe.image)
        }
        
        var duration: String {
            "\(recipe.duration) min"
        }
        
        var difficulty: String {
            recipe.difficulty
        }
        
        var servings: String {
            String(recipe.servings)
        }
        
        var ingredients: [String] {
            recipe.ingredients
        }
        
        var instructions: [String] {
            recipe.instructions
        }
        
        init(recipe: Recipe) {
            self.recipe = recipe
        }
    }
}
