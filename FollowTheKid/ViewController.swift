//
//  ViewController.swift
//  FollowTheKid
//
//  Created by Laurence Wingo on 7/15/17.
//  Copyright © 2017 Laurence Wingo. All rights reserved.
//


//importing UIKit give the developer the option to develop with UI elements from Apple
import UIKit

//this class is called ViewController which is a subclass of UIViewController and adopts the UIAlertViewDelegate Protocol
class ViewController: UIViewController, UIAlertViewDelegate {
   
    
    //enums are to give you the choice of options, these are the color choices for buttons
    enum ButtonColor: Int {
        case Red = 1
        case Green = 2
        case Blue = 3
        case Yellow = 4
    }
    
    //this enum is the choice if the Human is playing or is the Computer playing?
    enum WhoseTurn {
        case Human
        case Computer
    }
    
    //view related objects created from the UIKit framework
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    
    
    //model related objects and variables in regards to following the MVC principle.
    let winningNumber: Int = 25
    var currentPlayer: WhoseTurn = .Computer
    var inputs = [ButtonColor]()
    var indexOfNextButtonToTouch: Int = 0
    var highlightSquareTime = 0.5
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startNewGame()
    }
    
    
    //On this function, when it returns a UIButton, I think it is essentially returning a Int value
    func buttonByColor(color: ButtonColor)-> UIButton{
        switch color {
        case .Red:
            return redButton
        case .Green:
            return greenButton
        case .Blue:
            return blueButton
        case .Yellow:
            return yellowButton
        }
    }
    
    
    func playSequence(index: Int, highlightTime: Double){
        currentPlayer = .Computer
        
        if index == inputs.count{
            currentPlayer = .Human
            return
        }
        
        var button: UIButton = buttonByColor(color: inputs[index])
        var originalColor: UIColor? = button.backgroundColor
        var highlightColor: UIColor = UIColor.white
        
        UIView.animate(withDuration: highlightTime, delay: 0.0, options: [.curveLinear, .allowUserInteraction, .beginFromCurrentState], animations: {
            button.backgroundColor = highlightColor
        }, completion: {
            finished in button.backgroundColor = originalColor
            var newIndex: Int = index + 1
            self.playSequence(index: newIndex, highlightTime: highlightTime)
        })
    }
    
    @IBAction func buttonTouched(sender: UIButton){
        //determine which button was touched by looking at its tag
        var buttonTag: Int = sender.tag
        
        if let colorTouched = ButtonColor(rawValue: buttonTag){
            if currentPlayer == .Computer{
                //ignore touches as long as this flag is set to true
                return
            }
            
            if colorTouched == inputs[indexOfNextButtonToTouch]{
                //the player touched the correct button...
                indexOfNextButtonToTouch += 1
                
                //determine if there are any more button left in this round
                if indexOfNextButtonToTouch == inputs.count{
                    //the player has won this round
                    if advanceGame() == false{
                        playerWins()
                    }
                    indexOfNextButtonToTouch = 0
                }
                else {
                    //there are more buttons left in this round...keep going
                }
            }
            else{
                //the player touched the wrong button
                playerLoses()
                indexOfNextButtonToTouch = 0
            }
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        startNewGame()
    }
    
    func playerWins(){
        var winner: UIAlertView = UIAlertView(title: "You Won!", message: "Congratulations!", delegate: self, cancelButtonTitle: "nil", otherButtonTitles: "Awesome!")
        winner.show()
    }
    
    func randomButton()->ButtonColor{
        var v: Int = Int(arc4random_uniform(UInt32(4))) + 1
        var result = ButtonColor(rawValue: v)
        return result!
    }
    
    func startNewGame(){
        //randomize the input array
        inputs = [ButtonColor]()
        advanceGame()
    }
    
    func advanceGame()->Bool{
        
        var result: Bool = true
        
        if inputs.count == winningNumber{
            result = false
        }
        else{
            //add a new random number to the input list
            inputs += [randomButton()]
            
            //play the button sequence
            playSequence(index: 0, highlightTime: highlightSquareTime)
        }
        
        return result
    }
}

