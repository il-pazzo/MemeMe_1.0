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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MemeTableViewController {
    @objc func createMeme() {
        let editorViewController = UIStoryboard( name: "Main", bundle: Bundle.main ).instantiateViewController( withIdentifier: "MemeEditorViewController" ) as! MemeEditorViewController
        
//        self.navigationController?.pushViewController(editorViewController, animated: true)
        present(editorViewController, animated: true)
    }
}

extension MemeTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print( "tableview returning count \(memes.count)" )
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
}
