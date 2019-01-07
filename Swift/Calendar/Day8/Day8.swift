//
//  main.swift
//  Day8
//
//  Created by Vyacheslav Khorkov on 08/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Frog
import AdventCode

struct Day8: Solution {
    struct Node {
        let childs: [Node]
        let meta: [Int]
    }
    
    func readInput(from path: String) -> Node {
        let input = Frog(path).readNumbers()
        var iterator = input.makeIterator()
        
        func readNode() -> Node {
            let nc = iterator.next()!, mc = iterator.next()!
            return .init(childs: (0..<nc).map { _ in readNode() },
                         meta: (0..<mc).map { _ in iterator.next()! })
        }
        
        return readNode()
    }
    
    func silver(_ tree: Node) -> Int {
        return (tree.meta + tree.childs.map(silver)).reduce(0, +)
    }
    
    func gold(_ tree: Node) -> Int {
        if tree.childs.isEmpty { return silver(tree) }
        return tree.meta.lazy
            .filter { $0 - 1 < tree.childs.count }
            .map { self.gold(tree.childs[$0 - 1]) }
            .reduce(0, +)
    }
}
