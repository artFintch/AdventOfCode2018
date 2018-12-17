//
//  Matrix+Print.swift
//  Day17
//
//  Created by Vyacheslav Khorkov on 18/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

extension Matrix where Element == Int {
    func print() {
        var output = ""
        for y in 0..<rows {
            var line = ""
            for x in 0..<columns {
                switch self[x, y] {
                case 0:
                    line += " "
                case 1:
                    line += "█"
                case 2:
                    line += "□"
                default: break
                }
            }
            output += line + "\n"
        }
        Swift.print(output)
    }
}
