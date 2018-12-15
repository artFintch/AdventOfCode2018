//
//  main.swift
//  Day15
//
//  Created by Vyacheslav Khorkov on 15/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

func search(_ kind: Unit.Kind, _ start: Point, _ matrix: Matrix<Unit>) -> [[Point]] {
    var best: Int?
    let stop: (Point, Int) -> Bool = { new, distance in
        if let best = best, distance != best { return true }
        if matrix[new].kind == kind && best == nil { best = distance }
        return false
    }
    
    var found: [[Point]] = []
    let relaxed: (Point, Matrix<Point>) -> Void = { new, parents in
        if matrix[new].kind == kind {
            let path = buildPath(new, start, parents)
            found.append(path)
        }
    }
    
    let shifts = [Point(0, -1), Point(-1, 0), Point(1, 0), Point(0, 1)]
    manhattanBfs(start,
                 shifts: shifts,
                 bounds: (matrix.columns, matrix.rows),
                 skip: { matrix[$0].kind == .wall },
                 stop: stop,
                 relaxed: relaxed,
                 push: {  matrix[$0].kind == .empty })
    
    return found
}

func run(attack: Int = 3, noDeath: Bool = false) -> Int? {
    var (units, elfs, goblins, field) = readField()
    elfs.forEach { $0.attack = attack }
    
    for step in 0..<100 {
        units.sort()
        
        for unit in units where unit.kind != .empty {
            if elfs.isEmpty || goblins.isEmpty {
                let health = elfs.union(goblins).reduce(0) { $0 + $1.health }
                return step * health
            }
            
            let paths = search(unit.kind.aim, unit.position, field)
            var sorted = paths.sorted { $0.count < $1.count }
            
            guard let movePath = sorted.first else { continue }
            if movePath.count != 1 {
                field.swap(unit.position, movePath[0])
                swap(&unit.position, &field[unit.position].position)
                sorted = sorted.map { Array($0.dropFirst()) }
            }
            
            guard 1...2 ~= movePath.count else { continue }
            
            let min = sorted.lazy
                .map { $0[0] }
                .min { (field[$0].health, $0) < (field[$1].health, $1) }
            guard let found = min else { continue }
            
            field[found].health -= unit.attack
            guard field[found].health <= 0 else { continue }
            
            if field[found].kind == .elf {
                elfs.remove(field[found])
                if noDeath { return nil }
            } else {
                goblins.remove(field[found])
            }
            field[found].kind = .empty
        }
    }
    return nil
}

func noDeathRun(attack: Int) -> Int? {
    return run(attack: attack, noDeath: true)
}

measure(run() == 191575) // 17 ms
measure(binarySearch(4..<100, noDeathRun) == (13, 75915)) // 49 ms
