//
//  main.swift
//  Day5
//
//  Created by Vyacheslav Khorkov on 05/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Frog

extension Array {
    func collaps(by pattern: (Element, Element) -> Bool,
                 skip: (Element) -> Bool = { _ in false },
                 stop: (Array) -> Bool = { _ in false }) -> Array {
        var stack: [Element] = []
        for element in self {
            if stop(stack) { break }
            else if skip(element) { continue }
            else if stack.isEmpty { stack.append(element) }
            else if pattern(element, stack.last!) { stack.removeLast() }
            else { stack.append(element) }
        }
        return stack
    }
}

extension UInt32 {
    func caseInsensitiveEqual(_ another: UInt32) -> Bool {
        return another == self || another ^ self == 32
    }
}

func silver(_ input: [UInt32]) -> [UInt32] {
    return input.collaps(by: { $0 != $1 && $0.caseInsensitiveEqual($1) })
}

func gold(_ input: [UInt32]) -> Int {
    var min = input.count
    for scalar: UInt32 in 65..<97 {
        min = Swift.min(min, input.collaps(by: { $0 != $1 && $0.caseInsensitiveEqual($1) },
                                           skip: { $0.caseInsensitiveEqual(scalar) },
                                           stop: { $0.count > min }).count)
    }
    return min
}

let unicodeInput = Frog().readLine()!.map { $0.unicodeScalars.first!.value }
measure(silver(unicodeInput).count == 10638) // 1 ms
measure(gold(silver(unicodeInput)) == 4944)  // 3 ms
