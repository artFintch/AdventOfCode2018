//
//  main.swift
//  Day20
//
//  Created by Vyacheslav Khorkov on 20/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Frog

extension Matrix where Element == Int {
    mutating func move(_ position: Point, _ character: Character) -> Point {
        let shift: Point
        switch character {
        case "N": shift = Point(0, -1)
        case "S": shift = Point(0, 1)
        case "W": shift = Point(-1, 0)
        case "E": shift = Point(1, 0)
        default: fatalError()
        }
        self[position + shift] = 1
        self[position + shift + shift] = 2
        return position + shift + shift
    }
}

func dfs(_ begin: Point, _ matrix: Matrix<Int>) -> [Point: Int] {
    let shifts = [Point(0, -1), Point(0, 1), Point(-1, 0), Point(1, 0)]
    var matrix = matrix
    var map: [Point: Int] = [:]
    dfs(begin, shifts, &matrix, 0, &map)
    return map
}

func dfs(_ begin: Point,
         _ shifts: [Point],
         _ matrix: inout Matrix<Int>,
         _ steps: Int,
         _ map: inout [Point: Int]) {
    for shift in shifts {
        let next = begin + shift
        if matrix.contains(next) && matrix[next] == 1 {
            matrix[next] = 0
            dfs(next + shift, shifts, &matrix, steps + 1, &map)
        }
    }
    map[begin] = Swift.max(map[begin] ?? 0, steps)
}

protocol Nodable {}
class Leaf: Nodable {
    let value: String
    init(value: String) {
        self.value = value
    }
}
class Node: Nodable {
    let childs: [Nodable]
    init(childs: [Nodable]) {
        self.childs = childs
    }
}
class AndNode: Node {}
class OrNode: Node {}

func buildTree(_ line: String) -> Nodable {
    var iterator = line.makeIterator()
    
    func readNode() -> Nodable {
        var line = ""
        var orChilds: [Nodable] = []
        var andChilds: [Nodable] = []
        var prev: Character!
        while let next = iterator.next() {
            switch next {
            case "(":
                andChilds.append(Leaf(value: line))
                andChilds.append(readNode())
                line = ""
                
            case "|":
                if andChilds.isEmpty {
                    orChilds.append(Leaf(value: line))
                } else {
                    andChilds.append(Leaf(value: line))
                    orChilds.append(AndNode(childs: andChilds))
                    andChilds = []
                }
                line = ""
                
            case ")":
                if !line.isEmpty || prev == "|" {
                    andChilds.append(Leaf(value: line))
                }
                if !andChilds.isEmpty {
                    if andChilds.count == 1 {
                        orChilds.append(andChilds[0])
                    } else {
                        orChilds.append(AndNode(childs: andChilds))
                    }
                }
                return OrNode(childs: orChilds)
                
            default:
                line.append(next)
            }
            prev = next
        }
        
        if !line.isEmpty {
            andChilds.append(Leaf(value: line))
        }
        
        if andChilds.count == 1 {
            return andChilds[0]
        } else {
            return AndNode(childs: andChilds)
        }
    }
    return readNode()
}

@discardableResult
func fillMatrix(_ root: Nodable, _ position: Point, _ matrix: inout Matrix<Int>) -> Point {
    var position = position
    switch root {
    case let leaf as Leaf:
        leaf.value.forEach { position = matrix.move(position, $0) }
    case let andNode as AndNode:
        andNode.childs.forEach { position = fillMatrix($0, position, &matrix) }
    case let orNode as OrNode:
        orNode.childs.forEach { fillMatrix($0, position, &matrix) }
    default: break
    }
    return position
}

func buildMatrix(_ root: Nodable) -> Matrix<Int> {
    var matrix = Matrix(250, 250, 0)
    let begin = Point(matrix.columns / 2, matrix.rows / 2)
    matrix[begin] = 3
    fillMatrix(root, begin, &matrix)
    return matrix
}

func silver(_ input: String, _ begin: Point, _ matrix: Matrix<Int>) -> Int {
    let root = buildTree(input)
    var matrix = matrix
    fillMatrix(root, begin, &matrix)
    let map = dfs(begin, matrix)
    return map.max { $0.value < $1.value }!.value
}

func gold(_ input: String, _ begin: Point, _ matrix: Matrix<Int>) -> Int {
    let root = buildTree(input)
    var matrix = matrix
    fillMatrix(root, begin, &matrix)
    let map = dfs(begin, matrix)
    return map.filter { $0.value >= 1000 }.count
}

let input = String(Frog("input.txt")!.readLine()!.dropFirst().dropLast())
let matrix = Matrix(250, 250, 0)
let begin = Point(matrix.columns / 2, matrix.rows / 2)

measure(silver(input, begin, matrix) == 3755) // 9ms
measure(gold(input, begin, matrix) == 8627)   // 11ms
