//
//  main.swift
//  Day3
//
//  Created by Vyacheslav Khorkov on 03/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Frog

// Utils
struct Rect { let n: Int, x: Int, y: Int, w: Int, h: Int }
extension Rect {
    var indices: [(x: Int, y: Int)] {
        return (x..<(x + w))
            .map { i in (y..<(y + h)).map { (i, $0) } }
            .flatMap { $0 }
    }
}

// Input
var lines = Frog("input.txt")!.readLines()
let rects = lines.lazy
    .map { $0.components(separatedBy: ["#", "@", ":", " ", ",", "x"]) }
    .map { $0.compactMap(Int.init) }
    .map { Rect(n: $0[0], x: $0[1], y: $0[2], w: $0[3], h: $0[4]) }

var matrix = Array(repeating: Array(repeating: 0, count: 1000), count: 1000)
rects.forEach {
    $0.indices.forEach { matrix[$0.x][$0.y] += 1 }
}

print(matrix.lazy
    .flatMap { $0 }
    .reduce(0) { $1 > 1 ? $0 + 1 : $0 }) // Part1

for rect in rects {
    if rect.indices.first(where: { matrix[$0.x][$0.y] > 1 }) == nil {
        print(rect.n); break // Part2
    }
}

