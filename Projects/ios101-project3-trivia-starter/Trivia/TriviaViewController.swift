//
//  TriviaViewController.swift
//  Trivia
//
//  Created by Alexon Abreu on 3/9/25.
//

import UIKit

class TriviaViewController: UIViewController {

    @IBOutlet weak var QuestionNumber: UILabel!
    @IBOutlet weak var QuestionCategory: UILabel!
    @IBOutlet weak var QuestionView: UILabel!
        

    @IBOutlet weak var answer1: UIButton!
    @IBOutlet weak var answer2: UIButton!
    @IBOutlet weak var answer3: UIButton!
    @IBOutlet weak var answer4: UIButton!
    
    @IBOutlet var answerChoices: [UIButton]!
    
    
    var questions: [TriviaQuestion] = []
    var currentQuestionIndex = 0
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        


questions = [
        // Sports questions
        TriviaQuestion(
            question: "Which soccer team has the most UEFA Champions League titles?",
            correctAnswer: "Real Madrid",
            wrongAnswers: ["Barcelona", "Bayern Munich", "Liverpool"],
            category: .Sports
        ),
        TriviaQuestion(
            question: "Who won the NBA championship in 2021?",
            correctAnswer: "Milwaukee Bucks",
            wrongAnswers: ["Los Angeles Lakers", "Phoenix Suns", "Golden State Warriors"],
            category: .Sports
        ),
        
        // Music questions
        TriviaQuestion(
            question: "Which artist is known as the 'King of Pop'?",
            correctAnswer: "Michael Jackson",
            wrongAnswers: ["Prince", "Elvis Presley", "Freddie Mercury"],
            category: .Music
        ),
        TriviaQuestion(
            question: "Which band performed the song 'Bohemian Rhapsody'?",
            correctAnswer: "Queen",
            wrongAnswers: ["The Beatles", "Pink Floyd", "Led Zeppelin"],
            category: .Music
        ),
        
        // Video Game questions
        TriviaQuestion(
            question: "Which company developed the video game 'The Legend of Zelda' series?",
            correctAnswer: "Nintendo",
            wrongAnswers: ["Sony", "Microsoft", "Square Enix"],
            category: .VideoGame
        ),
        TriviaQuestion(
            question: "Which popular battle royale game was developed by Epic Games?",
            correctAnswer: "Fortnite",
            wrongAnswers: ["PUBG", "Apex Legends", "Call of Duty: Warzone"],
            category: .VideoGame
        )
    ]

//            
            // Display first question
            QuestionView.numberOfLines = 0
            QuestionView.lineBreakMode = .byWordWrapping
        
            QuestionView.layer.cornerRadius = 10
            QuestionView.clipsToBounds = true

            displayQuestion()

        // Do any additional setup after loading the view.
    }
    
    
    func displayQuestion() {
        let currentQuestion = questions[currentQuestionIndex]
        
        QuestionNumber.text = "Question \(currentQuestionIndex + 1)/6"
        QuestionCategory.text = "Category: \(currentQuestion.category)"
        QuestionView.text = currentQuestion.question
        
        let shuffledAnswers = currentQuestion.shuffledAnswers
        for (index, button) in answerChoices.enumerated() {
            button.setTitle(shuffledAnswers[index], for: .normal)
            button.contentHorizontalAlignment = .center
            button.titleLabel?.textAlignment = .center
            button.setTitleColor(.white, for: .normal)
        }
    }
 
    func checkAnswer(selectedAnswer: String) {
            let currentQuestion = questions[currentQuestionIndex]
            
            if selectedAnswer == currentQuestion.correctAnswer {
                score += 1
            }
            
            // Move to the next question or show score
            currentQuestionIndex += 1
            
            if currentQuestionIndex < questions.count {
                displayQuestion()
            } else {
                showScore()
            }
        }
        
        func showScore() {
            // Show the score using an alert
            let alert = UIAlertController(title: "Quiz Finished", message: "Your score is \(score) out of \(questions.count)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        @IBAction func answerButtonTapped(_ sender: UIButton) {
            if let selectedAnswer = sender.currentTitle {
                print("pressed option")
                checkAnswer(selectedAnswer: selectedAnswer)
            }
        }
    
}
