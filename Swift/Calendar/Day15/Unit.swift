//
//  Unit.swift
//  Day15
//
//  Created by Vyacheslav Khorkov on 15/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import AdventCode

struct Unit: Comparable, Hashable {
    enum Kind {
        case wall, empty, goblin, elf
        var aim: Kind { return self == .elf ? .goblin : .elf }
    }
    
    private var id: Int
    static var _id = 0
    
    var kind: Kind, position: Point, health: Int, attack: Int
    init(_ kind: Kind, _ position: Point = Point(0, 0)) {
        self.id = Unit._id
        Unit._id += 1
        
        self.kind = kind
        self.position = position
        self.health = (kind == .elf || kind == .goblin) ? 200 : 0
        self.attack = 3
    }
    
    static func < (lhs: Unit, rhs: Unit) -> Bool {
        return lhs.position < rhs.position
    }
    
    func changeAttack(_ attack: Int) -> Unit {
        var new = self
        new.attack = attack
        return new
    }
    
    static func == (lhs: Unit, rhs: Unit) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
