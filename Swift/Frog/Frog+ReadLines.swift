//
//  Frog+ReadLines.swift
//  Day16
//
//  Created by Vyacheslav Khorkov on 16/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Frog

public extension Frog {
    
    func readLines(_ count: Int, stopEmpty: Bool = false) -> [String] {
        var lines: [String] = []
        for _ in 0..<count {
            guard let line = readLine() else { break }
            if stopEmpty && line.isEmpty { break }
            lines.append(line)
        }
        return lines
    }
    
    func skip() {
        _ = readLine()
    }
}
