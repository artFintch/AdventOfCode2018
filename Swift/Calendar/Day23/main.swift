//
//  main.swift
//  Day22
//
//  Created by Vyacheslav Khorkov on 22/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

struct Point3D {
    let x: Int, y: Int, z: Int
}

struct Nanobot {
    let pos: Point3D
    let radius: Int
}

func readInput() -> [Nanobot] {
    let lines = Frog("input.txt")!.readLines()
    var nanobots: [Nanobot] = []
    for line in lines {
        let parts = line.components(separatedBy: ["<", ",", ">", "="])
        let numbers = parts.compactMap(Int.init)
        let pos = Point3D(x: numbers[0], y: numbers[1], z: numbers[2])
        let radius = numbers[3]
        let nanobot = Nanobot(pos: pos, radius: radius)
        nanobots.append(nanobot)
    }
    return nanobots
}

extension Nanobot {
    func distance(_ rhs: Nanobot) -> Int {
        return abs(pos.x - rhs.pos.x) + abs(pos.y - rhs.pos.y) + abs(pos.z - rhs.pos.z)
    }
}

func silver(_ nanobots: [Nanobot]) -> Int {
    let max = nanobots.max { $0.radius < $1.radius }!
    return nanobots.lazy
        .map { $0.distance(max) }
        .filter { $0 <= max.radius }
        .count
}

func gold() -> Int {
    // TODO:
    return 0
}

let nanobots = readInput()
measure(silver(nanobots) == 164)
