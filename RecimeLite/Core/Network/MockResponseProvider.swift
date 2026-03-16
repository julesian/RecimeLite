//
//  MockResponseProvider.swift
//  RecimeLite
//
//  Created by Jules Ian Gilos on 3/15/26.
//

#if DEBUG
import Foundation

enum MockResponseProvider {
    enum Constants {
        static let nanoSecondsInOneSecond: UInt64 = 1_000_000_000
        static let fileExtension = "json"
    }

    static func load<T: Decodable & Sendable>(
        _ fileName: String,
        as type: T.Type,
        behavior: MockResponseBehavior = .willDeliver(speed: .instant)
    ) async throws -> T {
        let duration = behavior.speed.duration

        if duration.isInfinite {
            try await Task.sleep(nanoseconds: .max)
            throw CancellationError()
        }

        let delayInNanoseconds = UInt64(duration * Double(Constants.nanoSecondsInOneSecond))

        if delayInNanoseconds > 0 {
            try await Task.sleep(nanoseconds: delayInNanoseconds)
        }

        switch behavior {
        case .willError(let error, _):
            throw error

        case .willDeliver:
            break
        }

        guard let url = Bundle.main.url(
            forResource: fileName,
            withExtension: Constants.fileExtension
        )
        else {
            throw NetworkError.fileNotFound(fileName)
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            throw NetworkError.decodingFailed(error)
        } catch {
            throw NetworkError.fileReadFailed(fileName)
        }
    }
}

enum MockResponseBehavior {
    case willDeliver(speed: DeliverySpeed)
    case willError(error: NetworkError, speed: DeliverySpeed)
    
    enum DeliverySpeed {
        case instant
        case fast
        case slow
        case forever
        case customDuration(seconds: Double)
        
        var duration: Double {
            switch self {
            case .instant: 0.0
            case .fast: 0.05
            case .slow: 4.0
            case .forever: .infinity
            case .customDuration(let seconds): seconds
            }
        }
    }
    
    var speed: DeliverySpeed {
        switch self {
        case let .willDeliver(speed), let .willError(_, speed):
            return speed
        }
    }
}
#endif
