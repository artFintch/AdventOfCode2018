//
//  Sample.swift
//  Day16
//
//  Created by Vyacheslav Khorkov on 17/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Frog

struct Sample {
    let before: [Int], after: [Int]
    let instruction: Instruction
    init(_ lines: [String]) {
        (before, after) = (lines[0].ints, lines[2].ints)
        instruction = Instruction(lines[1].ints)
    }
}

extension Frog {
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

extension Frog {
    func readSample() -> Sample? {
        let lines = readLines(3, stopEmpty: true)
        guard lines.count == 3 else { return nil }
        skip()
        return Sample(lines)
    }
}
