//
//  main.swift
//  Day15
//
//  Created by Vyacheslav Khorkov on 15/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Frog
import AdventCode

// TODO: Refactoring
struct Day15: Solution {    
    func readInput(from path: String) -> ([Unit], Set<Unit>, Set<Unit>, Matrix<Unit>) {
        let lines = Frog(path).readLines().map { Array($0) }
        var field = Matrix(lines[0].count, lines.count, Unit(.wall))
        var elfs: [Unit] = []
        var goblins: [Unit] = []
        for y in lines.indices {
            for x in lines[0].indices {
                let position = Point(x, y)
                switch lines[y][x] {
                case "#":
                    field[x, y] = Unit(.wall, position)
                case ".":
                    field[x, y] = Unit(.empty, position)
                case "G":
                    field[x, y] = Unit(.goblin, position)
                    goblins.append(field[x, y])
                case "E":
                    field[x, y] = Unit(.elf, position)
                    elfs.append(field[x, y])
                default:
                    fatalError()
                }
            }
        }
        
        return (elfs + goblins, Set(elfs), Set(goblins), field)
    }
    
    func silver(_ input: ([Unit], Set<Unit>, Set<Unit>, Matrix<Unit>)) -> Int {
        return run(input)!
    }
    
    func gold(_ input: ([Unit], Set<Unit>, Set<Unit>, Matrix<Unit>)) -> Int? {
        return binarySearch(4..<100) { attack in
            noDeathRun(input, attack: attack)
        }.result
    }
    
    private func run(_ input: ([Unit], Set<Unit>, Set<Unit>, Matrix<Unit>),
                     attack: Int = 3,
                     noDeath: Bool = false) -> Int? {
        var (units, elfs, goblins, field) = input
        units = units.map {
            if $0.kind == .elf {
                return $0.changeAttack(attack)
            } else {
                return $0
            }
        }
        elfs = Set(elfs.map { $0.changeAttack(attack) })
        
        for step in 0..<100 {
            units.sort()
            
            for (index, unit) in units.enumerated() where units[index].kind != .empty {
                if elfs.isEmpty || goblins.isEmpty {
                    let health = units.filter { $0.kind == .elf || $0.kind == .goblin && $0.health > 0 }
                        .reduce(0) { $0 + $1.health }
                    return step * health
                }
                
                let paths = search(unit.kind.aim, unit.position, field)
                var sorted = paths.sorted { $0.count < $1.count }
                
                guard let movePath = sorted.first else { continue }
                if movePath.count != 1 {
                    field.swap(unit.position, movePath[0])
                    field[unit.position].position = unit.position
                    field[movePath[0]].position = movePath[0]
                    units[index].position = movePath[0]
                    sorted = sorted.map { Array($0.dropFirst()) }
                }
                
                guard 1...2 ~= movePath.count else { continue }
                
                let min = sorted.lazy
                    .map { $0[0] }
                    .min { (field[$0].health, $0) < (field[$1].health, $1) }
                guard let found = min else { continue }
                
                // TODO: Refactoring
                let attackedUnitIndex = units.firstIndex(of: field[found])!
                units[attackedUnitIndex].health -= unit.attack
                field[found].health -= unit.attack
                
                guard field[found].health <= 0 else { continue }
                
                if field[found].kind == .elf {
                    elfs.remove(field[found])
                    if noDeath { return nil }
                } else {
                    goblins.remove(field[found])
                }
                
                // TODO: Refactoring
                let killedUnitIndex = units.firstIndex(of: field[found])!
                units[killedUnitIndex].kind = .empty
                field[found].kind = .empty
            }
        }
        return nil
    }
    
    private func noDeathRun(_ input: ([Unit], Set<Unit>, Set<Unit>, Matrix<Unit>),
                            attack: Int) -> Int? {
        return run(input, attack: attack, noDeath: true)
    }
    
    private func search(_ kind: Unit.Kind, _ start: Point, _ matrix: Matrix<Unit>) -> [[Point]] {
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
}
