//
//  main.swift
//  Day11
//
//  Created by Vyacheslav Khorkov on 11/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

func buildMatrix(_ input: Int) -> ([[Int]], Range<Int>) {
    var m = Array(repeating: Array(repeating: 0, count: 301), count: 301)
    for y in m.indices.dropLast() {
        for x in m.indices.dropLast() {
            let id = x + 11
            let powerLevel = (id * (y + 1) + input) * id
            m[y][x] = (powerLevel % 1000) / 100 - 5
        }
    }
    return (m, m.indices.dropLast())
}


func search9x9(_ input: Int) -> (Int, Int) {
    var (m, indices) = buildMatrix(input)
    var square = (area: 0, x: 0, y: 0)
    for y in indices.dropLast(2) {
        for x in indices.dropLast(2) {
            let area = m[y ..< y + 3].lazy
                .flatMap { $0[x ..< x + 3] }
                .reduce(0, +)
            if area > square.area {
                square = (area, x, y)
            }
        }
    }
    return (square.x + 1, square.y + 1)
}

measure(search9x9(7511)) // 0.040s


func searchAny(_ input: Int) -> (Int, Int, Int) {
    var (m, indices) = buildMatrix(input)
    for y in indices.reversed() {
        for x in indices.reversed() {
            m[y][x] += m[y][x + 1] + m[y + 1][x] - m[y + 1][x + 1]
        }
    }
    
    var square = (area: 0, x: 0, y: 0, size: 0)
    for y in indices {
        for x in indices {
            let steps = min(indices.endIndex - y, indices.endIndex - x)
            for s in 1...steps {
                let area = m[y][x] + m[y + s][x + s] - m[y + s][x] - m[y][x + s]
                if area > square.area { square = (area, x, y, s) }
            }
        }
    }
    return (square.x + 1, square.y + 1, square.size)
}

measure(searchAny(7511)) // 0.034s
