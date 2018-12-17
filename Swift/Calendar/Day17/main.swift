//
//  main.swift
//  Day17
//
//  Created by Vyacheslav Khorkov on 17/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

// TODO: REFUCK THAT SHIT!

var seen = Set<Point>()

func dfs(_ begin: Point, _ maxY: Int, _ matrix: inout Matrix<Int>, _ isTop: Bool = false) -> Bool {
    let bottom = begin + Point(0, 1)
    if bottom.y == matrix.rows {
        seen.insert(begin)
        return true
    }
    
    if seen.contains(bottom) {
        return true
    }
    
    var flag = false
    if  matrix.contains(bottom) && matrix[bottom] == 0 {
        matrix[bottom] = 2
        flag = dfs(bottom, maxY, &matrix)
    }
    
    if flag {
        seen.insert(begin)
        return true
    }
    
    var leftPath = isTop
    let left = begin + Point(-1, 0)
    if matrix.contains(left) && matrix[left] == 0 {
        matrix[left] = 2
        leftPath = dfs(left, maxY, &matrix)
    }
    
    var rightPath = false
    let right = begin + Point(1, 0)
    if matrix.contains(right) && matrix[right] == 0 {
        matrix[right] = 2
        rightPath = dfs(right, maxY, &matrix, leftPath)
    }
    
    if leftPath || rightPath || isTop {
        seen.insert(begin)
    }
    
    return leftPath || rightPath
}

func run() {
    var (matrix, spring, yMax) = buildMatrix()
    _ = dfs(spring, yMax, &matrix)
    
     print(1 + matrix.array.reduce(0) { $0 + ($1 == 2 ? 1 : 0) } == 30635)
    
    for y in 0..<matrix.rows {
        for x in 0..<matrix.columns {
            if matrix[x, y] == 2 {
                let left = Point(x, y) + Point(-1, 0)
                let right = Point(x, y) + Point(1, 0)
                if matrix.contains(left) && matrix.contains(right) {
                    if (matrix[left] == 1 || matrix[left] == 2) && (matrix[right] == 1 || matrix[right] == 2) {
                        continue
                    } else {
                        matrix[x, y] = 0
                    }
                } else {
                    matrix[x, y] = 0
                }
            }
        }
        
        for x in (0..<matrix.columns).reversed() {
            if matrix[x, y] == 2 {
                let left = Point(x, y) + Point(-1, 0)
                let right = Point(x, y) + Point(1, 0)
                if matrix.contains(left) && matrix.contains(right) {
                    if (matrix[left] == 1 || matrix[left] == 2) && (matrix[right] == 1 || matrix[right] == 2) {
                        continue
                    } else {
                        matrix[x, y] = 0
                    }
                } else {
                    matrix[x, y] = 0
                }
            }
        }
    }
    
    print(matrix.array.reduce(0) { $0 + ($1 == 2 ? 1 : 0) } == 25094)
}

measure(run()) // 23 ms
