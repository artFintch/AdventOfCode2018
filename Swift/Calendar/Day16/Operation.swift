//
//  Operation.swift
//  Day16
//
//  Created by Vyacheslav Khorkov on 17/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

struct Operation {
    typealias Action = (_ registers: inout [Int], _ a: Int, _ b: Int, _ c: Int) throws -> Void
    let name: String, run: Action
    init(_ name: String, _ run: @escaping Action) {
        (self.name, self.run) = (name, run)
    }
}

extension Operation: Hashable {
    static func == (lhs: Operation, rhs: Operation) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {}
}

extension Array where Element == Int {
    mutating func apply(_ operation: Operation, _ instruction: Instruction) throws {
        try operation.run(&self, instruction.a, instruction.b, instruction.c)
    }
    
    func applied(_ operation: Operation, _ instruction: Instruction) throws -> [Element] {
        var registers = self
        try operation.run(&registers, instruction.a, instruction.b, instruction.c)
        return registers
    }
}
