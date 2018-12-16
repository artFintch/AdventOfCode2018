//
//  Measure.swift
//  Swift
//
//  Created by Vyacheslav Khorkov on 09/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

func measure<T>(_ block: @autoclosure () -> T) {
    let start = Date()
    let result = block()
    let duration = Date().timeIntervalSince1970 - start.timeIntervalSince1970
    print(result, Int(ceil(duration * 1000.0)), "ms")
}
