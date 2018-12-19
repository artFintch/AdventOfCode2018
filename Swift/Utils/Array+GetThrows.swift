//
//  Array+GetThrows.swift
//  Day16
//
//  Created by Vyacheslav Khorkov on 17/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

enum ArrayError: Error {
    case subscriptOutOfRange
}

extension Array {
    func get(_ index: Int) throws -> Element {
        guard indices ~= index else { throw ArrayError.subscriptOutOfRange }
        return self[index]
    }
}
