import Foundation

extension Dictionary<String, Any> {
    mutating func add(_ key: String, _ value: String?) {
        guard let value, !value.isEmpty else { return }
        self[key] = value
    }

    mutating func add(_ key: String, _ value: Bool?) {
        guard let value else { return }
        self[key] = value
    }

    mutating func add(_ key: String, _ value: Int?) {
        guard let value else { return }
        self[key] = value
    }

    mutating func add<T>(_ key: String, _ value: [T]?) {
        guard let value, !value.isEmpty else { return }
        self[key] = value
    }
}
