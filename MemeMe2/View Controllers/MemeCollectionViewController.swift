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
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes : [Meme]! {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }

    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.strokeWidth: -2.0,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name:"HelveticaNeue-CondensedBlack", size:12)!,
    ]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createMeme))
        
        configureFlowLayout()
    }
    private func configureFlowLayout() {
        
        let spacing: CGFloat = 3.0
        flowLayout.minimumLineSpacing = spacing
        flowLayout.minimumInteritemSpacing = spacing
        
        let preferredSize: CGFloat = 100.0
        let hNumItems = CGFloat( Int((view.frame.size.width - spacing) / preferredSize))
        let vNumItems = CGFloat( Int((view.frame.size.height - spacing) / preferredSize))
        
        let hItemSize = CGFloat( Int(view.frame.size.width / hNumItems))
        let vItemSize = CGFloat( Int(view.frame.size.height / vNumItems))
        
        let bestItemSize = hItemSize < vItemSize ? hItemSize : vItemSize
        flowLayout.itemSize = CGSize( width: bestItemSize, height: bestItemSize )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
}

extension MemeCollectionViewController {
    @objc func createMeme() {
        let editorViewController = MemeEditorViewController.instantiate() as! MemeEditorViewController

        present(editorViewController, animated: true)
    }
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let memeIndex = (indexPath as NSIndexPath).row
        let meme = self.memes[memeIndex]
        
        let vc = MemeDetailViewController.instantiate() as! MemeDetailViewController
        
        vc.meme = meme
        
        self.navigationController?.pushViewController( vc, animated: true )
    }
}
