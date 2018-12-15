//
//  Array+Matrix.swift
//  Day15
//
//  Created by Vyacheslav Khorkov on 15/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

extension Array where Element: MutableCollection, Element.Index == Int {
    subscript(_ point: Point) -> Element.Iterator.Element {
        get { return self[point.y][point.x] }
        set { self[point.y][point.x] = newValue }
    }
}
