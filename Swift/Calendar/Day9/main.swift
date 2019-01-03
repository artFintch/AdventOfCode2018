//
//  main.swift
//  Day9
//
//  Created by Vyacheslav Khorkov on 09/12/2018.
//

import Frog

// Utils
extension NSMutableArray {
    func rotate(_ value: Int) {
        for _ in 0..<Swift.abs(value) {
            if value > 0 {
                insert(self[count - 1], at: 0)
                removeLastObject()
            } else {
                add(self[0])
                removeObject(at: 0)
            }
        }
    }
}

// Input
let line = Frog("input.txt")!.readLine()!
let numbers = line.components(separatedBy: " ").compactMap(Int.init)


func marbleList(_ players: Int, _ steps: Int) -> Int {
    var score = [Int](repeating: 0, count: players)
    let list = List(0)
    let position = list.end
    for i in 1..<steps {
        if i % 23 == 0 {
            position.shift(-9)
            score[i % players] += list.remove(position) + i
        } else {
            list.insert(i, position)
        }
        position.shift(2)
    }
    return score.max()!
}

func marble(_ players: Int, _ steps: Int) -> Int {
    var score = [Int](repeating: 0, count: players)
    let list = NSMutableArray(arrayLiteral: 0)
    for i in 1..<steps {
        if i % 23 == 0 {
            list.rotate(-9)
            score[i % players] += i + (list.lastObject as! Int)
            list.removeLastObject()
        } else {
            list.add(i)
        }
        list.rotate(2)
    }
    return score.max()!
}

measure(marble(numbers[0], numbers[1])) // 0.01s
measure(marbleList(numbers[0], 100 * numbers[1])) // 3.93s
measure(marble(numbers[0], 100 * numbers[1])) // 1.05s
