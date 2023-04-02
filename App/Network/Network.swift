//
//  Network.swift
//  YapeMobileChallenge
//
//  Created by Lara Dubs on 30/03/2023.
//

import Foundation
import Alamofire

struct Network {
    static let shared = Self()
    public let baseUrl = "https://demo1426534.mockable.io/"
    private let manager: Alamofire.Session
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        configuration.timeoutIntervalForRequest = 60
        configuration.httpCookieStorage = HTTPCookieStorage.shared
        manager = Alamofire.Session(configuration: configuration)
    }

    func request<Value: Decodable, Parameters: Encodable>(method: HTTPMethod = .get, endpoint: Endpoint, parameters: Parameters? = nil, parametersDestination: ParametersDestination = .methodDependant, isAuthenticated: Bool = true) async throws -> Value {
        var params: [String: Any]?

        let encoder = JSONEncoder()

        if let parameters = parameters, let data = try? encoder.encode(parameters) {
            params = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        }
        return try await request(method: method, endpoint: endpoint, parameters: params, parametersDestination: parametersDestination, isAuthenticated: isAuthenticated)
    }

    func request<Value: Decodable>(method: HTTPMethod = .get, endpoint: Endpoint, parameters: Parameters? = nil, parametersDestination: ParametersDestination = .methodDependant, isAuthenticated: Bool = true) async throws -> Value {

        URLSessionConfiguration.default.urlCache = nil

        var url = baseUrl + endpoint.urlString
        if endpoint.urlString.contains("http"){
            url = endpoint.urlString
        }

        let headers: HTTPHeaders = .init([])
        
        let encoding: ParameterEncoding
        switch parametersDestination {
            case .urlQueryString:
                encoding = URLEncoding(destination: .queryString, arrayEncoding: .brackets, boolEncoding: .numeric)
            case .jsonBody:
                encoding = JSONEncoding(options: .fragmentsAllowed)
            case .methodDependant:
                switch method {
                    case .get:
                        encoding = URLEncoding(destination: .queryString)
                    default:
                        encoding = JSONEncoding(options: .fragmentsAllowed)
                }
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = endpoint.keyEncodingStrategy

        let response = await manager
            .request(
                url,
                method: method,
                parameters: parameters,
                encoding: encoding,
                headers: headers,
                interceptor: nil
            )
            .validate(statusCode: 200...299)
            .serializingResponse(using: .decodable(of: Value.self, decoder: decoder))
            .response
        
        switch response.result {
            case let .success(value):
                return value
            case let .failure(error):
                #if DEBUG
                print("There was a networking error: \(error)")
                #endif

                throw AppError(
                    id: "http_error",
                    name: "Oops, there was an error!",
                    message: error.localizedDescription,
                    httpCode: response.response?.statusCode
                )
        }
    }
}

extension Network {
    enum ParametersDestination {
        case urlQueryString
        case jsonBody
        case methodDependant
    }

    private struct ServerError: Codable {
        let message: String
    }
}
