//
//  TriviaConfig.swift
//  Trivia
//
//  Created by Alexon Abreu on 3/9/25.
//

import Foundation
import UIKit


struct TriviaQuestion {
    let question: String
    let correctAnswer: String
    let wrongAnswers: [String]
    let category: Category

    var allAnswers: [String] {
        return [correctAnswer] + wrongAnswers
    }

    var shuffledAnswers: [String] {
        return allAnswers.shuffled()
    }
}

enum Category: String {
    case Sports
    case Music
    case VideoGame
}