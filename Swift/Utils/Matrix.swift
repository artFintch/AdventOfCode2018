//
//  Matrix.swift
//  Day15
//
//  Created by Vyacheslav Khorkov on 15/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

struct Matrix<Element> {
    let columns: Int
    let rows: Int
    var array: [Element]
    
    init(_ columns: Int, _ rows: Int, _ initialValue: Element) {
        self.columns = columns
        self.rows = rows
        array = .init(repeating: initialValue, count: rows * columns)
    }
    
    subscript(_ column: Int, _ row: Int) -> Element {
        get { return array[row * columns + column] }
        set { array[row * columns + column] = newValue }
    }
}

extension Matrix {
    subscript(_ point: Point) -> Element {
        get { return array[point.y * columns + point.x] }
        set { array[point.y * columns + point.x] = newValue }
    }
    
    func contains(_ point: Point) -> Bool {
        return 0..<columns ~= point.x && 0..<rows ~= point.y
    }
    
    mutating func swap(_ one: Point, _ two: Point) {
        array.swapAt(one.y * columns + one.x,
                     two.y * columns + two.x)
    }
    
    mutating func apply(_ transform: (Element) -> Element) {
        for index in array.indices {
            array[index] = transform(array[index])
        }
    }
    
    func reduce<Result>(_ initialResult: Result,
                        _ nextPartialResult: (Result, Element) -> Result) -> Result {
        return array.reduce(initialResult, nextPartialResult)
    }
}
