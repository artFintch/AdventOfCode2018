//
//  Unit.swift
//  Day15
//
//  Created by Vyacheslav Khorkov on 15/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

class Unit: Comparable, Hashable {
    enum Kind {
        case wall, empty, goblin, elf
        var aim: Kind { return self == .elf ? .goblin : .elf }
    }
    
    var kind: Kind, position: Point, health: Int, attack: Int
    init(_ kind: Kind, _ position: Point = Point(0, 0)) {
        self.kind = kind
        self.position = position
        self.health = (kind == .elf || kind == .goblin) ? 200 : 0
        self.attack = 3
    }
    
    static func < (lhs: Unit, rhs: Unit) -> Bool {
        return lhs.position < rhs.position
    }
    
    static func == (lhs: Unit, rhs: Unit) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    var hashValue: Int {
        return ObjectIdentifier(self).hashValue
    }
}
