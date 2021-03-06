//
//  main.swift
//  Day10
//
//  Created by Vyacheslav Khorkov on 10/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Frog
import AdventCode

struct Vector: Equatable {
    private(set) var x: Int, y: Int
    private(set) var dx: Int, dy: Int
    
    init(_ array: [Int]) {
        self.x = array[0]
        self.y = array[1]
        self.dx = array[2]
        self.dy = array[3]
    }
    
    func move(_ steps: Int) -> Vector {
        var new = self
        new.x += dx * steps
        new.y += dy * steps
        return new
    }
    
    func move(_ dx: Int, _ dy: Int) -> Vector {
        var new = self
        new.x += dx
        new.y += dy
        return new
    }
    
    func distance(to: Vector) -> Int {
        return abs(x - to.x) + abs(y - to.y)
    }
}

extension Array where Element == Vector {
    var ziped: Array<Element> {
        let minx = map { $0.x }.min()!
        let miny = map { $0.y }.min()!
        return map { $0.move(-minx, -miny) }
    }
    
    var matrix: [[String]] {
        let maxx = map { $0.x }.max()! + 1
        let maxy = map { $0.y }.max()! + 1
        let row = [String](repeating: " ", count: maxx)
        var matrix = [[String]](repeating: row, count: maxy)
        forEach { matrix[$0.y][$0.x] = "O" }
        return matrix
    }
    
    func maxDistance(_ threshold: Int? = nil) -> Int {
        var maxd = 0
        for first in self {
            let mind = lazy.filter { first != $0 }
                .map { first.distance(to: $0) }
                .min()!
            if threshold.map({ mind > $0 }) ?? false { return mind }
            maxd = Swift.max(maxd, mind)
        }
        return maxd
    }
}

struct Day10: Solution {
    func readInput(from path: String) -> [Vector] {
        let lines = Frog(path).readLines()
        return lines
            .map { $0.components(separatedBy: ["<", " ", ",", ">"]) }
            .map { $0.compactMap(Int.init) }
            .map(Vector.init)
    }
    
    func silver(_ vectors: [Vector]) -> Manual {
        return Manual()
    }
    
    func gold(_ vectors: [Vector]) -> Int {
        var vectors = vectors
        var seconds = 0
        while vectors.maxDistance(2) > 2 {
            let steps = vectors.maxDistance() / 2 - 2
            vectors = vectors.map { $0.move(steps) }
            seconds += steps
        }
        return seconds
    }
}
