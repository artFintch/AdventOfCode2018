//
//  Schedule.swift
//  Day4
//
//  Created by Vyacheslav Khorkov on 03/01/2019.
//  Copyright © 2019 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

typealias Schedule = [Int: [Int: Int]]
extension Dictionary where Key == Int, Value == [Int: Int] {
    init(_ records: [GuardRecord]) {
        var begin = -1, id = -1
        var schedule: [Int: [Int: Int]] = [:]
        for record in records {
            if let guardId = record.id {
                id = guardId
            } else if record.fallsAsleep {
                begin = record.minutes
            } else {
                for minute in begin..<record.minutes {
                    schedule[id, default: [:]][minute, default: 0] += 1
                }
            }
        }
        self = schedule
    }
}
