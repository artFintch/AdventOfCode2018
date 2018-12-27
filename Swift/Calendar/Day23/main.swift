//
//  main.swift
//  Day23
//
//  Created by Vyacheslav Khorkov on 23/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

struct Point3D { let x: Int, y: Int, z: Int }
struct Nanobot { let position: Point3D, radius: Int }

func readInput() -> [Nanobot] {
    return Frog("input.txt")!.readLines().map {
        let parts = $0.components(separatedBy: ["<", ",", ">", "="])
        let numbers = parts.compactMap(Int.init)
        let position = Point3D(x: numbers[0], y: numbers[1], z: numbers[2])
        return Nanobot(position: position, radius: numbers[3])
    }
}

extension Nanobot {
    func distance(_ rhs: Point3D = Point3D(x: 0, y: 0, z: 0)) -> Int {
        let (x, y, z) = (position.x, position.y, position.z)
        return Swift.abs(x - rhs.x) + Swift.abs(y - rhs.y) + Swift.abs(z - rhs.z)
    }
}

func silver(_ nanobots: [Nanobot]) -> Int {
    let max = nanobots.max { $0.radius < $1.radius }!
    return nanobots.lazy
        .map { $0.distance(max.position) }
        .filter { $0 <= max.radius }
        .count
}

func gold(_ nanobots: [Nanobot]) -> Int {
    let sorted = nanobots
        .reduce(into: [(distance: Int, isBegin: Int)]()) {
            $0.append(($1.distance() - $1.radius, 1))
            $0.append(($1.distance() + $1.radius, -1))
        }
        .sorted { $0.distance < $1.distance }
    
    return sorted
        .reduce(into: (count: 0, max: 0, distance: 0)) {
            $0.count += $1.isBegin
            if $0.count > $0.max {
                $0.max = $0.count
                $0.distance = $1.distance
            }
        }
        .distance
}

let nanobots = readInput()
measure(silver(nanobots) == 164) // 1 ms
measure(gold(nanobots) == 122951778) // 1 ms
