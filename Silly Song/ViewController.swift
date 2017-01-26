//
//  ViewController.swift
//  Silly Song
//
//  Created by Dustin Howell on 1/24/17.
//  Copyright © 2017 Dustin Howell. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var lyricsView: UITextView!
    
    // MARK: Superclass Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Actions
    
    // editingDidBegin
    @IBAction func reset(_ sender: UITextField) {
        nameField.text = ""
        lyricsView.text = ""
    }
    
    // editingDidEnd
    @IBAction func displayLyrics(_ sender: UITextField) {
        guard let enteredName = nameField.text, enteredName != "" else {
            os_log("Name is empty (or nil, somehow)", type: .debug)
            return
        }
        
        lyricsView.text = lyrics(forName: enteredName, withTemplate: bananaFanaTemplate)
    }
    

}

// UITextField Delegate Extension
extension ViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}



// Utility Functions (extract to separate class?)
func shortName(fromName name: String) -> String {
    // remove upper case characters
    let name = name.lowercased().folding(options: .diacriticInsensitive, locale: .current)
    
    // remove any consonants before the first vowel
    let range = name.rangeOfCharacter(from: vowels)
    guard let startIndex = range?.lowerBound else {
        os_log("lower bound does not exist", type: .debug)
        return ""
    }

    return name.substring(from: startIndex)
}


func lyrics(forName name: String, withTemplate template: String) -> String {
    let name = name.folding(options: .diacriticInsensitive, locale: .current)
    let shortNameString = shortName(fromName: name)
    guard shortNameString != "" else {
        os_log("short name is empty", type: .debug)
        return "Please try a different name. Hint: Most names have vowels!!"
    }
    
    let lyrics = template
        .replacingOccurrences(of: "<FULL_NAME>", with: name)
        .replacingOccurrences(of: "<SHORT_NAME>", with: shortNameString)
    return lyrics
}


// Constants
let vowels = CharacterSet(charactersIn: "aeiou")

let bananaFanaTemplate = [
    "<FULL_NAME>, <FULL_NAME>, Bo B<SHORT_NAME>",
    "Banana Fana Fo F<SHORT_NAME>",
    "Me My Mo M<SHORT_NAME>",
    "<FULL_NAME>"].joined(separator: "\n")
