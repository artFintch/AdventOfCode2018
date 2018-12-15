//
//  Point.swift
//  Day15
//
//  Created by Vyacheslav Khorkov on 15/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

struct Point: Comparable, Hashable {
    var x: Int, y: Int
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    static func < (lhs: Point, rhs: Point) -> Bool {
        return (lhs.y, lhs.x) < (rhs.y, rhs.x)
    }
    
    static func + (lhs: Point, rhs: Point) -> Point {
        return Point(lhs.x + rhs.x, lhs.y + rhs.y)
    }
}
