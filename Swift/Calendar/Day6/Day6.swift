//
//  main.swift
//  Day6
//
//  Created by Vyacheslav Khorkov on 06/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Frog
import AdventCode

// TODO: Need refactoring
struct Day6: Solution {
    func readInput(from path: String) -> [Point] {
        let lines = Frog(path).readLines()
        let rawPoints = lines
            .map { $0.components(separatedBy: ", ") }
            .map { $0.compactMap(Int.init) }
            .map { a in Point(a[0], a[1]) }
        
        let minx = rawPoints.map { $0.x }.min()!
        let miny = rawPoints.map { $0.y }.min()!
        let points = rawPoints.map { $0 + Point(-minx, -miny) }
        
        return points
    }
    
    func silver(_ points: [Point]) -> Int {
        let w = points.map { $0.x }.max()! + 1
        let h = points.map { $0.y }.max()! + 1
        
        var m = Matrix(w, h, (id: -1, dist: Int.max))
        points.enumerated().forEach {
            m[$0.element] = (id: $0.offset, dist: 0)
        }
        
        func fill(_ points: [Point], _ m: inout Matrix<(id: Int, dist: Int)>) {
            let shifts = [Point(-1, 0), Point(0, -1), Point(0, 1), Point(1, 0)]
            var queues = Dictionary(uniqueKeysWithValues: zip(points.indices, points.map { [$0] }))
            var points = Dictionary(uniqueKeysWithValues: zip(points.indices, points))
            
            while !queues.isEmpty {
                for (index, start) in points {
                    if queues[index]!.isEmpty {
                        queues.removeValue(forKey: index)
                        points.removeValue(forKey: index)
                        continue
                    }
                    
                    let mid = queues[index]!.removeFirst()
                    if m[mid].id != m[start].id { continue }
                    
                    let positions = shifts.lazy
                        .map { $0 + mid }
                        .filter { [m] in m.contains($0) && m[$0].id != m[start].id }
                        .filter { [m] in m[mid].dist + 1 <= m[$0].dist }
                    
                    for p in positions {
                        m[p].id = (m[mid].dist + 1 == m[p].dist) ? -2 : m[start].id
                        m[p].dist = m[mid].dist + 1
                        queues[index]!.append(p)
                    }
                }
            }
        }
        
        fill(Array(points), &m)
        
        let boundary = (m.row(0) + m.row(h - 1) + m.column(0) + m.column(w - 1))
        let s = Set(boundary.map { $0.id })
        
        let ids = m.flat()
            .map { $0.id }
            .filter { !s.contains($0) }
        
        let regions = Dictionary(grouping: ids, by: { $0 }).map { $0.value.count }
        return regions.max()!
    }
    
    func gold(_ points: [Point]) -> Int {
        func fill2(_ p: Point, _ points: [Point], _ m: inout Matrix<Bool>) {
            let shifts = (-1...1).flatMap { y in (-1...1).map { Point($0, y) } }
            var queue = [p]
            
            while !queue.isEmpty {
                let mid = queue.removeFirst()
                
                let positions = shifts.lazy
                    .map { $0 + mid }
                    .filter { [m] in m.contains($0) }
                    .filter { [m] in !m[$0] }
                
                for p in positions where points.map({ p.manhattanDistance($0) }).reduce(0, +) < 10000 {
                    queue.append(p)
                    m[p] = true
                }
            }
        }
        
        let w = points.map { $0.x }.max()! + 1
        let h = points.map { $0.y }.max()! + 1
        var matrix = Matrix(w, h, false)
        fill2(points[0], Array(points), &matrix)
        return matrix.flat().reduce(0) { $0 + ($1 ? 1 : 0) }
    }
}
