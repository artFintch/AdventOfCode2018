//
//  main.swift
//  Day18
//
//  Created by Vyacheslav Khorkov on 18/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Frog
import AdventCode

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

struct Day18: Solution {
    func readInput(from path: String) -> Matrix<Int> {
        let lines = Frog(path).readLines()
        let rows = lines.count
        let columns = lines[0].count
        var matrix = Matrix(columns, rows, 0)
        for y in lines.indices {
            for (x, character) in lines[y].enumerated() {
                switch character {
                case "|":
                    matrix[x, y] = 1
                case "#":
                    matrix[x, y] = 2
                default:
                    continue
                }
            }
        }
        return matrix
    }
    
    func silver(_ matrix: Matrix<Int>) -> Int {
        var matrix = matrix
        for _ in 0..<10 {
            matrix.strangeMagic()
        }
        let woods = matrix.reduce(0) { $0 + ($1 == 1 ? 1 : 0) }
        let lumberyards = matrix.reduce(0) { $0 + ($1 == 2 ? 1 : 0) }
        return woods * lumberyards
    }
    
    func gold(_ matrix: Matrix<Int>) -> Int {
        var matrix = matrix
        var patterns = [matrix.flat(): 0]
        var (firstMatch, iter) = (-1, -1)
        for i in 1..<1000000000 {
            matrix.strangeMagic()
            if patterns[matrix.flat()] != nil {
                firstMatch = patterns[matrix.flat()]!
                iter = i
                break
            } else {
                patterns[matrix.flat()] = i
            }
        }
        
        let end = (1000000000 - firstMatch) % abs(iter - firstMatch) + firstMatch
        let array = patterns.first { $0.value == end }!.key
        
        let woods = array.reduce(0) { $0 + ($1 == 1 ? 1 : 0) }
        let lumberyards = array.reduce(0) { $0 + ($1 == 2 ? 1 : 0) }
        return woods * lumberyards
    }
}
