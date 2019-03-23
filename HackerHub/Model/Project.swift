//
//  Project.swift
//  HackerHub
//
//  Created by Sahil Ambardekar on 3/23/19.
//  Copyright © 2019 dankcoders. All rights reserved.
//

import Foundation

struct Project {
    var name: String
    var sponsor: String?
    var description: String
    var contactEmail: String?
    var instructions: String?
    var pictureURL: String?
    var id: Int
    
    init(id: Int, name: String, sponsor: String?, description: String, contactEmail: String?, instructions: String?, pictureURL: String?) {
        self.id = id
        self.name = name
        self.sponsor = sponsor
        self.description = description
        self.contactEmail = contactEmail
        self.instructions = instructions
        self.pictureURL = pictureURL
    }
}
