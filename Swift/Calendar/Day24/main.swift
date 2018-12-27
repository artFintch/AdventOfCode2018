//
//  main.swift
//  Day23
//
//  Created by Vyacheslav Khorkov on 23/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

class Group: Hashable {
    let id: Int
    let isInfection: Bool
    var units: Int
    let hp: Int
    let dmg: Int
    let immune: [String]
    let weak: [String]
    let dmgType: String
    let speed: Int
    
    private static var _id = 0
    
    init(isInfection: Bool,
         units: Int,
         hp: Int,
         dmg: Int,
         immune: [String],
         weak: [String],
         dmgType: String,
         speed: Int) {
        self.id = Group._id
        Group._id += 1
        self.isInfection = isInfection
        self.units = units
        self.hp = hp
        self.dmg = dmg
        self.immune = immune
        self.weak = weak
        self.dmgType = dmgType
        self.speed = speed
    }
    
    static func == (lhs: Group, rhs: Group) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {}
}

func parse(_ army: ArraySlice<String>, _ isInfection: Bool) -> [Group] {
    var groups: [Group] = []
    for group in army.dropFirst() {
        let parts = group.components(separatedBy: [" "])
        
        let numbers = parts.compactMap(Int.init)
        let units = numbers[0]
        let hp = numbers[1]
        let dmg = numbers[2]
        let speed = numbers[3]
        let dmgType = parts[parts.count - 5]
        
        var immune: [String] = []
        var weak: [String] = []
        if group.contains(")") {
            let defense = group.components(separatedBy: ["(", ")"])[1].components(separatedBy: ";")
            for type in defense {
                let dmgTypes = type
                    .components(separatedBy: [" ", ","])
                    .filter { !$0.isEmpty }
                    .dropFirst(2)
                if type.hasPrefix("immune") {
                    immune = Array(dmgTypes)
                } else {
                    weak = Array(dmgTypes)
                }
            }
        }
        groups.append(Group(isInfection: isInfection,
                            units: units,
                            hp: hp,
                            dmg: dmg,
                            immune: immune,
                            weak: weak,
                            dmgType: dmgType,
                            speed: speed))
    }
    return groups
}

func readInput() -> [Group] {
    let lines = Frog("input.txt")!.readLines()
    let armies = lines.split(separator: "")
    return parse(armies[0], false) + parse(armies[1], true)
}

extension Group {
    var power: Int { return units * dmg }
    
    func dmg(from group: Group) -> Int {
        if immune.contains(group.dmgType) { return 0 }
        let m = weak.contains(group.dmgType) ? 2 : 1
        return group.power * m
    }
    
    func attacked(by group: Group) {
        if immune.contains(group.dmgType) { return }
        let deaths = dmg(from: group) / hp
        units -= deaths
    }
}

func targeting(groups: [Group]) -> [Group: Group] {
    var aims: [Group: Group] = [:]
    var chosen: Set<Group> = []
    let sorted = groups.sorted { ($0.power, $0.speed) > ($1.power, $1.speed) }
    for group in sorted {
        let best = groups
            .filter { $0 != group && !chosen.contains($0) && $0.isInfection != group.isInfection }
            .max {
                ($0.dmg(from: group), $0.power, $0.speed) < ($1.dmg(from: group), $1.power, $1.speed)
        }
        if let best = best {
            aims[group] = best
            chosen.insert(best)
        }
    }
    return aims
}

func attacking(groups: [Group], aims: [Group: Group]) -> [Group] {
    let sorted = groups.sorted { $0.speed > $1.speed }
    for group in sorted where group.units > 0 {
        if let aim = aims[group] {
            aim.attacked(by: group)
        }
    }
    return sorted.filter { $0.units > 0 }
}

func fight(_ groups: [Group]) -> Int {
    var remain = groups
    repeat {
        let aims = targeting(groups: remain)
        remain = attacking(groups: remain, aims: aims)
    } while remain.contains { $0.isInfection } && remain.contains { !$0.isInfection }
    return remain.reduce(0) { $0 + $1.units }
}

let groups = readInput()
print(fight(groups))

//    Immune System:
//    17 units each with 5390 hit points (weak to radiation, bludgeoning) with
//    an attack that does 4507 fire damage at initiative 2
//    989 units each with 1274 hit points (immune to fire; weak to bludgeoning,
//    slashing) with an attack that does 25 slashing damage at initiative 3
//
//    Infection:
//    801 units each with 4706 hit points (weak to radiation) with an attack
//    that does 116 bludgeoning damage at initiative 1
//    4485 units each with 2961 hit points (immune to radiation; weak to fire,
//    cold) with an attack that does 12 slashing damage at initiative 4
