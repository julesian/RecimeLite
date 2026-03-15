//
//  RequestConfiguration.swift
//  RecimeLite
//
//  Created by Jules Ian Gilos on 3/15/26.
//

protocol RequestConfigurationProtocol {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryParameters: [String: Any]? { get }
    var bodyParameters: [String: Any]? { get }
    var headers: [String: String]? { get }
}

struct RequestConfiguration: RequestConfigurationProtocol {
    let path: String
    let method: HTTPMethod
    let queryParameters: [String: Any]?
    let bodyParameters: [String: Any]?
    let headers: [String: String]?
    
    init(
        path: String,
        method: HTTPMethod,
        queryParameters: [String: Any]? = nil,
        bodyParameters: [String: Any]? = nil,
        headers: [String: String]? = nil
    ) {
        self.path = path
        self.method = method
        self.queryParameters = queryParameters.nilIfEmpty
        self.bodyParameters = bodyParameters.nilIfEmpty
        self.headers = headers.nilIfEmpty
    }
}

fileprivate extension Optional where Wrapped: Collection {
    var nilIfEmpty: Wrapped? {
        guard let value = self, !value.isEmpty else { return nil }
        return value
    }
}
