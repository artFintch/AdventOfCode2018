//
//  ManhattanBfs.swift
//  Day15
//
//  Created by Vyacheslav Khorkov on 15/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

func manhattanBfs(_ start: Point,
                  shifts: [Point],
                  bounds: (columns: Int, rows: Int),
                  skip: (Point) -> Bool,
                  stop: (Point, Int) -> Bool,
                  relaxed: (Point, Matrix<Point>) -> Void,
                  push: (Point) -> Bool) {
    var parents = Matrix(bounds.columns, bounds.rows, Point(-1, -1))
    var distances = Matrix(bounds.columns, bounds.rows, Int.max)
    distances[start] = 0
    
    var queue = [start]
    while !queue.isEmpty {
        let current = queue.removeFirst()
        for shift in shifts where !skip(current + shift) {
            let new = current + shift
            
            guard distances[current] + 1 < distances[new] else { continue }
            distances[new] = distances[current] + 1
            parents[new] = current
            
            if stop(new, distances[new]) { return }
            relaxed(new, parents)
            if push(new) { queue.append(new) }
        }
    }
}

func buildPath(_ from: Point, _ to: Point, _ parents: Matrix<Point>) -> [Point] {
    var path: [Point] = []
    var from = from
    while from != to {
        path.append(from)
        from = parents[from]
    }
    path.reverse()
    return path
}
