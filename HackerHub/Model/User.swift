//
//  User.swift
//  HackerHub
//
//  Created by Sahil Ambardekar on 3/23/19.
//  Copyright © 2019 dankcoders. All rights reserved.
//

import Foundation

struct User {
    var skills: [Skill]
    var name: String
    var phone: String
    var profilePicURL: String
}

enum Skill {
    case ios, web, python, android, cpp, unity, design, git, react, angular, node
}
