//
//  RecipeRowView.swift
//  YapeMobileChallenge
//
//  Created by Lara Dubs on 01/04/2023.
//

import SwiftUI

struct RecipeRowView: View {
    enum Style {
        case home
        case search

        var height: CGFloat {
            switch self {
                case .home:
                    return 80
                case .search:
                    return 40
                    
            }
        }
    }

    @StateObject private var viewModel: ViewModel
    let style: Style

    var body: some View {
        HStack {
            Color.clear
                .frame(maxHeight: .infinity)
                .aspectRatio(1, contentMode: .fit)
                .background(
                    AsyncImage(url: viewModel.image) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: .margin))

            VStack {
                Text(viewModel.title)
                    .font(.title)
                Text(viewModel.subtitle)
                    .font(.subheadline)
            }
        }
        .padding(.margin)
        .frame(height: style.height)
        .onTapGesture {
            viewModel.showDetail = true
        }
        .navigationLink(isActive: $viewModel.showDetail) {
            RecipeDetailView(recipe: viewModel.recipe)
        }
        .listRowInsets(EdgeInsets())
    }

    init(recipe: Recipe, style: RecipeRowView.Style) {
        self._viewModel = .init(wrappedValue: .init(recipe: recipe))
        self.style = style
    }
}

extension RecipeRowView {
    class ViewModel: ObservableObject {
        @Published var recipe: Recipe
        @Published var showDetail: Bool = false

        var title: String {
            recipe.name
        }
        
        var subtitle: String {
            recipe.summary
        }

        var image: URL? {
            URL(string: recipe.image)
        }

        init(recipe: Recipe) {
            self.recipe = recipe
        }
    }
}
