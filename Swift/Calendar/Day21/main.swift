//
//  main.swift
//  Day22
//
//  Created by Vyacheslav Khorkov on 22/12/2018.
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

func silver(_ registers: [Int], debugMode: Bool = false) -> Int {
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
// measure(silver([0, 0, 0, 0, 0, 0], debugMode: true))
// measure(silver([0, 19, 257, 65536, 256, 14339185], debugMode: true))
// measure(silver([1024276, 19, 257, 65536, 256, 14339185], debugMode: true))

func gold(_ r5: Int) -> Int {
    var r5 = r5
    var last = -1
    var r3 = 0
    
    var matches: Set<Int> = []
    while true {
        last = r5
        r3 = r5 | 65536
        r5 = 521363
        
        while true {
            r5 += r3 & 255
            r5 &= 16777215
            r5 *= 65899
            r5 &= 16777215
            if 256 > r3 {
                if !matches.insert(r5).inserted {
                    return last
                } else {
                    break
                }
            }
            
            r3 = r3 / 256
        }
    }
}
measure(gold(1024276) == 5876609)

//    #ip 1
//   00 | seti 123 0 5        | r[5] = 123
//   01 | bani 5 456 5        | r[5] &= 456 // =72
//   02 | eqri 5 72 5         | r[5] = (r[5] == 72)
//   03 | addr 5 1 1          | r[1] += r[5] // |
//   04 | seti 0 0 1          | r[1] = 0     // v
//   05 | seti 0 4 5          | r[5] = 0
//   06 | bori 5 65536 3      | r[3] = r[5] | 65536 // =65536
//   07 | seti 521363 7 5     | r[5] = 521363
//   08 | bani 3 255 4        | r[4] = r[3] & 255 // =0
//   09 | addr 5 4 5          | r[5] += r[4]
//   10 | bani 5 16777215 5   | r[5] &= 16777215 // =521363
//   11 | muli 5 65899 5      | r[5] *= 65899 // =34357300337
//   12 | bani 5 16777215 5   | r[5] &= 16777215 // =14339185
//   13 | gtir 256 3 4        | r[4] = (256 > r[3]) // =0
//   14 | addr 4 1 1          | r[1] += r[4]
//   15 | addi 1 1 1          | r[1] += 1  // |
//   16 | seti 27 1 1         | r[1] = 27  // v
//   17 | seti 0 2 4          | r[4] = 0
//   18 | addi 4 1 2          | r[2] = r[4] + 1 // =1
//   19 | muli 2 256 2        | r[2] *= 256 // =0
//   20 | gtrr 2 3 2          | r[2] = (r[2] > r[3])
//   21 | addr 2 1 1          | r[1] += r[2]
//   22 | addi 1 1 1          | r[1] += 1  // |
//   23 | seti 25 2 1         | r[1] = 25  // v
//   24 | addi 4 1 4          | r[4] += 1
//   25 | seti 17 3 1         | r[1] = 17
//   26 | setr 4 2 3          | r[3] = r[4]
//   27 | seti 7 1 1          | r[1] = 7
//   28 | eqrr 5 0 4          | r[4] = (r[5] == r[0])
//   29 | addr 4 1 1          | r[1] += r[4]
//   30 | seti 5 8 1          | r[1] = 5
