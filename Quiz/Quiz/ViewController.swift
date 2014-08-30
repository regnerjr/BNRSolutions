//
//  ViewController.swift
//  Quiz
//
//  Created by John Regner on 7/26/14.
//  Copyright (c) 2014 In Your Dreams Software. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var answerField: UILabel!

    let questions: [String] = Array()
    let answers: [String] = Array()
    var currentQuestionIndex: Int

    init(coder aDecoder: NSCoder! ){
        currentQuestionIndex = 0
        questions += " What is 7 + 7?"
        answers += " 14"

        questions += " What is the capital of Vermont?"
        answers += " Montpelier"

        questions += " From what is cognac made?"
        answers += " Grapes"
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showQuestion(sender: AnyObject) {
        ++currentQuestionIndex

        if currentQuestionIndex == questions.count{
            currentQuestionIndex = 0
        }
        let question = questions[currentQuestionIndex]
        NSLog("displaying question: %@", question)

        questionField.text = question
        answerField.text = "???"
    }

    @IBAction func showAnswer(sender: AnyObject) {
        let answer = answers[currentQuestionIndex]
        answerField.text = answer
    }
    @IBAction func transitionToPager(sender: AnyObject) {
        performSegueWithIdentifier("mySegue", sender: sender)
    }
}