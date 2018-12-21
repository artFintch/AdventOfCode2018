//
//  main.swift
//  Day19
//
//  Created by Vyacheslav Khorkov on 19/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

let operations: [String: Operation] = [
    "addr": .init("addr") { $0[$3] = try $0.get($1) + $0.get($2) },
    "addi": .init("addi") { $0[$3] = try $0.get($1) + $2 },
    
    "mulr": .init("mulr") { $0[$3] = try $0.get($1) * $0.get($2) },
    "muli": .init("muli") { $0[$3] = try $0.get($1) * $2 },
    
    "banr": .init("banr") { $0[$3] = try $0.get($1) & $0.get($2) },
    "bani": .init("bani") { $0[$3] = try $0.get($1) & $2 },
    
    "borr": .init("borr") { $0[$3] = try $0.get($1) | $0.get($2) },
    "bori": .init("bori") { $0[$3] = try $0.get($1) | $2 },
    
    "setr": .init("setr") { $0[$3] = try $0.get($1) },
    "seti": .init("seti") { $0[$3] = $1 },
    
    "gtir": .init("gtir") { $0[$3] = try $1 > $0.get($2) ? 1 : 0 },
    "gtri": .init("gtri") { $0[$3] = try $0.get($1) > $2 ? 1 : 0 },
    "gtrr": .init("gtrr") { $0[$3] = try $0.get($1) > $0.get($2) ? 1 : 0 },
    
    "eqir": .init("eqir") { $0[$3] = try $1 == $0.get($2) ? 1 : 0 },
    "eqri": .init("eqri") { $0[$3] = try $0.get($1) == $2 ? 1 : 0 },
    "eqrr": .init("eqrr") { $0[$3] = try $0.get($1) == $0.get($2) ? 1 : 0 }
]

func readInput() -> (Int, [(String, Instruction)]) {
    let input = Frog("input.txt")!
    let pointer = Int(input.readLine()!.components(separatedBy: " ")[1])!
    let lines = input.readLines()
    
    var instructions: [(String, Instruction)] = []
    for line in lines {
        let components = line.components(separatedBy: " ")
        let instruction = Instruction([0] + components.dropFirst().compactMap(Int.init))
        instructions.append((components[0], instruction))
    }
    return (pointer, instructions)
}

func run(_ registers: [Int], debugMode: Bool = false) -> Int {
    var (bound, instructions) = readInput()
    var registers = registers
    var pointer = registers[bound]
    var step = 0
    while instructions.indices ~= pointer {
        registers[bound] = pointer
        let instruction = instructions[pointer]
        let operation = operations[instruction.0]!
        
        if debugMode {
            print(registers.map(String.init).joined(separator: ", "))
            print(instruction.0, instruction.1.a, instruction.1.b, instruction.1.c)
        }
        
        try? registers.apply(operation, instruction.1)
        pointer = registers[bound]
        pointer += 1
        step += 1
        
        if debugMode {
            print(registers.map(String.init).joined(separator: ", "))
            print(pointer)
            print("")
        }
    }
    return registers[0]
}

// Silver
measure(run([0, 0, 0, 0, 0, 0]) == 1440)

// Gold
//measure(run([1, 0, 0, 0, 0, 0], debugMode: true))

//  2 | seti 1 2 3 | r[3] = 1            |
//  3 | mulr 5 3 2 | r[2] = r[5] * r[3]  |
//  4 | eqrr 2 4 2 | r[2] = r[2] == r[4] | 10551358 % divider
//  5 | addr 2 1 1 | r[1] += r[2]        | goto 7
//  6 | addi 1 1 1 | r[1] += 1           | goto 8
//  7 | addr 5 0 0 | r[0] += r[5]        |
//  8 | addi 3 1 3 | r[3] += 1           |
//  9 | gtrr 3 4 2 | r[2] = r[3] > r[4]  |
// 10 | addr 1 2 1 | r[1] += r[2]        | goto 12
// 11 | seti 2 6 1 | r[1] = 2            | goto 3
// 12 | addi 5 1 5 | r[5] += 1           |
// 13 | gtrr 5 4 2 | r[2] = r[5] > r[4]  | [..., 10551359, 10551358]
// 14 | addr 2 1 1 | r[1] += r[2]        | goto 16
// 15 | seti 1 8 1 | r[1] = 1            | goto 2
// 16 | mulr 1 1 1 | r[1] *= r[1]        | => 16*16=256 => end

var sum = 10551358
for divider in 1..<10551358 {
    if 10551358 % divider == 0 {
        sum += divider
    }
}
print(sum)
