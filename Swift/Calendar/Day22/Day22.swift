//
//  main.swift
//  Day22
//
//  Created by Vyacheslav Khorkov on 22/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Frog
import AdventCode

struct Day22: Solution {
    func readInput(from path: String) -> (depth: Int, target: Point) {
        let input = Frog(path).readLines()
        let depth = Int(input[0].components(separatedBy: " ")[1])!
        let rawTarget = input[1].components(separatedBy: " ")[1]
        let array = rawTarget.components(separatedBy: ",").compactMap(Int.init)
        let target = Point(array[0], array[1])
        return (depth, target)
    }
    
    func silver(_ input: (depth: Int, target: Point)) -> Int {
        var matrix = buildErosionLevelMatrix(input,
                                             input.target.x + 1,
                                             input.target.y + 1)
        matrix.apply(type)
        return matrix.reduce(0, +)
    }
    
    func gold(_ input: (depth: Int, target: Point)) -> Int {
        var matrix = buildErosionLevelMatrix(input,
                                             input.target.x + 30,
                                             input.target.y + 30)
        matrix.apply(type)
        return bfs(Point(0, 0), matrix)[input.target][1]
    }
    
    private func erosionLevel(_ geologicIndex: Int, _ depth: Int) -> Int {
        return (geologicIndex + depth) % 20183
    }
    
    private func type(_ erosionLevel: Int) -> Int {
        return erosionLevel % 3
    }
    
    private func buildErosionLevelMatrix(_ input: (depth: Int, target: Point),
                                         _ columns: Int,
                                         _ rows: Int) -> Matrix<Int> {
        let (depth, target) = input
        var matrix = Matrix(columns, rows, 0)
        matrix[0, 0] = erosionLevel(0, depth)
        matrix[target] = matrix[0, 0]
        for y in 0..<matrix.rows {
            for x in 0..<matrix.columns {
                if x == 0 && y == 0 { continue }
                if x == target.x && y == target.y { continue }
                
                if x == 0 {
                    matrix[x, y] = erosionLevel(y * 48271, depth)
                } else if y == 0 {
                    matrix[x, y] = erosionLevel(x * 16807, depth)
                } else {
                    matrix[x, y] = erosionLevel(matrix[x - 1, y] * matrix[x, y - 1], depth)
                }
            }
        }
        return matrix
    }
    
    private typealias Statistics = Matrix<[Int]>
    private func bfs(_ begin: Point, _ matrix: Matrix<Int>) -> Statistics {
        let shifts = [Point(0, 1), Point(1, 0), Point(-1, 0), Point(0, -1)]
        let equips: [Int] = [6, 5, 3] // 110 = 6, 101 = 5, 011 = 3
        
        var stats = Statistics(matrix.columns, matrix.rows, [Int.max, Int.max, Int.max])
        stats[begin] = [Int.max, 0, 7]
        
        let queue = NSMutableArray(array: [begin])
        while queue.count != 0 {
            let current = queue.firstObject as! Point
            queue.removeObject(at: 0)
            for shift in shifts where matrix.contains(current + shift) {
                let new = current + shift
                
                var needAdd = false
                let matches = equips[matrix[current]] & equips[matrix[new]]
                var min = -1
                for i in 0..<3 where (matches >> i) & 1 == 1 {
                    if stats[current][i] + 1 < stats[new][i] {
                        stats[new][i] = stats[current][i] + 1
                        needAdd = true
                    }
                    min = stats[new][i]
                }
                
                let rems = equips[matrix[new]] & ~matches
                for i in 0..<3 where (rems >> i) & 1 == 1 {
                    if min + 7 < stats[new][i] {
                        stats[new][i] = min + 7
                        needAdd = true
                    }
                    break
                }
                
                if needAdd {
                    queue.add(new)
                }
            }
        }
        
        return stats
    }
}
