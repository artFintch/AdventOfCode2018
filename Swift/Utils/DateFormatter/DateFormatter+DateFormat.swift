//
//  DateFormatter+DateFormat.swift
//  Day4
//
//  Created by Vyacheslav Khorkov on 03/01/2019.
//  Copyright © 2019 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

extension DateFormatter {
    convenience init(_ dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }
}
