//
//  IO.swift
//  Day18
//
//  Created by Vyacheslav Khorkov on 18/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Frog

func readInput() -> Matrix<Int> {
    let lines = Frog("input.txt")!.readLines()
    let rows = lines.count
    let columns = lines[0].count
    var matrix = Matrix(columns, rows, 0)
    for y in lines.indices {
        for (x, character) in lines[y].enumerated() {
            switch character {
            case "|":
                matrix[y, x] = 1
            case "#":
                matrix[y, x] = 2
            default:
                continue
            }
        }
    }
    return matrix
}
