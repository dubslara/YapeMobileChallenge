//
//  YapeMobileChallengeTests.swift
//  YapeMobileChallengeTests
//
//  Created by Lara Dubs on 30/03/2023.
//

import XCTest
@testable import YapeMobileChallenge

extension Recipe {
    static func sample(id: String) -> Self {
        .init(
            id: id,
            name: "Test Recipe",
            image: "http://",
            summary: "",
            description: "",
            duration: 1,
            difficulty: "Easy",
            servings: 1,
            ingredients: ["Sample Ingredient"],
            instructions: ["Sample Instruction"],
            origin: .init(latitude: 0, longitude: 0)
        )
    }
}

final class YapeMobileChallengeTests: XCTestCase {
    override func setUpWithError() throws {
        Recipe.clearFavorites()
    }

    func testFavoritesAdded() throws {
        let viewModel = HomeView.ViewModel()
        viewModel.recipes = [
            .sample(id: "1"),
            .sample(id: "2")
        ]
        XCTAssertEqual(viewModel.favoriesRecipes.count, 0)
        viewModel.recipes[0].isFavorite = true
        XCTAssertEqual(viewModel.favoriesRecipes.count, 1)
    }

    func testRemainingRecipes() throws {
        let viewModel = HomeView.ViewModel()
        viewModel.recipes = [
            .sample(id: "1"),
            .sample(id: "2")
        ]
        XCTAssertEqual(viewModel.listRecipes.count, 2)
        viewModel.recipes[0].isFavorite = true
        XCTAssertEqual(viewModel.listRecipes.count, 1)
    }
}
