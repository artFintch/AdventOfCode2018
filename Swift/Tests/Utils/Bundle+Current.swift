//
//  Bundle+Current.swift
//  Tests
//
//  Created by Vyacheslav Khorkov on 07/01/2019.
//  Copyright © 2019 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

private class Dummy {}

extension Bundle {
    static let current = Bundle(for: Dummy.self)
}
