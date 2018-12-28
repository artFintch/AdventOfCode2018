//
//  Phases.swift
//  Day24
//
//  Created by Vyacheslav Khorkov on 28/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

func targeting(groups: [Group]) -> [Group: Group] {
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

func attacking(groups: [Group], aims: [Group: Group]) -> [Group]? {
    var sorted = groups.sorted(by: Group.speedPriority)
    for (index, group) in sorted.enumerated() {
        guard let aim = aims[group] else { continue }
        let aimIndex = sorted.firstIndex(of: aim)!
        sorted[aimIndex].attacked(by: sorted[index])
    }
    sorted = sorted.filter { $0.units > 0 }
    return sorted == groups ? nil : sorted
}

func fight(_ groups: [Group], boost: Int = 0) -> Int? {
    var remains = groups.map { $0.isInfection ? $0 : $0.boosted(boost) }
    while Set(remains.map { $0.isInfection }).count == 2 {
        let aims = targeting(groups: remains)
        guard let new = attacking(groups: remains, aims: aims) else { return nil }
        remains = new
    }
    return remains.reduce(0) { $0 + $1.units }
}
