//
//  HomeView.swift
//  YapeMobileChallenge
//
//  Created by Lara Dubs on 30/03/2023.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: ViewModel = .init()

    var body: some View {
        NavigationView {
            ZStack {
                listView
                searchResultsView
            }
            .searchable(text: $viewModel.searchText)
            .onChange(of: viewModel.searchText) { _ in
                viewModel.searchRecipes()
            }
            .task {
                await viewModel.getRecipes()
            }
            .alert($viewModel.error)
        }
    }

    var listView: some View {
        VStack {
            Text("What are you cooking today?")
            List {
                ForEach(viewModel.recipes) { recipe in
                    RecipeRowView(recipe: recipe, style: .home)
                }
            }
        }
    }

    @ViewBuilder
    var searchResultsView: some View {
        if let results = viewModel.searchResults {
            VStack {
                List {
                    ForEach(results) { recipe in
                        RecipeRowView(recipe: recipe, style: .search)
                    }
                }
                Spacer()
            }
        }
    }
}

extension HomeView {
    class ViewModel: ObservableObject {
        @Published var searchText = ""
        @Published var recipes: [Recipe] = []
        @Published var showError: Bool = false
        @Published var error: Error?
        @Published var searchResults: [Recipe]?

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
