//
//  CameraViewController.swift
//  TBFS
//
//  Created by Kimberly Seltzer on 9/22/16.CameraViewController
//  Copyright © 2016 The Best Friends Show. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePickerController : UIImagePickerController!
    var capturedImage : UIImage?
    var capturedImages : [UIImage]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attemptShowImagePicker()
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func attemptShowImagePicker() {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            // There is not a camera on this device
            let alertController = UIAlertController(title: "Opps!", message: "This device does not have a compatible camera.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            return self.present(alertController, animated: true, completion: nil)
        }
        
        imagePickerController = UIImagePickerController()
        imagePickerController.modalPresentationStyle = .currentContext
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        imagePickerController.showsCameraControls = true
        imagePickerController.allowsEditing = true
        imagePickerController.cameraFlashMode = .auto
        imagePickerController.cameraDevice = .front
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
