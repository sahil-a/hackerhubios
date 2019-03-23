//
//  HomeViewController.swift
//  HackerHub
//
//  Created by Abhishek More on 3/23/19.
//  Copyright © 2019 dankcoders. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == projectCollection {
            print(sponsoredProjects.count)
            return sponsoredProjects.count
        } else {
            return hackathons.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == projectCollection {
            //let project = sponsoredProjects[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "projectCell", for: indexPath) as! ProjectCollectionViewCell
            return cell
        } else {
            
            //let hack = hackathons[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hackathonCell", for: indexPath) as! HackCollectionViewCell
            return cell
        }
    }
    
    
    @IBOutlet var hackathonCollection: UICollectionView!
    @IBOutlet var projectCollection: UICollectionView!
    var hackathons: [Hackathon] = []
    var sponsoredProjects: [Project] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hackathonCollection.delegate = self
        projectCollection.delegate = self
        hackathonCollection.dataSource = self
        projectCollection.dataSource = self
        
        FirebaseHelper.standardHelper.fetchHackathons { hackathons in
            if let hackathons = hackathons {
                    self.hackathons = hackathons
                    print(self.hackathons.count)
                    self.hackathonCollection.reloadData()
            
        }
        
        FirebaseHelper.standardHelper.fetchSponsoredProjects { projects in
            if let projects = projects {
                self.sponsoredProjects = projects
                print(projects.count)
                self.projectCollection.reloadData()
            }
        }
    }
    

}
}
