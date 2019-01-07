//
//  main.swift
//  Day24
//
//  Created by Vyacheslav Khorkov on 24/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Frog
import AdventCode

struct Day24: Solution {
    func readInput(from path: String) -> [Group] {
        let armies = Frog(path).readLines().split(separator: "")
        return parse(armies[0], false) + parse(armies[1], true)
    }
    
    func silver(_ input: [Group]) -> Int? {
        return fight(input)
    }
    
    func gold(_ input: [Group]) -> Int? {
        return binarySearch(1..<50) { boost in
            return fight(input, boost: boost)
        }.result
    }
    
    private func parse(_ army: ArraySlice<String>, _ isInfection: Bool) -> [Group] {
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
                let defense = group
                    .components(separatedBy: ["(", ")"])[1]
                    .components(separatedBy: ";")
                
                for type in defense {
                    let dmgTypes = type
                        .components(separatedBy: [" ", ","])
                        .filter { !$0.isEmpty }
                        .dropFirst(2)
                    
                    if type.contains("immune") {
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
    
    private func targeting(groups: [Group]) -> [Group: Group] {
        var aims: [Group: Group] = [:]
        var chosen: Set<Group> = []
        let sorted = groups.sorted(by: Group.attackPriority)
        for group in sorted {
            let best = groups
                .filter { !chosen.contains($0) && $0.isInfection != group.isInfection }
                .max { Group.targetPriority($0, $1, group) }
            if let best = best, best.dmg(from: group) > 0 {
                aims[group] = best
                chosen.insert(best)
            }
        }
        return aims
    }
    
    private func attacking(groups: [Group], aims: [Group: Group]) -> [Group]? {
        var sorted = groups.sorted(by: Group.speedPriority)
        for (index, group) in sorted.enumerated() {
            guard let aim = aims[group] else { continue }
            let aimIndex = sorted.firstIndex(of: aim)!
            sorted[aimIndex].attacked(by: sorted[index])
        }
        sorted = sorted.filter { $0.units > 0 }
        return sorted == groups ? nil : sorted
    }
    
    private func fight(_ groups: [Group], boost: Int = 0) -> Int? {
        var remains = groups.map { $0.isInfection ? $0 : $0.boosted(boost) }
        while Set(remains.map { $0.isInfection }).count == 2 {
            let aims = targeting(groups: remains)
            guard let new = attacking(groups: remains, aims: aims) else { return nil }
            remains = new
        }
        return remains.reduce(0) { $0 + $1.units }
    }
}
