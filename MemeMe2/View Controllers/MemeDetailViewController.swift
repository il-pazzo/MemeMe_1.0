//
//  MemeDetailViewController.swift
//  MemeMe2
//
//  Created by Glenn Cole on 7/20/19.
//  Copyright © 2019 Glenn Cole. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        memeImageView?.image = meme.memedImage
        
        if meme.memedImage != nil {
            let activityBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showActivityViewController(_:)))
            
            navigationItem.rightBarButtonItem = activityBarButtonItem
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        super.viewWillDisappear(animated)
    }
}

extension MemeDetailViewController {
    
    @objc func showActivityViewController( _ sender: UIButton ) {
        
        guard let memedImage = meme.memedImage else {
            return
        }
        
        let vc = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        vc.completionWithItemsHandler = nil
        
        present( vc, animated: true, completion: nil )
    }
}
