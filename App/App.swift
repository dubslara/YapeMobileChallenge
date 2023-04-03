//
//  App.swift
//  YapeMobileChallenge
//
//  Created by Lara Dubs on 30/03/2023.
//

import SwiftUI

@main
struct YapeMobileChallengeApp: SwiftUI.App {
    init() {
        UIViewController.swizzle()
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
