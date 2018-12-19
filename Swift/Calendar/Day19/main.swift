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

func run(_ registers: [Int]) {
    var (bound, instructions) = readInput()
    var registers = registers
    
    var pointer = 0
    var step = 0
    var pointers = [0]
    var patterns: [Int: Int] = [:]
    while instructions.indices ~= pointer {
        registers[bound] = pointer
        let instruction = instructions[pointer]
        let operation = operations[instruction.0]!
        let new = try! registers.applied(operation, instruction.1)
        if new == registers {
//            print(pointer, ":", instruction)
        }
        registers = new
        pointer = registers[bound]
        pointer += 1
//        print(step)
        step += 1
        pointers.append(pointer)
        if step % 1 == 0 {
            print(registers.map(String.init).joined(separator: ", "))
        }
    }
    print(registers)
}

//measure(run([0, 0, 0, 0, 0, 0]))
//measure(run([1, 0, 0, 0, 0, 0]))
