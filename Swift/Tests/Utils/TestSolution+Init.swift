//
//  TestSolution+Init.swift
//  Tests
//
//  Created by Vyacheslav Khorkov on 07/01/2019.
//  Copyright © 2019 Vyacheslav Khorkov. All rights reserved.
//

import AdventCode

extension TestSolution {
    init(silverAnswer: Type.SilverOutput,
         goldAnswer: Type.GoldOutput) {
        let resource = String(describing: Type.self).lowercased()
        self.init(inputPath: Bundle.current.txtPath(forResource: resource)!,
                  silverAnswer: silverAnswer,
                  goldAnswer: goldAnswer)
    }
}
