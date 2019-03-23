//
//  ViewController.swift
//  HackerHub
//
//  Created by Sahil Ambardekar on 3/23/19.
//  Copyright © 2019 dankcoders. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let helper = FirebaseHelper.standardHelper
        
        helper.fetchHackathons { hackathons in
            if let hackathons = hackathons {
                print(hackathons[0].teams[0].members[0].skills)
            }
        }
    }


}

