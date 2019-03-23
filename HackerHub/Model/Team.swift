//
//  Team.swift
//  HackerHub
//
//  Created by Sahil Ambardekar on 3/23/19.
//  Copyright © 2019 dankcoders. All rights reserved.
//

import Foundation

struct Team {
    var name: String
    var members: [User]
    var project: Project?
    var id: Int
    
    init(id: Int, name: String, members: [User], project: Project?) {
        self.id = id
        self.name = name
        self.members = members
        self.project = project
    }
}
