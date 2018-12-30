//
//  main.swift
//  Day7
//
//  Created by Vyacheslav Khorkov on 07/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Frog

func readInput() -> ([Character: Set<Character>], [Character: Int], Set<Character>) {
    let lines = Frog("input.txt")!.readLines().map { Array($0) }.map { ($0[5], $0[36]) }
    
    var graph: [Character: Set<Character>] = [:]
    lines.forEach { (from, to) in graph[from, default: []].insert(to) }
    
    var rgraph: [Character: Int] = [:]
    lines.forEach { (_, to) in rgraph[to, default: 0] += 1 }
    
    let rootNodes = Set(graph.keys).subtracting(Set(rgraph.keys))
    
    return (graph, rgraph, rootNodes)
}

func bfs<Element>(_ begin: Set<Element>,
                  isEnd: ([Element]) -> Bool,
                  next: (inout [Element]) -> Element,
                  visit: (Element) -> [Element]) {
    var queue = Array(begin)
    var seen = begin
    while isEnd(queue) {
        let element = next(&queue)
        for v in visit(element) {
            if seen.insert(v).inserted {
                queue.append(v)
            }
        }
    }
}

func searchWord() -> String {
    var (graph, rgraph, rootNodes) = readInput()
    var word = ""
    
    bfs(rootNodes, isEnd: { !$0.isEmpty }, next: { queue in
        queue.sort()
        let index = queue.firstIndex { (rgraph[$0] ?? 0) <= 0 }
        return queue.remove(at: index!)
    }, visit: { element in
        word.append(element)
        graph[element, default: []].forEach { rgraph[$0, default: 0] -= 1 }
        return Array(graph.removeValue(forKey: element) ?? [])
    })
    
    return word
}

func searchInParallel(_ workersCount: Int, _ baseTime: Int) -> Int {
    var (graph, rgraph, rootNodes) = readInput()
    var totalTime = 0
    var workers: [(element: Character, time: Int)] = []
    let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let timeScale = (baseTime + 1)..<(baseTime + 1 + 26)
    let time = Dictionary(uniqueKeysWithValues: zip(alphabet, timeScale))
    
    bfs(rootNodes, isEnd: { !$0.isEmpty || !workers.isEmpty }, next: { queue in
        queue.sort()
        
        for element in queue where (rgraph[element] ?? 0) <= 0 {
            if workers.count < workersCount {
                workers.append((element, time[element]!))
            }
        }
        
        workers.forEach { worker in queue.removeAll { $0 == worker.element } }
        
        workers.sort { $0.1 < $1.1 }
        totalTime += workers[0].time
        workers = workers.map { ($0.element, $0.time - workers[0].time) }
        return workers.removeFirst().element
    }, visit: { element in
        graph[element, default: []].forEach { rgraph[$0, default: 0] -= 1 }
        return Array(graph.removeValue(forKey: element) ?? [])
    })
    
    return totalTime
}

measure(searchWord() == "OVXCKZBDEHINPFSTJLUYRWGAMQ") // 0.004s
measure(searchInParallel(5, 60) == 955) // 0.002s
