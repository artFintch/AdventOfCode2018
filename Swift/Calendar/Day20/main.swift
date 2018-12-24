//
//  main.swift
//  Day20
//
//  Created by Vyacheslav Khorkov on 20/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

// ^ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN$
// ^ENWWW(NEEE|SSE(EE|N))$
func readInput() -> String {
    return String(Frog("input.txt")!.readLine()!.dropFirst().dropLast())
}

struct Node {
    let childs: [Node]
    let value: String
}

// ^ENWWW(NEEE|SSE(EE|N))$
// ENWWW
// - NEEE
// - SSE
//   - EE
//   - N


func buildTree(_ line: String) -> [Node] {
    var iterator = line.makeIterator()
    
    func readNodes() -> [Node] {
        var line = ""
        var nodes: [Node] = []
        var prev: Character!
        while let next = iterator.next() {
            switch next {
            case "(":
                nodes.append(Node(childs: readNodes(), value: line))
                line = ""
                
            case "|":
                nodes.append(Node(childs: [], value: line))
                line = ""
                
            case ")":
                if !line.isEmpty || prev == "|" {
                    nodes.append(Node(childs: [], value: line))
                }
                return nodes
                
            default:
                line.append(next)
            }
            prev = next
        }
        
        if !line.isEmpty {
            nodes.append(Node(childs: [], value: line))
        }
        
        return nodes
    }
    return readNodes()
}

extension Matrix where Element == Int {
    
    mutating func move(_ position: Point, _ character: Character) -> Point {
        switch character {
        case "N":
            self[position + Point(0, -1)] = 1
            self[position + Point(0, -2)] = 2
            return position + Point(0, -2)
        case "S":
            self[position + Point(0, 1)] = 1
            self[position + Point(0, 2)] = 2
            return position + Point(0, 2)
        case "W":
            self[position + Point(-1, 0)] = 1
            self[position + Point(-2, 0)] = 2
            return position + Point(-2, 0)
        case "E":
            self[position + Point(1, 0)] = 1
            self[position + Point(2, 0)] = 2
            return position + Point(2, 0)
        default:
            fatalError()
        }
    }
}

func traverse(_ node: Node,
              pos: Point,
              _ matrix: inout Matrix<Int>,
              _ leaves: inout Set<Point>) {
    var pos = pos
    for character in node.value {
        pos = matrix.move(pos, character)
    }
    
    if node.childs.isEmpty {
        leaves.insert(pos)
        return
    }
    
    for child in node.childs {
        traverse(child, pos: pos, &matrix, &leaves)
    }
}

extension Matrix where Element == Int {
    func print() {
        var text = ""
        for y in 0..<rows {
            for x in 0..<columns {
                switch self[x, y] {
                case 0:
                    text += "#"
                case 1:
                    text += "+"
                case 2:
                    text += "."
                case 3:
                    text += "X"
                default:
                    fatalError()
                }
            }
            text += "\n"
        }
        Swift.print(text)
    }
}

func traverse2(_ pos: Point,
               _ matrix: inout Matrix<Int>,
               _ steps: Int,
               _ max: inout Int) {
    let top = pos + Point(0, -1)
    if matrix.contains(top) && matrix[top] == 1 {
        matrix[top] = 0
        traverse2(top + Point(0, -1), &matrix, steps + 1, &max)
    }
    
    let bottom = pos + Point(0, 1)
    if matrix.contains(bottom) && matrix[bottom] == 1 {
        matrix[bottom] = 0
        traverse2(bottom + Point(0, 1), &matrix, steps + 1, &max)
    }
    
    let left = pos + Point(-1, 0)
    if matrix.contains(left) && matrix[left] == 1 {
        matrix[left] = 0
        traverse2(left + Point(-1, 0), &matrix, steps + 1, &max)
    }
    
    let right = pos + Point(1, 0)
    if matrix.contains(right) && matrix[right] == 1 {
        matrix[right] = 0
        traverse2(right + Point(1, 0), &matrix, steps + 1, &max)
    }
    
    max = Swift.max(max, steps)
}

func buildMatrix(_ nodes: [Node]) {
    var matrix = Matrix(20, 20, 0)
    let begin = Point(matrix.columns / 2, matrix.rows / 2)
    matrix[begin] = 3
    var leaves: Set<Point> = [begin]
    
    matrix.print()
    for node in nodes {
        var leaves2: Set<Point> = []
        for leaf in leaves {
            traverse(node, pos: leaf, &matrix, &leaves2)
        }
        leaves = leaves2
        matrix.print()
    }
    
    var max = 0
    traverse2(begin, &matrix, 0, &max)
    print(max)
}

let line = readInput()
let nodes = buildTree(line)
//buildMatrix(nodes)

// ^ESSWWN(E|NNENN(EESS(WNSE|)SSS|WWWSSSSE(SW|NNNE)))$
// ESSWWN
// > E
// > NNENN
//   > EESS
//     > WNSE
//     >
//   > SSS
//   > WWWSSSSE
//     > SW
//     > NNNE
func traverse3(_ node: Node, _ d: String = ">") {
    print(d, node.value)
    for childNode in node.childs {
        traverse3(childNode, d + ">")
    }
}
for node in nodes {
    traverse3(node)
}

//
//// ^ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN$
//var cur = ""
//for node in nodes {
//    cur += node.value + "."
//    for child in node.childs {
//        traverse(child, {
//            cur += "." + $0.value
//            //print("b", $0.value)
//            print(cur)
//        }, {
//            cur.removeLast($0.value.count + 1)
////            print(cur)
////            print("a", $0.value)
//        })
//    }
//}
