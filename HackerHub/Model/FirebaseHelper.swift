//
//  FirebaseHelper.swift
//  HackerHub
//
//  Created by Sahil Ambardekar on 3/23/19.
//  Copyright © 2019 dankcoders. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class FirebaseHelper {
    static var standardHelper: FirebaseHelper = FirebaseHelper()
    lazy var ref: DatabaseReference = {
        return Database.database().reference()
    }()
    
    func loadImage(url: String, completionHandler: @escaping (UIImage?) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child(url)
        
        // 10MB max file size
        storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let _ = error {
                completionHandler(nil)
            } else {
                let image = UIImage(data: data!)
                completionHandler(image)
            }
        }
    }
    
    // MARK: Local User Management
    
    func register(email: String, password: String, name: String, phone: String, profilePic: UIImage, skills: [Skill], completionHandler: @escaping (User?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let userData = authResult?.user {
                let storage = Storage.storage()
                let url = "profilePics/" + userData.uid + ".png"
                let storageRef = storage.reference().child(url)
                let profilePicData = profilePic.pngData()!
                
                storageRef.putData(profilePicData, metadata: nil) { (metadata, error) in
                    guard let _ = metadata else {
                        completionHandler(nil)
                        return
                    }
                    
                    let data: [String: Any] = [
                        "name": name,
                        "phone": phone,
                        "profilePicURL": url,
                        "skills": skills.map { $0.rawValue }
                    ]
                    
                    self.ref.child("userData").child(userData.uid).setValue(data, withCompletionBlock: { (error, _) in
                        if error == nil {
                            self.fetchUser(id: userData.uid) { user in
                                completionHandler(user)
                            }
                        } else {
                            completionHandler(nil)
                        }
                    })
                }
                
            } else {
                completionHandler(nil)
            }
        }
    }
    
    func login(email: String, password: String, completionHandler: @escaping (User?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let userData = result?.user {
                self!.fetchUser(id: userData.uid) { user in
                    completionHandler(user)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    // MARK: Fetching Data
    
    func fetchHackathons(completionHandler: @escaping ([Hackathon]?) -> Void) {
        ref.child("hackathons").observeSingleEvent(of: .value, with: { (snapshot) in
            if let hackathonsRaw = snapshot.value as? [[String: Any]] {
                var hackathons: [Hackathon] = []
                let taskGroup = DispatchGroup()
                for id in 0..<hackathonsRaw.count {
                    taskGroup.enter()
                    Hackathon.fromData(id: id, data: hackathonsRaw[id]) { hackathon in
                        if let hackathon = hackathon {
                            hackathons.append(hackathon)
                        }
                        taskGroup.leave()
                    }
                }
                
                taskGroup.notify(queue: DispatchQueue.main, work: DispatchWorkItem(block: {
                    completionHandler(hackathons)
                }))
            } else {
                completionHandler(nil)
            }
        }) { (error) in
            print(error.localizedDescription)
            completionHandler(nil)
        }
    }
    
    func fetchSponsoredProjects(completionHandler: @escaping ([Project]?) -> Void) {
        ref.child("projects").observeSingleEvent(of: .value, with: { (snapshot) in
            if let projectsData = snapshot.value as? [[String: String]] {
                var projects: [Project] = []
                for id in 0..<projectsData.count {
                    let projectData = projectsData[id]
                    if let project = Project.fromData(id: id, data: projectData) {
                        projects.append(project)
                    } else {
                        completionHandler(nil)
                    }
                }
                completionHandler(projects.filter { $0.sponsor != nil })
            } else {
                completionHandler(nil)
            }
        }) { (error) in
            print(error.localizedDescription)
            completionHandler(nil)
        }
    }
    
    func fetchProject(id: Int, completionHandler: @escaping (Project?) -> Void) {
        ref.child("projects").observeSingleEvent(of: .value, with: { (snapshot) in
            if let projectsData = snapshot.value as? [[String: String]] {
                guard id < projectsData.count else {
                    completionHandler(nil)
                    return
                }
                let projectData = projectsData[id]
                if let project = Project.fromData(id: id, data: projectData) {
                    completionHandler(project)
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }) { (error) in
            print(error.localizedDescription)
            completionHandler(nil)
        }
    }
    
    func fetchUser(id: String, completionHandler: @escaping (User?) -> Void) {
        ref.child("userData").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            if let userData = snapshot.value as? [String: Any] {
                if let user = User.fromData(id: id, data: userData) {
                    completionHandler(user)
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }) { (error) in
            print(error.localizedDescription)
            completionHandler(nil)
        }
    }
}

extension Hackathon {
    static func fromData(id: Int, data: [String: Any], completionHandler: @escaping (Hackathon?) -> Void) {
        if let contactEmail = data["contactEmail"] as? String,
            let info = data["info"] as? String,
            let location = data["location"] as? String,
            let name = data["name"] as? String,
            let pictureURL = data["pictureURL"] as? String
        {
            let taskGroup = DispatchGroup()
            var teams: [Team] = []
            if let teamsData = data["teams"] as? [[String: Any]] {
                for id in 0..<teamsData.count {
                    taskGroup.enter()
                    Team.fromData(id: id, data: teamsData[id]) { team in
                        if let team = team {
                            teams.append(team)
                        }
                        taskGroup.leave()
                    }
                }
            }
            
            taskGroup.notify(queue: DispatchQueue.main, work: DispatchWorkItem(block: {
                let hackathon = Hackathon(name: name, location: location, info: info, contactEmail: contactEmail, pictureURL: pictureURL, teams: teams, id: id)
                completionHandler(hackathon)
            }))
        }
        
    }
}

extension Team {
    static func fromData(id: Int, data: [String: Any], completionHandler: @escaping (Team?) -> Void) {
        if let memberIDs = data["members"] as? [String],
            let name = data["name"] as? String,
            let projectID = data["project"] as? Int {
            let firebaseHelper = FirebaseHelper.standardHelper
            let taskGroup = DispatchGroup()
            var users: [User] = []
            var project: Project!
            
            for memberID in memberIDs {
                taskGroup.enter()
                firebaseHelper.fetchUser(id: memberID) { user in
                    if let user = user {
                        users.append(user)
                    }
                    taskGroup.leave()
                }
            }
            
            taskGroup.enter()
            firebaseHelper.fetchProject(id: projectID) { p in
                if let p = p {
                    project = p
                }
                taskGroup.leave()
            }
            
            taskGroup.notify(queue: DispatchQueue.main, work: DispatchWorkItem(block: {
                let team = Team(id: id, name: name, members: users, project: project)
                completionHandler(team)
            }))
        }
    }
}

extension Project {
    static func fromData(id: Int, data: [String: String]) -> Project? {
        if let name = data["name"],
            let description = data["description"] {
            let sponsor = data["sponsor"]
            let contactEmail = data["contactEmail"]
            let pictureURL = data["pictureURL"]
            let instructions = data["instructions"]
            return Project(id: id, name: name, sponsor: sponsor, description: description, contactEmail: contactEmail, instructions: instructions, pictureURL: pictureURL)
        }
        return nil
    }
}

extension User {
    static func fromData(id: String, data: [String: Any]) -> User? {
        if let name = data["name"] as? String,
            let profilePicURL = data["profilePicURL"] as? String,
            let phone = data["phone"] as? String,
            let skillsData = data["skills"] as? [String] {
            var skills: [Skill] = []
            for skillData in skillsData {
                if let skill = Skill(rawValue: skillData) {
                    skills.append(skill)
                } else {
                    return nil
                }
            }
            return User(skills: skills, id: id, name: name, phone: phone, profilePicURL: profilePicURL)
        }
        return nil
    }
}
