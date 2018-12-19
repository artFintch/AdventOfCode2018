//
//  Instruction.swift
//  Day16
//
//  Created by Vyacheslav Khorkov on 17/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

struct Instruction {
    let code: Int, a: Int, b: Int, c: Int
    init(_ ar: [Int]) {
        (code, a, b, c) = (ar[0], ar[1], ar[2], ar[3])
    }
}
