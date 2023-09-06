//
//  PeerMetadata.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 13/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import Foundation

public struct HMSStorage<Key: Hashable, Value> : Sequence {
    private var storage: [Key: Value] = [:]
    
    private let setHandler: ([Key: Value])->Void
    
    internal init(setHandler: @escaping ([Key: Value])->Void) {
        self.setHandler = setHandler
    }
    
    public subscript(key: Key) -> Value? {
        get {
            return storage[key]
        }
        set {
            if let newValue = newValue {
                storage[key] = newValue
            } else {
                storage.removeValue(forKey: key)
            }
            setHandler(storage)
        }
    }
    
    public func makeIterator() -> Dictionary<Key, Value>.Iterator {
        return storage.makeIterator()
    }
    
    // For internal updates from network
    internal mutating func setValue(_ value: Value?, for key: Key) {
        if let value = value {
            storage[key] = value
        } else {
            storage.removeValue(forKey: key)
        }
    }
}

public extension HMSStorage {
    
    mutating func set(from dictionary: [Key: Value]) {
        storage = dictionary
        setHandler(storage)
    }
    
    var values: [Key: Value] {
        storage
    }
    
    mutating func add(keys: [Key: Value]) {
        for (key, value) in keys {
            storage[key] = value
        }
        setHandler(storage)
    }
    
    mutating func remove(keys: [Key]) {
        for key in keys {
            storage.removeValue(forKey: key)
        }
        setHandler(storage)
    }
    
    mutating func edit(keysToAdd: [Key: Value], keysToRemove: [Key]) {
        for key in keysToRemove {
            storage.removeValue(forKey: key)
        }
        for (key, value) in keysToAdd {
            storage[key] = value
        }
        setHandler(storage)
    }
}
