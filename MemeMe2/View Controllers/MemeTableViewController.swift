//
//  MemeTableViewController.swift
//  MemeMe2
//
//  Created by Glenn Cole on 7/17/19.
//  Copyright © 2019 Glenn Cole. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var memes : [Meme]! {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createMeme))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

extension MemeTableViewController {
    @objc func createMeme() {
        let editorViewController = MemeEditorViewController.instantiate() as! MemeEditorViewController
        
        present(editorViewController, animated: true)
    }
}

extension MemeTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell")!
        let memeIndex = (indexPath as NSIndexPath).row
        let meme = self.memes[memeIndex]

        // Set the name and image
        cell.textLabel?.text = "\(meme.topText ?? "")…\(meme.bottomText ?? "")"
        cell.imageView?.image = meme.originalImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let memeIndex = (indexPath as NSIndexPath).row
        let meme = self.memes[memeIndex]
        
        let vc = MemeDetailViewController.instantiate() as! MemeDetailViewController
        
        vc.meme = meme
        
        self.navigationController?.pushViewController( vc, animated: true )
    }
}
