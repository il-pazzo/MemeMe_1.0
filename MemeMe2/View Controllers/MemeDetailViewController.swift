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
    }
}
