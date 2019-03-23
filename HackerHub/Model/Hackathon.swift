//
//  Hackathon.swift
//  HackerHub
//
//  Created by Sahil Ambardekar on 3/23/19.
//  Copyright © 2019 dankcoders. All rights reserved.
//

import Foundation

struct Hackathon {
    var name: String
    var location: String
    var info: String
    var contactEmail: String
    var pictureURL: String
    var teams: [Team]
    var id: Int
    
    init(name: String, location: String, info: String, contactEmail: String, pictureURL: String, teams: [Team], id: Int) {
        self.name = name
        self.location = location
        self.info = info
        self.contactEmail = contactEmail
        self.pictureURL = pictureURL
        self.teams = teams
        self.id = id
    }
}
