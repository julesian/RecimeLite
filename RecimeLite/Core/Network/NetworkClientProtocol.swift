//
//  NetworkClientProtocol.swift
//  RecimeLite
//
//  Created by Jules Ian Gilos on 3/15/26.
//

import Foundation

protocol NetworkClientProtocol {
    func request<T: Decodable>(
        _ request: Requestable,
        as type: T.Type
    ) async throws -> T
    
    #if DEBUG
    func mockRequest<T: Decodable>(
        _ request: Requestable,
        as type: T.Type,
        behavior: MockResponseBehavior
    ) async throws -> T
    #endif
}

/* TODO:
enum NetworkClientConstants {
 static let timeoutDuration = 30.0
 static let retryMaxCount = 3
 static let retryDelayDuration = 3.0 // Better practice if non linear
 
    have this be the source of truth for any retry / back off durations for Networker and Mock,
    the mock provider's forever delivery duration is intentionally set to infinite
}
*/
