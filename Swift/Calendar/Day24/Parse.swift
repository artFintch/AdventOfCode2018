//
//  Parse.swift
//  Day24
//
//  Created by Vyacheslav Khorkov on 28/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

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
