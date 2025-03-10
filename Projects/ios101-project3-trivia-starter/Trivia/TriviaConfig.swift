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
    case kpop
    case boba
    case tech

    var image: UIImage? {
        switch self {
        case .kpop:
            return UIImage(named: "animals_icon")
        case .boba:
            return UIImage(named: "kpop_icon")
        case .tech:
            return UIImage(named: "computer_science_icon")
        }
    }
}
