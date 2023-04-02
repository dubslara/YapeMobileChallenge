//
//  RecipeDetailView.swift
//  YapeMobileChallenge
//
//  Created by Lara Dubs on 30/03/2023.
//

import SwiftUI

struct RecipeDetailView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var isFavorite = false
    @State private var isPresentingLocation = false

    var body: some View {
        ZStack {
            backgroundView
            sheetView
        }
    }

    var backgroundView: some View {
        VStack {
            Color.clear
                .frame(height: 500)
                .frame(maxWidth: .infinity)
                .background(
                    AsyncImage(url: viewModel.image) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        EmptyView()
                    }
                )
                .clipped()
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
    }

    var sheetView: some View {
        ScrollView {
            VStack {
                Spacer()
                    .frame(height: 500 - 200)
                contentView
                    .overlay(
                        favoriteButton
                            .padding(.trailing, 30)
                            .padding(.top, -20),
                        alignment: .topTrailing
                    )
            }
        }
    }

    var contentView: some View {
        VStack {
            Text(viewModel.title)
                .font(.largeTitle)
            Text(viewModel.description)
                .font(.subheadline)
                .multilineTextAlignment(.center)
            recipeMetrics
            ingredientsView
            preparationView
        }
        .padding(.margin)
        .background(.thinMaterial)
        .cornerRadius(.margin * 2, corners: [.topLeft, .topRight])
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
                Text(viewModel.diners)
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
    
    var ingredientsView: some View {
        VStack(alignment: .leading) {
            Text("Ingredients")
                .font(.title)
                .fontWeight(.medium)
            ForEach(viewModel.ingredients, id: \.self) { ingredient in
                    Text("• \(ingredient)")
                    .font(.callout)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var preparationView: some View {
        VStack(alignment: .leading) {
            Text("Instructions")
                .font(.title)
                .fontWeight(.medium)
            ForEach(Array(viewModel.instructions.enumerated()), id: \.1) { index, instruction in
                Text("\(index+1). \(instruction)")
                    .font(.callout)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var favoriteButton: some View {
        Button {
            isFavorite.toggle()
        } label: {
            ZStack {
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                Image(systemName: isFavorite ? "heart.fill" : "heart")
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
        
        var diners: String {
            String(recipe.diners)
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
