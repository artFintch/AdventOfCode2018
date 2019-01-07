//
//  main.swift
//  Day3
//
//  Created by Vyacheslav Khorkov on 03/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Frog
import AdventCode

extension Matrix where Element == Int {
    mutating func fill(_ rectangles: [Rectangle]) {
        for rectangle in rectangles {
            for point in rectangle {
                self[point] += 1
            }
        }
    }
}

struct Day3: Solution {
    func readInput(from path: String) -> [Rectangle] {
        return Frog(path).readLines().lazy
            .map { $0.components(separatedBy: ["#", "@", ":", " ", ",", "x"]) }
            .map { $0.compactMap(Int.init) }
            .map { Rectangle(id: $0[0],
                             position: Point($0[1], $0[2]),
                             size: Size($0[3], $0[4])) }
    }
    
    func silver(_ rectangles: [Rectangle]) -> Int {
        var matrix = Matrix(1000, 1000, 0)
        matrix.fill(rectangles)
        
        return matrix.reduce(into: 0) { (count, element) in
            count += (element > 1) ? 1 : 0
        }
    }
    
    func gold(_ rectangles: [Rectangle]) -> Int? {
        var matrix = Matrix(1000, 1000, 0)
        matrix.fill(rectangles)
        
        for rectangle in rectangles {
            if rectangle.contains(where: { matrix[$0] > 1 }) { continue }
            return rectangle.id
        }
        return nil
    }
}
