//
//  main.swift
//  Day13
//
//  Created by Vyacheslav Khorkov on 13/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Frog

struct Point: Equatable {
    var x: Int, y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    static func == (lhs: Point, rhs: Point) -> Bool {
        return (lhs.x, lhs.y) == (rhs.x, rhs.y)
    }
}

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

class Cart {
    private static var _id = 0
    private static func genId() -> Int { _id += 1; return _id }
    private static let shift = [Point(0, 1), Point(-1, 0), Point(0, -1), Point(1, 0)]
    private static let directions: [Direction] = [.bottom, .left, .top, .right]
    
    var id: Int
    private(set) var state = 0
    var position: Point, direction: Direction
    
    init(_ x: Int, _ y: Int, _ direction: Direction) {
        self.position = Point(x, y)
        self.direction = direction
        self.id = Cart.genId()
    }
    
    func turn() {
        let shift = Int(log2(Float(direction.rawValue)))
        let newState = (state + shift) % Cart.directions.count
        position.x += Cart.shift[newState].x
        position.y += Cart.shift[newState].y
        direction = Cart.directions[newState]
        state = (state + 1) % 3
    }
    
    func turn(_ directions: Direction) {
        direction.swap()
        direction = directions.subtracting(direction)
        move()
    }
    
    func move() {
        let shift = Int(log2(Float(direction.rawValue)))
        let newState = (shift + 1) % Cart.directions.count
        let step = Cart.shift[newState]
        position.x += step.x
        position.y += step.y
    }
}

extension Cart: Comparable {

    static func < (lhs: Cart, rhs: Cart) -> Bool {
        return (lhs.position.y, lhs.position.x) < (rhs.position.y, rhs.position.x)
    }

    static func == (lhs: Cart, rhs: Cart) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func compare(_ lhs: Any, _ rhs: Any) -> ComparisonResult {
        if (lhs as! Cart) < (rhs as! Cart) {
            return .orderedAscending
        } else if (lhs as! Cart) == (rhs as! Cart) {
            return .orderedSame
        } else {
            return .orderedDescending
        }
    }
}

func readInput() -> (matrix: [[Direction]], carts: [Cart]) {
    let lines = Array(Frog("input.txt")!.readLines().map { Array($0) })
    let w = lines.map { $0.count }.max()!
    let h = lines.count
    var matrix = Array(repeating: Array(repeating: Direction.none, count: w), count: h)
    var carts: [Cart] = []
    
    let horizontal: [Character] = ["-", "+", ">", "<"]
    for y in 0..<lines.count {
        for x in 0..<lines[y].count {
            switch lines[y][x] {
            case "/" where x + 1 < lines[y].count
                && horizontal.contains(lines[y][x + 1]):
                matrix[y][x] = [.right, .bottom]
            
            case "/":
                matrix[y][x] = [.left, .top]
                
            case "\\" where x + 1 < lines[y].count
                && horizontal.contains(lines[y][x + 1]):
                matrix[y][x] = [.right, .top]
                
            case "\\":
                matrix[y][x] = [.left, .bottom]
                
            case "-":
                matrix[y][x] = .horizontal
            case "|":
                matrix[y][x] = .vertical
            case "+":
                matrix[y][x] = .all
            case ">":
                matrix[y][x] = .horizontal
                carts.append(Cart(x, y, .right))
            case "<":
                matrix[y][x] = .horizontal
                carts.append(Cart(x, y, .left))
            case "^":
                matrix[y][x] = .vertical
                carts.append(Cart(x, y, .top))
            case "v":
                matrix[y][x] = .vertical
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

extension Array where Element == [Direction] {
    
    subscript(_ p: Point) -> Direction {
        get { return self[p.y][p.x] }
        set { self[p.y][p.x] = newValue }
    }
}


func run(_ stopFirst: Bool) -> Point {
    let input = readInput()
    let matrix = input.matrix
    let carts = NSMutableOrderedSet(array: input.carts)
    for _ in 0..<100_000 {
        carts.sort(comparator: Cart.compare)
        
        for case let cart as Cart in carts {
            if matrix[cart.position] == .all {
                cart.turn()
            } else if matrix[cart.position].contains(cart.direction) {
                cart.move()
            } else {
                cart.turn(matrix[cart.position])
            }
            
            for case let another as Cart in carts where another != cart {
                guard another.position == cart.position else { continue }
                if stopFirst { return cart.position }
                carts.remove(cart)
                carts.remove(another)
            }
        }
        
        if carts.count == 1, let cart = carts[0] as? Cart {
            return cart.position
        }
    }
    
    return Point(-1, -1)
}

measure(run(true) == Point(83, 49))  // 22 ms
measure(run(false) == Point(73, 36)) // 95 ms
