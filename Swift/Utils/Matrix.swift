//
//  Matrix.swift
//  Day15
//
//  Created by Vyacheslav Khorkov on 15/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

struct Matrix<T> {
    let columns: Int
    let rows: Int
    var array: [T]
    
    init(_ columns: Int, _ rows: Int, _ initialValue: T) {
        self.columns = columns
        self.rows = rows
        array = .init(repeating: initialValue, count: rows * columns)
    }
    
    subscript(_ column: Int, _ row: Int) -> T {
        get { return array[row * columns + column] }
        set { array[row * columns + column] = newValue }
    }
    
    subscript(_ point: Point) -> T {
        get { return array[point.y * columns + point.x] }
        set { array[point.y * columns + point.x] = newValue }
    }
    
    mutating func swap(_ one: Point, _ two: Point) {
        array.swapAt(one.y * columns + one.x,
                     two.y * columns + two.x)
    }
}
