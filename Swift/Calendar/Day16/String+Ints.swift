//
//  String+Ints.swift
//  Day16
//
//  Created by Vyacheslav Khorkov on 17/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

extension String {
    var ints: [Int] {
        return components(separatedBy: [" ", ",", "[", "]"]).compactMap(Int.init)
    }
}
