//
//  main.swift
//  Day9
//
//  Created by Vyacheslav Khorkov on 09/12/2018.
//

import Frog
import AdventCode

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

struct Day9: Solution {
    func readInput(from path: String) -> (players: Int, steps: Int) {
        let numbers = Frog(path).readNumbers()
        return (numbers[0], numbers[1])
    }
    
    func silver(_ input: (players: Int, steps: Int)) -> Int {
        return marble(input.players, input.steps)
    }
    
    func gold(_ input: (players: Int, steps: Int)) -> Int {
        return marble(input.players, 100 * input.steps)
    }
    
    private func marble(_ players: Int, _ steps: Int) -> Int {
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
}
