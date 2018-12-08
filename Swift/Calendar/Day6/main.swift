//
//  main.swift
//  Day6
//
//  Created by Vyacheslav Khorkov on 06/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

// Utils
struct Point {
    let x: Int, y: Int
    
    func dist(_ rhs: Point) -> Int {
        return abs(x - rhs.x) + abs(y - rhs.y)
    }
    
    static func +(_ lhs: Point, _ rhs: Point) -> Point {
        return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

struct Matrix<Element> {
    private var m: [[Element]]
    
    init(w: Int, h: Int, base: Element) {
        m = .init(repeating: .init(repeating: base, count: w), count: h)
    }
    
    func contains(_ p: Point) -> Bool {
        return m.indices ~= p.y && (m.first ?? []).indices ~= p.x
    }
    
    subscript(_ p: Point) -> Element {
        get { return m[p.y][p.x] }
        set { m[p.y][p.x] = newValue }
    }
    
    func row(_ r: Int) -> [Element] { return m[r] }
    func column(_ c: Int) -> [Element] { return m.map { $0[c] } }
    func flat() -> [Element] { return m.flatMap { $0 } }
}


// Input
let lines = Frog("input.txt")!.readLines()
let rawPoints = lines.lazy
    .map { $0.components(separatedBy: ", ") }
    .map { $0.compactMap(Int.init) }
    .map { a in Point(x: a[0], y: a[1]) }

let minx = rawPoints.map { $0.x }.min()!
let miny = rawPoints.map { $0.y }.min()!
let points = rawPoints.map { $0 + Point(x: -minx, y: -miny) }
let w = points.map { $0.x }.max()! + 1
let h = points.map { $0.y }.max()! + 1


// Part1
var m = Matrix(w: w, h: h, base: (id: -1, dist: Int.max))
points.enumerated().forEach {
    m[$0.element] = (id: $0.offset, dist: 0)
}

func fill(_ points: [Point], _ m: inout Matrix<(id: Int, dist: Int)>) {
    let shifts = [Point(x: -1, y: 0), Point(x: 0, y: -1), Point(x: 0, y: 1), Point(x: 1, y: 0)]
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
print(regions.max()!)


// Part2
func fill2(_ p: Point, _ points: [Point], _ m: inout Matrix<Bool>) {
    let shifts = (-1...1).flatMap { y in (-1...1).map { Point(x: $0, y: y) } }
    var queue = [p]
    
    while !queue.isEmpty {
        let mid = queue.removeFirst()
        
        let positions = shifts.lazy
            .map { $0 + mid }
            .filter { [m] in m.contains($0) }
            .filter { [m] in !m[$0] }

        for p in positions where points.map({ p.dist($0) }).reduce(0, +) < 10000 {
            queue.append(p)
            m[p] = true
        }
    }
}

var matrix = Matrix(w: w, h: h, base: false)
fill2(points[0], Array(points), &matrix)
print(matrix.flat().reduce(0) { $0 + ($1 ? 1 : 0) })
