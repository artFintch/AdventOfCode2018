//
//  BinarySearch.swift
//  Day15
//
//  Created by Vyacheslav Khorkov on 15/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

func binarySearch<T>(_ range: Range<Int>,
                     _ check: (Int) -> (T?)) -> (position: Int, result: T?) {
    var found: T?
    var lowerBound = range.lowerBound
    var upperBound = range.upperBound
    while lowerBound < upperBound {
        let midIndex = lowerBound + (upperBound - lowerBound) / 2
        if let result = check(midIndex) {
            upperBound = midIndex
            found = result
        } else {
            lowerBound = midIndex + 1
        }        
    }
    return (lowerBound, found)
}
