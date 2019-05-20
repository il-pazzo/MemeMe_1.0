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

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var activityButton: UIBarButtonItem!

    @IBOutlet weak var topBar: UIToolbar!
    @IBOutlet weak var bottomBar: UIToolbar!
    
    
    var activeTextField: UITextField?
    let defaultTextTop = "Top"
    let defaultTextBottom = "Bottom"
    
    
    // MARK: - view load/appear/etc.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.strokeWidth: -3.0,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name:"HelveticaNeue-CondensedBlack", size:40)!,
        ]
        
        setTextFieldDefaults(textField: topTextField, defaultText: defaultTextTop, attributes: memeTextAttributes)
        setTextFieldDefaults(textField: bottomTextField, defaultText: defaultTextBottom, attributes: memeTextAttributes)
    }
    
    func setTextFieldDefaults( textField: UITextField,
                               defaultText: String,
                               attributes: [NSAttributedString.Key: Any] ) {
        
        textField.defaultTextAttributes = attributes
        textField.typingAttributes = attributes
        textField.textAlignment = .center
        textField.text = defaultText
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateMemeLabelsHidden()
        updateActivityButtonEnabled()
        
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
    
    func updateMemeLabelsHidden() {
        
        if imageView.image == nil {
            topTextField.isHidden = true
            bottomTextField.isHidden = true
        }
        else {
            topTextField.isHidden = false
            bottomTextField.isHidden = false
        }
    }
    
    func updateActivityButtonEnabled() {
     
        activityButton.isEnabled = imageView.image != nil
    }
    
    func showBarsOrNo( _ showBars: Bool ) {
        
        topBar.isHidden = !showBars
        bottomBar.isHidden = !showBars
    }
    
    @IBAction func pickAnImage(_ sender: UIBarButtonItem) {
        
        let pc = UIImagePickerController()
        
        pc.sourceType = (sender.tag == ToolbarTags.camera.rawValue) ? .camera : .photoLibrary
        pc.delegate = self
        
        present(pc, animated: true, completion: nil)
    }
    
    @IBAction func discardWorkInProgress( _ sender: UIBarButtonItem ) {
        
        imageView.image = nil
        activeTextField = nil
        
        updateMemeLabelsHidden()
    }
    
    @IBAction func showActivityViewController( _ sender: UIButton ) {
        
        let image = getMemedImage()
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        vc.completionWithItemsHandler = activitySharingComplete
        
        present( vc, animated: true, completion: nil )
    }
    
    @objc func activitySharingComplete( activityType: UIActivity.ActivityType?,
                                        completed: Bool,
                                        _ returnedItems: [Any]?,
                                        error: Error? ) {
        if (!completed) { return }
        
        print( "activity complete" )
        let meme = Meme( topText: topTextField.text,
                         bottomText: bottomTextField.text,
                         originalImage: imageView.image,
                         memedImage: getMemedImage() )

    }
    
    private func getMemedImage() -> UIImage {
        
//        showBarsOrNo( false )
        UIGraphicsBeginImageContext(self.view.frame.size)
        
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
//        showBarsOrNo( true )
        
        return memedImage
    }
    
    
    // MARK: - ImagePickerControllerDelegate methods
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.originalImage] as? UIImage {
            imageView.image = selectedImage
            updateMemeLabelsHidden()
            topTextField.text = defaultTextTop
            bottomTextField.text = defaultTextBottom
        }
        
        updateActivityButtonEnabled()
        dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - TextFieldDelegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        activeTextField = textField
        
        if textField == topTextField {
            if topTextField?.text == defaultTextTop {
                topTextField?.text = ""
            }
        }
        else if textField == bottomTextField {
            if bottomTextField?.text == defaultTextBottom {
                bottomTextField?.text = ""
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        activeTextField?.text = activeTextField?.text?.uppercased()
        activeTextField = nil
    }
    
    
    // MARK: - Keyboard machinations
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShowOrHide(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShowOrHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)

        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
//    @objc func adjustForKeyboard( _ notification: Notification ) {
//        
//        let userInfo = notification.userInfo
//        let keyboardSize = userInfo![ UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
//
//        let keyboardScreenEndFrame = keyboardSize.cgRectValue
//        let keyboardViewEndFrame = view.convert( keyboardScreenEndFrame, from: view.window )
//        
//        if notification.name == UIResponder.keyboardWillHideNotification {
//            
//        }
//    }

    @objc func keyboardWillShowOrHide( _ notification: Notification ) {

        guard let activeTextField = activeTextField else {
            print( "No active text field?" )
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification {
//            view.frame.origin.y = -getKeyboardHeight( notification )
            let keyboardRect = getKeyboardRect( notification )
            let delta = activeTextField.frame.origin.y + activeTextField.frame.height + 10.0 - keyboardRect.origin.y
            view.frame.origin.y = (delta > 0.0) ? 0.0 - delta : 0.0
        }
        else {
            view.frame.origin.y = 0.0
        }
    }
    
    func getKeyboardRect(_ notification: Notification) -> CGRect {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![ UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue
    }
}

