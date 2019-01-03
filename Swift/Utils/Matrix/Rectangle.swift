//
//  Rectangle.swift
//  Day3
//
//  Created by Vyacheslav Khorkov on 02/01/2019.
//  Copyright © 2019 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

struct Rectangle {
    let id: Int
    let position: Point
    let size: Size
    
    init(id: Int, position: Point, size: Size) {
        self.id = id
        self.position = position
        self.size = size
    }
}

extension Rectangle: Sequence {
    func makeIterator() -> RectIterator {
        return RectIterator(self)
    }
}

struct RectIterator: IteratorProtocol, Sequence {
    private let rectangle: Rectangle
    private var position: Point?
    
    init(_ rectangle: Rectangle) {
        self.rectangle = rectangle
    }
    
    mutating func next() -> Point? {
        guard var position = self.position else {
            self.position = rectangle.position
            return self.position
        }
        
        if position.x + 1 < rectangle.position.x + rectangle.size.width {
            position.x += 1
            self.position = position
        } else if position.y + 1 < rectangle.position.y + rectangle.size.height {
            position.x = rectangle.position.x
            position.y += 1
            self.position = position
        } else {
            self.position = nil
        }
        
        return self.position
    }
}
