//
//  main.swift
//  Day8
//
//  Created by Vyacheslav Khorkov on 08/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Frog

// Input
let numbers = Frog("input.txt")!.readNumbers()

// Utils
struct Node {
    let childs: [Node]
    let meta: [Int]
}

// Parsing Tree
func buildTree() -> Node {
    var iterator = numbers.makeIterator()
    
    func readNode() -> Node {
        let nc = iterator.next()!, mc = iterator.next()!
        return .init(childs: (0..<nc).map { _ in readNode() },
                     meta: (0..<mc).map { _ in iterator.next()! })
    }
    return readNode()
}

let tree = buildTree()

// Part1
func metaSum(_ n: Node) -> Int {
    return (n.meta + n.childs.map(metaSum)).reduce(0, +)
}
print(metaSum(tree))

// Part2
func metaSum2(_ n: Node) -> Int {
    if n.childs.isEmpty { return metaSum(n) }
    return n.meta.lazy
        .filter { $0 - 1 < n.childs.count }
        .map { metaSum2(n.childs[$0 - 1]) }
        .reduce(0, +)
}
print(metaSum2(tree))
