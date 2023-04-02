//
//  View+Error.swift
//  YapeMobileChallenge
//
//  Created by Lara Dubs on 01/04/2023.
//

import SwiftUI

extension View {
    func alert(_ errorBinding: Binding<Error?>) -> some View {
        alert(
            "There was an error",
            isPresented: .init(
                get: { errorBinding.wrappedValue != nil },
                set: { value in if !value { errorBinding.wrappedValue = nil}}
            ),
            presenting: errorBinding.wrappedValue
        ) { error in
            Button("OK", role: .cancel) {
                errorBinding.wrappedValue = nil
            }
        } message: { error in
            if let appError = error as? AppError {
                Text(appError.message)
            } else {
                Text(error.localizedDescription)
            }
        }
    }
}
