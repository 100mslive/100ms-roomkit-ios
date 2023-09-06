//
//  HMSSharedStorage.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 13/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK

public struct HMSSharedStorage<Key: Hashable, Value> {
    private var storage: [Key: Value] = [:]

    private let setHandler: (Key, Value)->Void
    internal init(setHandler: @escaping (Key, Value)->Void) {
        self.setHandler = setHandler
    }
    
    // Internal updates
    internal mutating func set(value: Value?, for key: Key) {
        storage[key] = value
    }

    // Public interface
    public subscript(key: Key) -> Value? {
        get {
            return storage[key]
        }
        set {
            if let newValue = newValue {
                storage[key] = newValue
                setHandler(key, newValue)
            }
        }
    }
}

public class HMSSharedSessionStore {
    
    let serialQueue = DispatchQueue(label: "HMSSharedSessionStore Serial Queue")
    
    internal weak var roomModel: HMSRoomModel?
    
    private var keysToObserve = Set<String>()
    private var keyObservations = [String: NSObjectProtocol]()
    
    private weak var sessionStore: HMSSessionStore?
    internal func assign(sessionStore: HMSSessionStore) {
        
        serialQueue.sync {
            self.sessionStore = sessionStore
            
            // Init storage
            roomModel?.sharedStore = HMSSharedStorage(setHandler: { key, value in
                // Update everyone of local set value
                DispatchQueue.main.async {
                    sessionStore.set(value, forKey: key)
                }
            })
            
            // begin observing keys
            Array(keysToObserve).forEach { key in
                observeChanges(for: key, sessionStore: sessionStore)
            }
            keysToObserve.removeAll()
        }
    }
    
    internal func cleanup() {
        keysToObserve.removeAll()
        keyObservations.removeAll()
        roomModel = nil
        sessionStore = nil
    }
    
    // Public interface
    public func beginObserving(keys: [String]) {
        serialQueue.async {
            if let sessionStore = self.sessionStore {
                keys.forEach { key in
                    self.observeChanges(for: key, sessionStore: sessionStore)
                }
            }
            else {
                keys.forEach{self.keysToObserve.insert($0)}
            }
        }
    }
    
    public func stopObserving(keys: [String]) {
        serialQueue.async {
            if let sessionStore = self.sessionStore {
                keys.forEach { key in
                    if let observer = self.keyObservations[key] {
                        DispatchQueue.main.async {
                            sessionStore.removeObserver(observer)
                        }
                    }
                }
            }
            else {
                keys.forEach{self.keysToObserve.remove($0)}
            }
        }
    }
    
    private func observeChanges(for key: String, sessionStore: HMSSessionStore) {
        
        DispatchQueue.main.async {
            sessionStore.observeChanges(forKeys: [key], changeObserver: { key, value in
                // Update local storage with network values
                self.roomModel?.sharedStore?.set(value: value, for: key)
            }) { object, error in
                if let object = object {
                    // Store observer so we can stop observing
                    self.keyObservations[key] = object
                }
                else {
                    print(error?.localizedDescription)
                }
            }
        }
    }
}
