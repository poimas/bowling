#!/usr/bin/swift

import Foundation
import Darwin

let strike: Character = "X"
let spare: Character = "/"
let miss = "-"
let strikeBonus = 3
let spareBonus = 2
let rollPerFrame = 2
let turns = 10

func totalScore(of rollSequence: String) -> Int {
    var rolls = rollSequence.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: miss, with: "0")
    var score = 0
    var index = 0
    while index < turns {
        if rolls.first == strike {
            score += frameScore(for: String(rolls.prefix(strikeBonus)))
            rolls = String(rolls.dropFirst())
        } else if rolls.dropFirst().first == spare {
            rolls = String(rolls.dropFirst())
            score += frameScore(for: String(rolls.prefix(spareBonus)))
            rolls = String(rolls.dropFirst())
        } else {
            score += frameScore(for: String(rolls.prefix(rollPerFrame)))
            rolls = String(rolls.dropFirst(rollPerFrame))
        }
        index += 1
    }
    return score
}

func frameScore(for rolls: String) -> Int {
    guard rolls.count > 0 else { return 0 }
    switch Array(rolls).first {
    case strike, spare:
        return 10 + frameScore(for: String(rolls.dropFirst()))
    default:
        return Int(String(Array(rolls)[0]))! + frameScore(for: String(rolls.dropFirst()))
    }
}

if CommandLine.arguments.count != 2 {
    print("Usage: bowling.swift \"score sequence\"")
    exit(0)
}

print(totalScore(of: CommandLine.arguments[1]))
