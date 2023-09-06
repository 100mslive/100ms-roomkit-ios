//
//  ArrayExtension.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 19/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import Foundation

extension Array {
    public func chunks(ofCount count: Int) -> Array<Array> {
        
        let chunkSize = count
        let count = self.count
        
        if count == 0 {
            return [[]]
        }
        
        precondition(count > 0, "Cannot chunk with count <= 0!")
        
        return stride(from: 0, to: count, by: chunkSize).map {
            Array(self[$0 ..< Swift.min($0 + chunkSize, count)])
        }
    }
}

extension Array where Element: Hashable {
    var combinedWithoutDuplicates: [Element] {
        return reduce(into: []) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
}

extension Array where Element: Equatable {
    internal mutating func move(_ element: Element, to newIndex: Index) {
        if let oldIndex: Int = firstIndex(of: element) {
            self.move(from: oldIndex, to: newIndex)
        }
    }

    internal mutating func move(from oldIndex: Index, to newIndex: Index) {
        // won't rebuild array and will be super efficient.
        if oldIndex == newIndex { return }
        // Index out of bound handle here
        if newIndex >= self.count { return }
        // Don't work for free and use swap when indices are next to each other - this
        if abs(newIndex - oldIndex) == 1 { return self.swapAt(oldIndex, newIndex) }
        // Remove at old index and insert at new location
        self.insert(self.remove(at: oldIndex), at: newIndex)
    }
}
