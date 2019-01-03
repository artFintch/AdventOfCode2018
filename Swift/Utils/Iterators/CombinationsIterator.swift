//
//  CombinationsIterator.swift
//  Day2
//
//  Created by Vyacheslav Khorkov on 01/01/2019.
//  Copyright © 2019 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

struct CombinationsIterator<T: Collection> where T.Indices == Range<Int> {
    private let collection: T
    private var indices = (lhs: 0, rhs: 0)
    
    init(_ collection: T) {
        self.collection = collection
    }
}

extension CombinationsIterator: IteratorProtocol, Sequence {
    mutating func next() -> (T.Element, T.Element)? {
        guard collection.indices ~= indices.lhs,
            collection.indices ~= indices.rhs else { return nil }
        
        for lhsIndex in indices.lhs..<collection.count {
            indices.lhs = lhsIndex
            for rhsIndex in Swift.max(lhsIndex + 1, indices.rhs)..<collection.count {
                indices.rhs = rhsIndex + 1
                if indices.rhs == collection.count {
                    indices.lhs += 1
                    indices.rhs = 0
                }
                return (collection[lhsIndex], collection[rhsIndex])
            }
        }
        return nil
    }
}

extension Array {
    func makeCombinationsIterator() -> CombinationsIterator<Array> {
        return CombinationsIterator(self)
    }
}
