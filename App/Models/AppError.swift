//
//  AppError.swift
//  YapeMobileChallenge
//
//  Created by Lara Dubs on 31/03/2023.
//

import Foundation

public struct AppError: Error, LocalizedError, Equatable {
    let id: String
    let name: String
    let message: String
    let httpCode: Int?

    public init(id: String, name: String, message: String, httpCode: Int? = nil) {
        self.id = id
        self.name = name
        self.message = message
        self.httpCode = httpCode
    }

    public var errorDescription: String? {
        name
    }

    public var failureReason: String? {
        message
    }
}

extension AppError {
    static var generic: Self {
        .init(id: "api.error.generic", name: "Oops!", message: "Please try again!")
    }

    static var parsingError: Self {
        .init(id: "api.error.parsing", name: "Error en el parseo", message: "Please try again!")
    }
}
