//
//  HomeView+ViewModel.swift
//  YapeMobileChallenge
//
//  Created by Lara Dubs on 02/04/2023.
//

import Foundation

extension HomeView {
    class ViewModel: ObservableObject {
        @Published var searchText = ""
        @Published var recipes: [Recipe] = []
        @Published var showError: Bool = false
        @Published var error: Error?
        @Published var searchResults: [Recipe]?

        var favoriesRecipes: [Recipe] {
            recipes.filter { $0.isFavorite }
        }

        var listRecipes: [Recipe] {
            recipes.filter { !$0.isFavorite }
        }

        func getRecipes() async {
            do {
                let recipes = try await Network.shared.getRecipes()
                await MainActor.run {
                    self.recipes = recipes
                }
            } catch {
                await MainActor.run {
                    self.error = error
                }
            }
        }
        
        func searchRecipes() {
            guard !searchText.isEmpty else {
                searchResults = nil
                return
            }

            let filteredRecipes = recipes.filter { recipe in
                let nameMatch = recipe.name.localizedCaseInsensitiveContains(searchText)
                let ingredientMatch = recipe.ingredients.contains { ingredient in
                    ingredient.localizedCaseInsensitiveContains(searchText)
                }
                return nameMatch || ingredientMatch
            }
            
            searchResults = filteredRecipes
        }
        
        func clearSearch() {
            searchText = ""
            recipes = []
        }
    }
}
