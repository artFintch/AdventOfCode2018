//
//  main.swift
//  Day18
//
//  Created by Vyacheslav Khorkov on 18/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

extension Matrix where Element == Int {
    
    func adjacent(_ x: Int, _ y: Int) -> [Point] {
        var points: [Point] = []
        for row in -1...1 {
            for column in -1...1 {
                if row == 0 && column == 0 { continue }
                let point = Point(x + column, y + row)
                if contains(point) {
                    points.append(point)
                }
            }
        }
        return points
    }
    
    mutating func strangeMagic() {
        var newMatrix = self
        for y in 0..<rows {
            for x in 0..<columns {
                let statistics = NSCountedSet(array: adjacent(x, y).map { self[$0] })
                switch self[x, y] {
                case 0 where statistics.count(for: 1) >= 3:
                    newMatrix[x, y] = 1
                case 1 where statistics.count(for: 2) >= 3:
                    newMatrix[x, y] = 2
                case 2:
                    if statistics.count(for: 1) < 1 || statistics.count(for: 2) < 1 {
                        newMatrix[x, y] = 0
                    }
                default:
                    continue
                }
            }
        }
        self = newMatrix
    }
}

func run() -> Int {
    var matrix = readInput()
    for _ in 0..<10 {
        matrix.strangeMagic()
    }
    let woods = matrix.array.reduce(0) { $0 + ($1 == 1 ? 1 : 0) }
    let lumberyards = matrix.array.reduce(0) { $0 + ($1 == 2 ? 1 : 0) }
    print(woods, lumberyards)
    return woods * lumberyards
}

func run2() -> Int {
    var matrix = readInput()
    var patterns = [matrix.array: 0]
    var (firstMatch, iter) = (-1, -1)
    for i in 1..<1000000000 {
        matrix.strangeMagic()
        if patterns[matrix.array] != nil {
            
            firstMatch = patterns[matrix.array]!
            iter = i
            print(firstMatch, i)
            break
        } else {
            patterns[matrix.array] = i
        }
    }
    
    let end = (1000000000 - firstMatch) % abs(iter - firstMatch) + firstMatch
    let array = patterns.first { $0.value == end }!.key
    
    let woods = array.reduce(0) { $0 + ($1 == 1 ? 1 : 0) }
    let lumberyards = array.reduce(0) { $0 + ($1 == 2 ? 1 : 0) }
    print(woods, lumberyards)
    return woods * lumberyards
}

//measure(run())
measure(run2())
