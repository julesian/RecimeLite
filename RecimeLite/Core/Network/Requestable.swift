//
//  Requestable.swift
//  RecimeLite
//
//  Created by Jules Ian Gilos on 3/15/26.
//

protocol Requestable {
    var config: RequestConfigurationProtocol { get }
    
    #if DEBUG
    var mockJsonFileName: String? { get }
    #endif
}
