//
//  NetworkClient.swift
//  RecimeLite
//
//  Created by Jules Ian Gilos on 3/15/26.
//

import Foundation
import Alamofire

// NOTE: If there are dynamic handling for base URL, we need to initialize it here,
// but since we're making it simple,  we can leave this for now, but it will still
// be easy to add due to the layers being separated :D

final class NetworkClient: NetworkClientProtocol {
    private let session: Session

    init(session: Session = .default) {
        self.session = session
    }
    
    func request<T: Decodable & Sendable>(
        _ request: Requestable,
        as type: T.Type
    ) async throws -> T {
        let urlString = EndpointConstants.baseURL + request.config.path
        let method = request.config.method.mapped
        let parameters = request.config.method == .get ? request.config.queryParameters : request.config.bodyParameters
        let encoding: ParameterEncoding = request.config.method == .get ? URLEncoding.default : JSONEncoding.default
        let headers = HTTPHeaders(request.config.headers ?? [:])
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(
                urlString,
                method: method,
                parameters: parameters,
                encoding: encoding,
                headers: headers
            )
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    continuation.resume(returning: value)
                    
                case .failure(let error):
                    continuation.resume(throwing: NetworkError.underlying(error))
                }
            }
        }
    }
    
    #if DEBUG
    func mockRequest<T: Decodable & Sendable>(
        _ request: Requestable,
        as type: T.Type,
        behavior: MockResponseBehavior
    ) async throws -> T {
        guard let json = request.mockJsonFileName else {
            let errorMessage = "No mock file configured for request: \(request.config.path)"
            assertionFailure(errorMessage)
            throw NetworkError.fileNotFound(errorMessage)
        }

        MockNetworkLogger.logRequest(
            path: request.config.path,
            method: request.config.method,
            queryParameters: request.config.queryParameters,
            bodyParameters: request.config.bodyParameters,
            mockFileName: json,
            responseType: type
        )

        return try await MockResponseProvider.load(
            json,
            as: type,
            behavior: behavior
        )
    }
    #endif
}

#if DEBUG
private enum MockNetworkLogger {
    static func logRequest<T>(
        path: String,
        method: HTTPMethod,
        queryParameters: [String: Any]?,
        bodyParameters: [String: Any]?,
        mockFileName: String,
        responseType: T.Type
    ) {
        print(
            """
            [Mock Request]
            path: \(path)
            method: \(method)
            query: \(formatted(parameters: queryParameters))
            body: \(formatted(parameters: bodyParameters))
            mockFile: \(mockFileName).json
            responseType: \(responseType)
            """
        )
    }

    private static func formatted(parameters: [String: Any]?) -> String {
        guard let parameters, !parameters.isEmpty else { return "nil" }
        return String(describing: parameters)
    }
}
#endif

fileprivate extension HTTPMethod {
    /// Alamofire's equivalent HTTPMethod from the agnostic HTTPMethod
    var mapped: Alamofire.HTTPMethod {
        switch self {
        case .get: return .get
        case .post: return .post
        case .put: return .put
        case .delete: return .delete
        }
    }
}
