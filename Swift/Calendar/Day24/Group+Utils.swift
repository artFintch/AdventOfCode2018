//
//  Group+Utils.swift
//  Day24
//
//  Created by Vyacheslav Khorkov on 28/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

extension Group {
    static let attackPriority: (Group, Group) -> Bool = {
        ($0.power, $0.speed) > ($1.power, $1.speed)
    }
    
    static let targetPriority: (Group, Group, Group) -> Bool = {
        ($0.dmg(from: $2), $0.power, $0.speed) < ($1.dmg(from: $2), $1.power, $1.speed)
    }
    
    static let speedPriority: (Group, Group) -> Bool = {
        $0.speed > $1.speed
    }
    
    var power: Int { return units * dmg }
    
    func dmg(from group: Group) -> Int {
        if immune.contains(group.dmgType) { return 0 }
        let m = weak.contains(group.dmgType) ? 2 : 1
        return group.power * m
    }
    
    mutating func attacked(by group: Group) {
        if immune.contains(group.dmgType) { return }
        let deaths = dmg(from: group) / hp
        units -= deaths
    }
    
    func boosted(_ boost: Int) -> Group {
        var new = self
        new.dmg += boost
        return new
    }
}
