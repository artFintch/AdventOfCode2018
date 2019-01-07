//
//  main.swift
//  Day17
//
//  Created by Vyacheslav Khorkov on 17/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Frog
import AdventCode

// TODO: REFUCK THAT SHIT!
struct Day17: Solution {
    typealias Ranges = (x: [(Int, ClosedRange<Int>)], y: [(Int, ClosedRange<Int>)])
    func readInput(from path: String) -> (Matrix<Int>, Point, Int) {
        let lines = Frog(path).readLines()
        var xRanges: [(Int, ClosedRange<Int>)] = []
        var yRanges: [(Int, ClosedRange<Int>)] = []
        for line in lines {
            let components = line.components(separatedBy: ["=", ",", " ", "."]).filter { !$0.isEmpty }
            let coordinate = Int(components[1])!
            let range = ClosedRange(uncheckedBounds: (Int(components[3])!, Int(components[4])!))
            if components[0] == "x" {
                xRanges.append((coordinate, range))
            } else {
                yRanges.append((coordinate, range))
            }
        }
        
        return buildMatrix((xRanges, yRanges))
    }
    
    func silver(_ input: (Matrix<Int>, Point, Int)) -> Int {
        var (matrix, spring, yMax) = input
        
        var seen = Set<Point>()
        dfs(spring, yMax, &matrix, &seen)
        
        return 1 + matrix.reduce(0) { $0 + ($1 == 2 ? 1 : 0) }
    }
    
    func gold(_ input: (Matrix<Int>, Point, Int)) -> Int {
        var (matrix, spring, yMax) = input
        
        var seen = Set<Point>()
        dfs(spring, yMax, &matrix, &seen)
        
        for y in 0..<matrix.rows {
            for x in 0..<matrix.columns {
                if matrix[x, y] == 2 {
                    let left = Point(x, y) + Point(-1, 0)
                    let right = Point(x, y) + Point(1, 0)
                    if matrix.contains(left) && matrix.contains(right) {
                        if (matrix[left] == 1 || matrix[left] == 2) && (matrix[right] == 1 || matrix[right] == 2) {
                            continue
                        } else {
                            matrix[x, y] = 0
                        }
                    } else {
                        matrix[x, y] = 0
                    }
                }
            }
            
            for x in (0..<matrix.columns).reversed() {
                if matrix[x, y] == 2 {
                    let left = Point(x, y) + Point(-1, 0)
                    let right = Point(x, y) + Point(1, 0)
                    if matrix.contains(left) && matrix.contains(right) {
                        if (matrix[left] == 1 || matrix[left] == 2) && (matrix[right] == 1 || matrix[right] == 2) {
                            continue
                        } else {
                            matrix[x, y] = 0
                        }
                    } else {
                        matrix[x, y] = 0
                    }
                }
            }
        }
        
        return matrix.reduce(0) { $0 + ($1 == 2 ? 1 : 0) }
    }
    
    @discardableResult private func dfs(_ begin: Point,
                                        _ maxY: Int,
                                        _ matrix: inout Matrix<Int>,
                                        _ seen: inout Set<Point>,
                                        _ isTop: Bool = false) -> Bool {
        let bottom = begin + Point(0, 1)
        if bottom.y == matrix.rows {
            seen.insert(begin)
            return true
        }
        
        if seen.contains(bottom) {
            return true
        }
        
        var flag = false
        if  matrix.contains(bottom) && matrix[bottom] == 0 {
            matrix[bottom] = 2
            flag = dfs(bottom, maxY, &matrix, &seen)
        }
        
        if flag {
            seen.insert(begin)
            return true
        }
        
        var leftPath = isTop
        let left = begin + Point(-1, 0)
        if matrix.contains(left) && matrix[left] == 0 {
            matrix[left] = 2
            leftPath = dfs(left, maxY, &matrix, &seen)
        }
        
        var rightPath = false
        let right = begin + Point(1, 0)
        if matrix.contains(right) && matrix[right] == 0 {
            matrix[right] = 2
            rightPath = dfs(right, maxY, &matrix, &seen, leftPath)
        }
        
        if leftPath || rightPath || isTop {
            seen.insert(begin)
        }
        
        return leftPath || rightPath
    }
    
    private func buildMatrix(_ ranges: Ranges) -> (Matrix<Int>, Point, Int) {
        let (ranges, w, h, xMin, yMax) = truncateRanges(ranges)
        
        var matrix = Matrix(w + 2, h + 1, 0)
        for range in ranges.x {
            for y in range.1 {
                matrix[range.0, y] = 1
            }
        }
        
        for range in ranges.y {
            for x in range.1 {
                matrix[x, range.0] = 1
            }
        }
        
        let spring = Point(500 - xMin, 0)
        
        return (matrix, spring, yMax)
    }
    
    private func truncateRanges(_ ranges: Ranges) -> (Ranges, Int, Int, Int, Int) {
        var ranges = ranges
        
        let xMin = min(ranges.x.min { $0.0 < $1.0 }!.0,
                       ranges.y.min { $0.1.lowerBound < $1.1.lowerBound }!.1.lowerBound) - 1
        let yMin = min(ranges.y.min { $0.0 < $1.0 }!.0,
                       ranges.x.min { $0.1.lowerBound < $1.1.lowerBound }!.1.lowerBound)
        let xMax = max(ranges.x.max { $0.0 < $1.0 }!.0,
                       ranges.y.max { $0.1.upperBound < $1.1.upperBound }!.1.upperBound)
        let yMax = max(ranges.y.max { $0.0 < $1.0 }!.0,
                       ranges.x.max { $0.1.upperBound < $1.1.upperBound }!.1.upperBound)
        
        ranges.x = ranges.x.map { ($0.0 - xMin, ClosedRange(uncheckedBounds: ($0.1.lowerBound - yMin,
                                                                              $0.1.upperBound - yMin))) }
        ranges.y = ranges.y.map { ($0.0 - yMin, ClosedRange(uncheckedBounds: ($0.1.lowerBound - xMin,
                                                                              $0.1.upperBound - xMin))) }
        return (ranges, xMax - xMin, yMax - yMin, xMin, yMax)
    }
}

