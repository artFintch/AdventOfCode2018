//
//  IO.swift
//  Day17
//
//  Created by Vyacheslav Khorkov on 18/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Frog

typealias Ranges = (x: [(Int, ClosedRange<Int>)], y: [(Int, ClosedRange<Int>)])
func readInput() -> Ranges {
    let lines = Frog("input.txt")!.readLines()
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
    return (xRanges, yRanges)
}

extension ClosedRange where Bound == Int {
    mutating func shifted(_ value: Int) -> ClosedRange {
        return ClosedRange(uncheckedBounds: (lowerBound - value,
                                             upperBound - value))
    }
}

func truncateRanges(_ ranges: Ranges) -> (Ranges, Int, Int, Int, Int) {
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

func buildMatrix() -> (Matrix<Int>, Point, Int) {
    let (ranges, w, h, xMin, yMax) = truncateRanges(readInput())
    
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
