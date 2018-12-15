//
//  main.swift
//  Day14
//
//  Created by Vyacheslav Khorkov on 14/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

struct Buffer<T> {
    private let pointer: UnsafeMutablePointer<T>
    private let buffer: UnsafeMutableBufferPointer<T>
    private(set) var count = 0

    init(_ array: [T], _ size: Int) {
        pointer = UnsafeMutablePointer<T>.allocate(capacity: size)
        for (i, e) in array.enumerated() { pointer[i] = e }
        count = array.count
        buffer = UnsafeMutableBufferPointer(start: pointer, count: size)
    }

    subscript(_ index: Int) -> T {
        return buffer[index]
    }
    
    subscript(bounds: Range<Int>) -> Slice<UnsafeMutableBufferPointer<T>> {
        return buffer[bounds]
    }
    
    mutating func push(_ value: T) {
        buffer[count] = value
        count += 1
    }
}

func run(_ input: Int) -> String {
    var recipes = Buffer([3, 7], 20_220_955)
    var (first, second) = (0, 1)
    while recipes.count < input + 10 {
        let sum = recipes[first] + recipes[second]
        if sum > 9 { recipes.push(sum / 10) }
        recipes.push(sum % 10)
        first = (first + recipes[first] + 1) % recipes.count
        second = (second + recipes[second] + 1) % recipes.count
    }
    return recipes[input..<input + 10].reduce("") { $0 + String($1) }
}

func run2(_ input: [Int]) -> Int {
    let pattern = Buffer(input, input.count)
    var recipes = Buffer([3, 7], 21_000_000)
    var (first, second, cursor) = (0, 1, 0)
    let find: (Int) -> Bool = {
        recipes.push($0)
        cursor = pattern[cursor] == $0 ? cursor + 1 : 0
        if cursor == 0 && pattern[cursor] == $0 { cursor += 1 }
        return cursor == pattern.count
    }
    while true {
        let sum = recipes[first] + recipes[second]
        if sum > 9 && find(sum / 10) { break }
        if find(sum % 10) { break }
        first = (first + recipes[first] + 1) % recipes.count
        second = (second + recipes[second] + 1) % recipes.count
    }
    return recipes.count - pattern.count
}

measure(run(290431) == "1776718175") // 6 ms
measure(run2([2, 9, 0, 4, 3, 1]) == 20220949) // 473 ms
