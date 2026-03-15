//
//  NetworkError.swift
//  RecimeLite
//
//  Created by Jules Ian Gilos on 3/15/26.
//

// Note: Not everything is used here, but just showing the idea here.

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case decodingFailed(Error)
    case fileNotFound(String)
    case fileReadFailed(String)
    case mockDisabled
    case underlying(Error)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:                   "Invalid URL."
        case .invalidResponse:              "Invalid response."
        case .statusCode(let code):         "Request failed with status code \(code)."
        case .decodingFailed(let error):    "Decoding failed: \(error.localizedDescription)"
        case .fileNotFound(let fileName):   "Mock file not found: \(fileName)"
        case .fileReadFailed(let fileName): "Failed to read mock file: \(fileName)"
        case .mockDisabled:                 "Mock responses are disabled."
        case .underlying(let error):        "Underlying error: \(error.localizedDescription)"
        case .unknown(let error):           "Unknown error: \(error.localizedDescription)"
        }
    }
}
