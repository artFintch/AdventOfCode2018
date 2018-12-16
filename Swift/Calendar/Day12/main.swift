//
//  main.swift
//  Day12
//
//  Created by Vyacheslav Khorkov on 12/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

func readInput() -> (NSMutableArray, [Int]) {
    let lines = Frog("input.txt")!.readLines().lazy
        .filter { !$0.isEmpty }
        .map { $0.replacingOccurrences(of: "#", with: "1") }
        .map { $0.replacingOccurrences(of: ".", with: "0") }
    
    let initLine = lines[0].components(separatedBy: " ").last!
    let initial = NSMutableArray(array: initLine.map(String.init).compactMap(Int.init))
    
    var map = [Int](repeating: -1, count: 32)
    lines.dropFirst().lazy
        .map { $0.components(separatedBy: " => ") }
        .map { (Int(strtoul($0[0], nil, 2)), Int($0[1])!) }
        .forEach { map[$0.0] = $0.1 }
    
    return (initial, map)
}

extension NSMutableArray {
    
    var string: String {
        return reduce("") { $0 + String($1 as! Int) }
    }
    
    var numbers: [Int] {
        return map { $0 as! Int }
    }
    
    func int(_ index: Int) -> Int {
        return self[index] as! Int
    }
    
    func trimFront(_ value: Int) -> Int {
        var count = 0
        while int(0) == value {
            removeObject(at: 0)
            count += 1
        }
        return count
    }
    
    @discardableResult func keepPrefix(from: Int = 1, _ to: Int, _ length: Int) -> Int {
        let index = self.index(of: from)
        if index < length {
            for _ in 0..<(length - index) {
                insert(to, at: 0)
            }
        } else {
            for _ in 0..<(index - length) {
                removeObject(at: 0)
            }
        }
        return length - index
    }
    
    func keepSuffix(from: Int = 1, _ to: Int, _ length: Int) {
        let start = count - 1
        var index = start
        let enumerator = reverseObjectEnumerator()
        while let next = enumerator.nextObject() as? Int, next != from {
            index -= 1
        }
        
        if (start - index) < length {
            for _ in 0..<(length - (start - index)) {
                add(to)
            }
        } else {
            for _ in 0..<((start - index) - length) {
                removeLastObject()
            }
        }
    }
}

func run(_ maxGen: Int) -> Int {
    let (line, map) = readInput()
    var patterns = Set<String>()
    var (gen, zero) = (0, 0)
    while gen < maxGen {
        zero += line.keepPrefix(0, 4)
        line.keepSuffix(0, 4)
        
        var block = line.int(4)
        for pos in 5..<line.count {
            line[pos - 3] = map[block]
            block <<= 1
            block += line.int(pos) - (block >> 5) * 32
        }
        
        gen += 1
        
        let key = line.string.trimmingCharacters(in: ["0"])
        if !patterns.insert(key).inserted { break }
    }
    
    zero -= line.trimFront(0) + maxGen - gen
    return line.numbers.lazy.enumerated()
        .reduce(0) { $0 + $1.element * ($1.offset - zero) }
}

measure(run(20) == 2911) // 3ms
measure(run(50000000000) == 2500000000695) // 10ms
