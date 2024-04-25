//
//  APIState.swift
//  FLO
//
//  Created by 김성준 on 4/22/24.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case httpCode(HTTPCode)
    case unexpectedResponse
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .invalidURL: return "Invalid URL"
            case let .httpCode(code): return "Unexpected HTTP code: \(code)"
            case .unexpectedResponse: return "Unexpected response from the server"
        }
    }
}

final class EndPoint {
    func urlRequest(baseURL: String) throws -> URLRequest {
        guard let url = URL(string: baseURL) else { throw APIError.invalidURL }
        return URLRequest(url: url)
    }
}

typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    static let success = 200 ..< 300
}
