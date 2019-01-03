//
//  Frog+ReadGuardRecords.swift
//  Day4
//
//  Created by Vyacheslav Khorkov on 03/01/2019.
//  Copyright © 2019 Vyacheslav Khorkov. All rights reserved.
//

import Frog

extension Frog {
    func readGuardRecords() -> [GuardRecord] {
        var records: [GuardRecord] = []
        let parser = DateFormatter("yyyy-MM-dd HH:mm")
        for line in readLines() {
            let parts = line
                .components(separatedBy: ["[", "]", " ", "#"])
                .filter { !$0.isEmpty }
            
            let id = Int(parts[3])
            let fallsAsleep = parts[2].hasPrefix("falls")
            let date = parser.date(from: "\(parts[0]) \(parts[1])")!
            let record = GuardRecord(id: id, fallsAsleep: fallsAsleep, date: date)
            records.append(record)
        }
        records.sort { lhs, rhs in lhs.date < rhs.date }
        return records
    }
}
