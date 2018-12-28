//
//  Group.swift
//  Day25
//
//  Created by Vyacheslav Khorkov on 28/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

struct Group: Hashable {
    let id: Int
    let isInfection: Bool
    var units: Int
    let hp: Int
    var dmg: Int
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
    
//    static func == (lhs: Group, rhs: Group) -> Bool {
//        return lhs.id == rhs.id
//    }
    
    func hash(into hasher: inout Hasher) {
    }
}
