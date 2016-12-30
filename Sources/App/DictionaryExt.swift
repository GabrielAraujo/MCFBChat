//
//  DictionayExt.swift
//  MCFBChat
//
//  Created by Gabriel Araujo on 29/12/16.
//
//

import Foundation

extension Dictionary {
    
    /// An immutable version of update. Returns a new dictionary containing self's values and the key/value passed in.
    func updatedValue(_ value: Value, forKey key: Key) -> Dictionary<Key, Value> {
        var result = self
        result[key] = value
        return result
    }
    
    var nullsRemoved: [Key: Value] {
        let tup = filter { !($0.1 is NSNull) }
        return tup.reduce([Key: Value]()) { $0.0.updatedValue($0.1.value, forKey: $0.1.key) }
    }
}
