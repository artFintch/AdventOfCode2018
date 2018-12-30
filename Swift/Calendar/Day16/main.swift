//
//  main.swift
//  Day16
//
//  Created by Vyacheslav Khorkov on 16/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Frog

let operations: Set<Operation> = [
    .init("addr") { $0[$3] = try $0.get($1) + $0.get($2) },
    .init("addi") { $0[$3] = try $0.get($1) + $2 },
    
    .init("mulr") { $0[$3] = try $0.get($1) * $0.get($2) },
    .init("muli") { $0[$3] = try $0.get($1) * $2 },
    
    .init("banr") { $0[$3] = try $0.get($1) & $0.get($2) },
    .init("bani") { $0[$3] = try $0.get($1) & $2 },
    
    .init("borr") { $0[$3] = try $0.get($1) | $0.get($2) },
    .init("bori") { $0[$3] = try $0.get($1) | $2 },
    
    .init("setr") { $0[$3] = try $0.get($1) },
    .init("seti") { $0[$3] = $1 },
    
    .init("gtir") { $0[$3] = try $1 > $0.get($2) ? 1 : 0 },
    .init("gtri") { $0[$3] = try $0.get($1) > $2 ? 1 : 0 },
    .init("gtrr") { $0[$3] = try $0.get($1) > $0.get($2) ? 1 : 0 },
    
    .init("eqir") { $0[$3] = try $1 == $0.get($2) ? 1 : 0 },
    .init("eqri") { $0[$3] = try $0.get($1) == $2 ? 1 : 0 },
    .init("eqrr") { $0[$3] = try $0.get($1) == $0.get($2) ? 1 : 0 }
]

func readInput() -> ([Sample], [Instruction]) {
    let input = Frog("input.txt")!
    var samples: [Sample] = []
    while let sample = input.readSample() {
        samples.append(sample)
    }
    
    input.skip()
    var instructions: [Instruction] = []
    while let line = input.readLine() {
        instructions.append(Instruction(line.ints))
    }
    return (samples, instructions)
}

func identifyOperations(_ sample: Sample, _ operations: Set<Operation>) -> [Operation] {
    let (before, instruction, after) = (sample.before,
                                        sample.instruction,
                                        sample.after)
    return (try? operations.lazy
        .filter { try before.applied($0, instruction) == after }) ?? []
}

func task1(_ samples: [Sample], _ operations: Set<Operation>) -> Int {
    var count = 0
    for sample in samples {
        count += identifyOperations(sample, operations)
            .count >= 3 ? 1 : 0
    }
    return count
}

func task2(_ samples: [Sample],
           _ operations: Set<Operation>,
           _ instructions: [Instruction]) -> Int {
    var map: [Int: Operation] = [:]
    var operations = operations
    while map.count != 16 {
        for sample in samples where map[sample.instruction.code] == nil {
            let identified = identifyOperations(sample, operations)
            guard identified.count == 1 else { continue }
            map[sample.instruction.code] = identified[0]
            operations.remove(identified[0])
        }
    }
    
    var registers = [0, 0, 0, 0]
    for instruction in instructions {
        let operation = map[instruction.code]!
        try? registers.apply(operation, instruction)
    }
    return registers[0]
}

let (samples, instructions) = readInput()
measure(task1(samples, operations) == 560) // 3 ms
measure(task2(samples, operations, instructions) == 622) // 1 ms
