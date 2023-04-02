//
//  View+Navigation.swift
//  YapeMobileChallenge
//
//  Created by Lara Dubs on 31/03/2023.
//

import SwiftUI

import SwiftUI

extension View {
    public func navigationLink<Destination: View>(
        isActive: Binding<Bool>,
        @ViewBuilder destination: @escaping () -> Destination
    ) -> some View {
        NavigationLinkView(
            content: self,
            isActive: isActive,
            destination: destination
        )
    }

    public func navigationLink<Item, Destination: View>(
        item: Binding<Item?>,
        @ViewBuilder destination: @escaping (Item) -> Destination
    ) -> some View {
        navigationLink(
            isActive: Binding(
                get: { item.wrappedValue != nil },
                set: { if !$0 { item.wrappedValue = nil } }
            ),
            destination: {
                if let item = item.wrappedValue {
                    destination(item)
                }
            }
        )
    }
}

extension View {
    func configureNavigation() -> some View {
        self
            .navigationBarTitleDisplayMode(.inline)
    }
}

public struct LazyView<Content: View>: View {
    private let build: () -> Content
    public init(@ViewBuilder build: @escaping () -> Content) {
        self.build = build
    }
    public var body: Content {
        build()
    }
}

// MARK: - ViewModifier

private struct NavigationLinkView<Content: View, Destination: View>: View {
    let content: Content
    let isActive: Binding<Bool>
    let destination: () -> Destination

    var body: some View {
        content
            .background(
                NavigationLink(
                    destination:
                        LazyView {
                            destination()
                                .navigationBarTitleDisplayMode(.inline)
                        }
                    ,
                    isActive: isActive,
                    label: EmptyView.init
                )
                .hidden()
            )
    }
}

