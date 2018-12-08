//
//  main.swift
//  Day8
//
//  Created by Vyacheslav Khorkov on 08/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

// Input
let numbers = Frog("input.txt")!.readNumbers()

// Utils
struct Node {
    var childs = [Node]()
    var meta = [Int]()
}

// Parsing Tree
func buildTree(_ p: inout Int) -> Node {
    let nc = numbers[p], mc = numbers[p + 1]
    p += 2
    
    var n = Node()
    n.childs += (0..<nc).map { _ in buildTree(&p) }
    n.meta += numbers[p..<(p + mc)]
    p += mc
    
    return n
}
func buildTree() -> Node { var p = 0; return buildTree(&p) }


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
