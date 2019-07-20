//
//  MemeCollectionViewController.swift
//  MemeMe2
//
//  Created by Glenn Cole on 7/17/19.
//  Copyright © 2019 Glenn Cole. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var memes : [Meme]! {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }

    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.strokeWidth: -2.0,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name:"HelveticaNeue-CondensedBlack", size:12)!,
    ]
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MemeCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        
        let memeIndex = (indexPath as NSIndexPath).row
        let meme = self.memes[memeIndex]
        
        cell.imageView?.image = meme.originalImage
        
        if let topText = meme.topText {
            cell.topLabel?.attributedText = NSAttributedString(string: topText, attributes: memeTextAttributes)
        }
        if let bottomText = meme.bottomText {
            cell.bottomLabel?.attributedText = NSAttributedString(string: bottomText, attributes: memeTextAttributes)
        }
        
        return cell
    }

}
