//
//  IO.swift
//  Day15
//
//  Created by Vyacheslav Khorkov on 15/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Frog

func readField() -> ([Unit], Set<Unit>, Set<Unit>, Matrix<Unit>) {
    let lines = Frog("input.txt")!.readLines().map { Array($0) }
    var field = Matrix(lines[0].count, lines.count, Unit(.wall))
    var elfs: [Unit] = []
    var goblins: [Unit] = []
    for y in lines.indices {
        for x in lines[0].indices {
            let position = Point(x, y)
            switch lines[y][x] {
            case "#":
                field[x, y] = Unit(.wall, position)
            case ".":
                field[x, y] = Unit(.empty, position)
            case "G":
                field[x, y] = Unit(.goblin, position)
                goblins.append(field[x, y])
            case "E":
                field[x, y] = Unit(.elf, position)
                elfs.append(field[x, y])
            default:
                fatalError()
            }
        }
    }
    
    return (elfs + goblins, Set(elfs), Set(goblins), field)
}

func printField(_ matrix: [[Unit]]) {
    var field = ""
    for row in matrix {
        var line = "", healthes = ""
        for cell in row {
            switch cell.kind {
            case .wall:
                line += "#"
            case .empty:
                line += "."
            case .goblin:
                line += "G"
                healthes += "(\(cell.health)) "
            case .elf:
                line += "E"
                healthes += "(\(cell.health)) "
            }
        }
        field += line + " " + healthes + "\n"
    }
    print(field)
}
