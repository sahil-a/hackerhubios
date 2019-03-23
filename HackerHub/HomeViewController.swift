//
//  HomeViewController.swift
//  HackerHub
//
//  Created by Abhishek More on 3/23/19.
//  Copyright © 2019 dankcoders. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {


    override func viewDidLoad() {
        super.viewDidLoad()
        
       
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
//            UIView.animate(withDuration: 5){
//                self.view.transform = CGAffineTransform(scaleX: 1, y: 1)
//            }
//        }

        
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "projectCell", for: indexPath) as! ProjectCollectionViewCell
    
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSpringLoadItemAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        return true
    }

}
