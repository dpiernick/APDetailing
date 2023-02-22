//
//  Codable+Extensions.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/11/23.
//

import Foundation

extension Encodable {
    var jsonDictionary: [String: Any]? {
        guard let encodedJson = try? JSONEncoder().encode(self) else { return nil }
        return try? JSONSerialization.jsonObject(with: encodedJson) as? [String: Any]
    }
}

extension Decodable {
    static func decode(dictionary: [String: Any]) -> Self? {
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .fragmentsAllowed) else { return nil }
        return try? JSONDecoder().decode(Self.self, from: data)
    }

    static func decode(data: Data) -> Self? {
        return try? JSONDecoder().decode(Self.self, from: data)
    }
}
