//
//  Extension.swift
//  BookNote
//
//  Created by 강준영 on 2023/06/28.
//

import Foundation

extension Encodable {
    func asDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else { return [:] }
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            return json ?? [:]
        } catch {
            return [:]
        }
    }
}

extension Data {
    func responseDecodable<T: Decodable>() throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: self)
        } catch {
            throw error
        }
    }
}
