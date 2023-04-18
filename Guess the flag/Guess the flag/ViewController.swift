//
//  ViewController.swift
//  Guess the flag
//
//  Created by Nathan Getachew on 4/18/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var button1: UIButton!
    
    @IBOutlet var button2: UIButton!
    
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    
    var score = 0
    
    var correctAnswer = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia" , "spain" , "uk", "us" ]
        
        navigationController?.title = title
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        askQuestion()
    }
    
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        title = countries[correctAnswer].uppercased()
        button1.setImage(UIImage(named: countries[0]),for: .normal)
        button2.setImage(UIImage(named: countries[1]),for: .normal)
        button3.setImage(UIImage(named: countries[2]),for: .normal)
        
        
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title:String
        var subtitle : String
        let isCorrect = sender.tag == correctAnswer
        
        
        if isCorrect {
            title = "Correct"
            subtitle = "Good job\n"
            score += 1
        } else {
            title = "Wrong"
            subtitle = "The flag was \(countries[sender.tag].uppercased())\n"
            score -= 1
        }
        
        let ac = UIAlertController(title: title, message: "\(subtitle) Your score is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default,handler: { [weak self] _ in
            
            self?.askQuestion()
        }))
        present(ac, animated: true)
        
            
    }
    
}

