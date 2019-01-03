//
//  String+CompareByChatacters.swift
//  Day2
//
//  Created by Vyacheslav Khorkov on 01/01/2019.
//  Copyright © 2019 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

extension String {
    func compare(byChatacters string: String, threshold: Int) -> Bool {
        var diff = 0
        for (lhs, rhs) in zip(self, string) where lhs != rhs {
            diff += 1
            guard diff <= threshold else { return false }
        }
        return true
    }
}
