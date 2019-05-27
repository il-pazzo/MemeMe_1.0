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

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var instructionsLabel: UILabel!
    
    @IBOutlet weak var activityButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var topBar: UIToolbar!
    @IBOutlet weak var bottomBar: UIToolbar!
    
    // MARK: - Properties
    
    var activeTextField: UITextField?
    let defaultTextTop = "Top"
    let defaultTextBottom = "Bottom"
    
    let textAlphaWhenShowing: CGFloat = 1.0
    let textAlpheWhenEntering: CGFloat = 0.7
    let textBackgroundColorWhenShowing = UIColor.clear
    let textBackgroundColorWhenEntering = UIColor.lightGray
    
    var meme: Meme?
    var memedImage: UIImage?
    
    
    // MARK: - View load/appear/etc.
    
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
        
        updateMemeBody()
        updateTopBarButtons()
        
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
    
    func updateMemeBody() {
        
        let isHidden = imageView.image == nil
        
        topTextField.isHidden = isHidden
        bottomTextField.isHidden = isHidden
        instructionsLabel.isHidden = !isHidden
        self.view.backgroundColor = isHidden ? UIColor.white : UIColor.black
    }
    
    func updateTopBarButtons() {
     
        activityButton.isEnabled = imageView.image != nil
        cancelButton.isEnabled = imageView.image != nil
    }
    
    func showBarsOrNo( _ showBars: Bool ) {
        
        topBar.isHidden = !showBars
        bottomBar.isHidden = !showBars
    }
    
    
    // MARK: - Button actions
    
    @IBAction func pickAnImage(_ sender: UIBarButtonItem) {
        
        let pc = UIImagePickerController()
        
        pc.sourceType = (sender.tag == ToolbarTags.camera.rawValue) ? .camera : .photoLibrary
        pc.delegate = self
        
        present(pc, animated: true, completion: nil)
    }
    
    @IBAction func maybeDiscardWorkInProgress( _ sender: UIBarButtonItem ) {
        
        let alert = UIAlertController(title: "Discard?",
                                      message: "Are you sure you want to discard this meme-in-progress?",
                                      preferredStyle: .alert)
        
        let discardAction = UIAlertAction(title: "Discard", style: .default) { _ in
            self.discardWorkInProgress()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction( discardAction )
        alert.addAction( cancelAction )
        
        present( alert, animated: true )
    }
    private func discardWorkInProgress() {
        
        meme = nil
        memedImage = nil
        imageView.image = nil
        
        if activeTextField != nil {
            activeTextField?.resignFirstResponder()
            activeTextField = nil
        }
        
        updateMemeBody()
        updateTopBarButtons()
    }
    
    @IBAction func showActivityViewController( _ sender: UIButton ) {
        
        memedImage = getMemedImage()
        
        let vc = UIActivityViewController(activityItems: [memedImage!], applicationActivities: nil)
        vc.completionWithItemsHandler = activitySharingComplete
        
        present( vc, animated: true, completion: nil )
    }
    
    @objc func activitySharingComplete( activityType: UIActivity.ActivityType?,
                                        completed: Bool,
                                        _ returnedItems: [Any]?,
                                        error: Error? ) {
        if (!completed) { return }
        
        meme = Meme(topText: topTextField.text,
                    bottomText: bottomTextField.text,
                    originalImage: imageView.image,
                    memedImage: memedImage)
    }
    
    private func getMemedImage() -> UIImage {
        
        showBarsOrNo( false )
        UIGraphicsBeginImageContext(self.view.frame.size)
        
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        showBarsOrNo( true )
        
        return memedImage
    }
    
    
    // MARK: - ImagePickerControllerDelegate methods
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.originalImage] as? UIImage {
            imageView.image = selectedImage
            updateMemeBody()
            topTextField.text = defaultTextTop
            bottomTextField.text = defaultTextBottom
        }
        
        updateTopBarButtons()
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

        activeTextField?.backgroundColor = textBackgroundColorWhenEntering
        activeTextField?.alpha = textAlpheWhenEntering
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        activeTextField?.backgroundColor = textBackgroundColorWhenShowing
        activeTextField?.alpha = textAlphaWhenShowing
        
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
    
    @objc func keyboardWillShowOrHide( _ notification: Notification ) {
        
        // NOTE: This technique only works because:
        // 1. We know the top text field will always be visible (so no action needed)
        // 2. We know the bottom text field is very near the bottom bar, and will be
        //    visible by shifting everything up the height of the keyboard...except
        //    that don't need the bottom bar to be visible as well (since that looks
        //    like hell).

        if notification.name == UIResponder.keyboardWillShowNotification {
            if bottomTextField.isEditing {
                let keyboardHeight = getKeyboardHeight( notification )
                view.frame.origin.y = 0.0 - keyboardHeight + bottomBar.frame.height
            }
        }
        else {
            view.frame.origin.y = 0.0
        }
    }
    func getKeyboardHeight( _ notification: Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![ UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
}

