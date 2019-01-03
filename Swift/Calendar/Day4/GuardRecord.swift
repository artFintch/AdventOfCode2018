//
//  GuardRecord.swift
//  Day4
//
//  Created by Vyacheslav Khorkov on 03/01/2019.
//  Copyright © 2019 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

struct GuardRecord {
    let id: Int?
    let fallsAsleep: Bool
    let date: Date
    
    var minutes: Int {
        return Calendar.current.component(.minute, from: date)
    }
}
