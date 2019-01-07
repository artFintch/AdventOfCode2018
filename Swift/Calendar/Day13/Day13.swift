//
//  main.swift
//  Day13
//
//  Created by Vyacheslav Khorkov on 13/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Frog
import AdventCode

struct Direction: OptionSet {
    let rawValue: Int
    static let none: Direction = []
    static let left = Direction(rawValue: 1)
    static let top = Direction(rawValue: 2)
    static let right = Direction(rawValue: 4)
    static let bottom = Direction(rawValue: 8)
    static let vertical: Direction = [.top, .bottom]
    static let horizontal: Direction = [.left, .right]
    static let all: Direction = [.vertical, .horizontal]
    
    mutating func swap() {
        if Direction.vertical.contains(self) {
            self = Direction.vertical.subtracting(self)
        } else {
            self = Direction.horizontal.subtracting(self)
        }
    }
}

struct Cart {
    private static var _id = 0
    private static func genId() -> Int { _id += 1; return _id }
    private static let shift = [Point(0, 1), Point(-1, 0), Point(0, -1), Point(1, 0)]
    private static let directions: [Direction] = [.bottom, .left, .top, .right]
    
    var active = true
    var id: Int
    private(set) var state = 0
    var position: Point, direction: Direction
    
    init(_ x: Int, _ y: Int, _ direction: Direction) {
        self.position = Point(x, y)
        self.direction = direction
        self.id = Cart.genId()
    }
    
    mutating func turn() {
        let shift = Int(log2(Float(direction.rawValue)))
        let newState = (state + shift) % Cart.directions.count
        position.x += Cart.shift[newState].x
        position.y += Cart.shift[newState].y
        direction = Cart.directions[newState]
        state = (state + 1) % 3
    }
    
    mutating func turn(_ directions: Direction) {
        direction.swap()
        direction = directions.subtracting(direction)
        move()
    }
    
    mutating func move() {
        let shift = Int(log2(Float(direction.rawValue)))
        let newState = (shift + 1) % Cart.directions.count
        let step = Cart.shift[newState]
        position.x += step.x
        position.y += step.y
    }
}

extension Cart: Hashable {
    func hash(into hasher: inout Hasher) {}
}

extension Cart: Comparable {
    static func < (lhs: Cart, rhs: Cart) -> Bool {
        return (lhs.position.y, lhs.position.x) < (rhs.position.y, rhs.position.x)
    }
}

struct Day13: Solution {
    
    func readInput(from path: String) -> (matrix: Matrix<Direction>, carts: [Cart]) {
        let lines = Array(Frog(path).readLines().map { Array($0) })
        let w = lines.map { $0.count }.max()!
        let h = lines.count
        var matrix = Matrix<Direction>(w, h, .none)
        var carts: [Cart] = []

        let horizontal: [Character] = ["-", "+", ">", "<"]
        for y in 0..<lines.count {
            for x in 0..<lines[y].count {
                switch lines[y][x] {
                case "/" where x + 1 < lines[y].count
                    && horizontal.contains(lines[y][x + 1]):
                    matrix[x, y] = [.right, .bottom]

                case "/":
                    matrix[x, y] = [.left, .top]

                case "\\" where x + 1 < lines[y].count
                    && horizontal.contains(lines[y][x + 1]):
                    matrix[x, y] = [.right, .top]

                case "\\":
                    matrix[x, y] = [.left, .bottom]

                case "-":
                    matrix[x, y] = .horizontal
                case "|":
                    matrix[x, y] = .vertical
                case "+":
                    matrix[x, y] = .all
                case ">":
                    matrix[x, y] = .horizontal
                    carts.append(Cart(x, y, .right))
                case "<":
                    matrix[x, y] = .horizontal
                    carts.append(Cart(x, y, .left))
                case "^":
                    matrix[x, y] = .vertical
                    carts.append(Cart(x, y, .top))
                case "v":
                    matrix[x, y] = .vertical
                    carts.append(Cart(x, y, .bottom))
                case " ":
                    break
                default:
                    fatalError()
                }
            }
        }

        return (matrix, carts)
    }
    
    func silver(_ input: (matrix: Matrix<Direction>, carts: [Cart])) -> Point {
        return run(input.matrix, input.carts, true)
    }
    
    func gold(_ input: (matrix: Matrix<Direction>, carts: [Cart])) -> Point {
        return run(input.matrix, input.carts, false)
    }
    
    private func run(_ matrix: Matrix<Direction>,
                     _ carts: [Cart],
                     _ stopFirst: Bool) -> Point {
        var carts = carts
        for _ in 0..<100_000 {
            carts.sort()
            
            for (index, cart) in carts.enumerated() where cart.active {
                if matrix[cart.position] == .all {
                    carts[index].turn()
                } else if matrix[cart.position].contains(cart.direction) {
                    carts[index].move()
                } else {
                    carts[index].turn(matrix[cart.position])
                }
                
                for (anotherIndex, another) in carts.enumerated() where another.active && another != cart {
                    guard another.position == cart.position else { continue }
                    if stopFirst { return cart.position }
                    carts[index].active = false
                    carts[anotherIndex].active = false
                }
            }
            
            let filtered = carts.filter({ $0.active })
            if filtered.count == 1 {
                return filtered[0].position
            }
        }
        
        return Point(-1, -1)
    }
}
