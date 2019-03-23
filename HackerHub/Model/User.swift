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
    var id: String
    var name: String
    var phone: String
    var profilePicURL: String
    
    init(skills: [Skill], id: String, name: String, phone: String, profilePicURL: String) {
        self.skills = skills
        self.id = id
        self.name = name
        self.phone = phone
        self.profilePicURL = profilePicURL
    }
}

enum Skill: String {
    case ios, web, python, android, cpp, unity, design, git, react, angular, node
}
