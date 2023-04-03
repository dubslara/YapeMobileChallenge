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
        NavigationStack {
            ZStack {
                contentView
                searchResultsView
            }
            .alert($viewModel.error)
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
            .onChange(of: viewModel.searchText) { _ in
                viewModel.searchRecipes()
            }
            .task {
                await viewModel.getRecipes()
            }
        }
    }
    
    @ViewBuilder
    var contentView: some View {
        List {
            favoritesListView
            listView
        }
        .animation(.default, value: viewModel.listRecipes.count)
    }

    @ViewBuilder
    var favoritesListView: some View {
        if !viewModel.favoriesRecipes.isEmpty {
            Section {
                ForEach(viewModel.favoriesRecipes) { recipe in
                    RecipeRowView(recipe: recipe, style: .home)
                        .transition(.slide)
                }
            } header: {
                Text("Favorites")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .textCase(.uppercase)
            }
        }
    }

    var listView: some View {
        Section {
            ForEach(viewModel.listRecipes) { recipe in
                RecipeRowView(recipe: recipe, style: .home)
                    .transition(.slide)
            }
        } header: {
            Text("What are you cooking today?")
                .font(.headline)
                .fontWeight(.semibold)
                .textCase(.uppercase)
        }
    }

    @ViewBuilder
    var searchResultsView: some View {
        if let results = viewModel.searchResults {
            List {
                ForEach(results) { recipe in
                    RecipeRowView(recipe: recipe, style: .search)
                }
            }
        }
    }
}
