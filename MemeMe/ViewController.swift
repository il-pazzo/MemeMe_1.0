//
//  ViewController.swift
//  ImagePickerTabBar
//
//  Created by Glenn Cole on 5/18/19.
//  Copyright © 2019 Glenn Cole. All rights reserved.
//

import UIKit

enum ToolbarTags : Int {
    case camera = 0, album
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    @IBAction func pickAnImage(_ sender: UIBarButtonItem) {
        
        let pc = UIImagePickerController()
        
        pc.sourceType = (sender.tag == ToolbarTags.camera.rawValue) ? .camera : .photoLibrary
        pc.delegate = self
        
        present(pc, animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.originalImage] as? UIImage {
            imageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
}

