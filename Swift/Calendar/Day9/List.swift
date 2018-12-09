//
//  List.swift
//  Day9
//
//  Created by Vyacheslav Khorkov on 09/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

final class List<T> {
    
    final class Node<T> {
        let value: T
        var next: Node?
        weak var previous: Node?
        
        init(_ value: T) {
            self.value = value
        }
    }
    
    final class Iterator<T> {
        private(set) var node: Node<T>
        
        init(node: Node<T>) { self.node = node }
        
        func shift(_ v: Int) {
            var c = node
            (0..<abs(v)).forEach { _ in
                c = v > 0 ? c.next! : c.previous!
            }
            node = c
        }
    }
    
    private(set) var head: Node<T>
    private(set) var count = 0
    var end: Iterator<T> { return Iterator(node: head.previous!) }
    
    init(_ v: T) {
        head = Node(v)
        head.previous = head
        count = 1
    }
    
    func insert(_ v: T, _ after: Iterator<T>) {
        let n = Node(v)
        n.next = after.node.next ?? head
        n.next?.previous = n
        n.previous = after.node
        after.node.next = n
        count += 1
    }
    
    func remove(_ after: Iterator<T>) -> T {
        let next = after.node.next
        after.node.next = next?.next
        next?.next?.previous = after.node
        next?.next = nil
        count -= 1
        return next!.value
    }
}
