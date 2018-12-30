//
//  Frog+ReadNumbers.swift
//  Swift
//
//  Created by Vyacheslav Khorkov on 08/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Frog

public extension Frog {
    
    func readNumbers(_ separator: String = " ") -> [Int] {
        guard let line = readLine() else { return [] }
        return line
            .components(separatedBy: separator)
            .compactMap(Int.init)
    }
}
