//
//  ViewController.swift
//  HackerHub
//
//  Created by Sahil Ambardekar on 3/23/19.
//  Copyright © 2019 dankcoders. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var passwordField: UITextField!
    @IBOutlet var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        
        UIView.animate(withDuration: 1) {
            
           // self.view.transform = CGAffineTransform(scaleX: 10, y: 10)
            
        }
        
        performSegue(withIdentifier: "signInSegue", sender: self)

        
    }
    


}

