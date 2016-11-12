//
//  HomeViewController.swift
//  TBFS
//
//  Created by Kimberly Seltzer on 9/21/16.
//  Copyright © 2016 The Best Friends Show. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var bottomImageLabel1: UILabel!
    @IBOutlet weak var bottomImageLabel2: UILabel!
    @IBOutlet weak var bottomImageLabel3: UILabel!
    @IBOutlet weak var bottomImageLabel4: UILabel!
    

    @IBOutlet weak var mostRecentGifImageView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var flashLabel: UILabel!
    
    let NUM_IMAGES = 4
    
    var imagePickerController : UIImagePickerController = UIImagePickerController()
    var capturedImages : [UIImage] = []
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var countdownLabel: UILabel!
    var timer : Timer!
    var countdownNums = ["3", "2", "1"]
    var countdownIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.clipsToBounds = true
        startButton.layer.cornerRadius = 20
        mostRecentGifImageView.layer.cornerRadius = 2
        mostRecentGifImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2).concatenating(CGAffineTransform(scaleX: -1.0, y: 1.0))
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
        
        imagePickerController.modalPresentationStyle = .currentContext
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        imagePickerController.showsCameraControls = true
        imagePickerController.cameraFlashMode = .on
        imagePickerController.showsCameraControls = false
        imagePickerController.allowsEditing = false
        imagePickerController.cameraDevice = .front
        
        Bundle.main.loadNibNamed("CameraOverlay", owner:self, options:nil)
        overlayView.frame = imagePickerController.cameraOverlayView!.frame
        countdownLabel.text = nil
        flashLabel.isHidden = true
        
        bottomImageLabel1.layoutIfNeeded()
        bottomImageLabel1.layer.cornerRadius = bottomImageLabel1.frame.height / 2.0
        bottomImageLabel1.clipsToBounds = true
        
        bottomImageLabel2.layoutIfNeeded()
        bottomImageLabel2.layer.cornerRadius = bottomImageLabel2.frame.height / 2.0
        bottomImageLabel2.clipsToBounds = true
        
        bottomImageLabel3.layoutIfNeeded()
        bottomImageLabel3.layer.cornerRadius = bottomImageLabel3.frame.height / 2.0
        bottomImageLabel3.clipsToBounds = true
        
        bottomImageLabel4.layoutIfNeeded()
        bottomImageLabel4.layer.cornerRadius = bottomImageLabel4.frame.height / 2.0
        bottomImageLabel4.clipsToBounds = true
        
        imagePickerController.cameraOverlayView = overlayView
        
        self.present(imagePickerController, animated: true, completion: {() -> Void in
            self.capturedImages = []
            self.startCountdown()
            })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            capturedImages.append(image)
        }
        flashLabel.isHidden = true
        if capturedImages.count >= NUM_IMAGES {
            self.dismiss(animated: true, completion: {
                self.mostRecentGifImageView.animationImages = self.capturedImages
                self.mostRecentGifImageView.animationDuration = 1.5
                self.mostRecentGifImageView.animationRepeatCount = 0
                self.mostRecentGifImageView.startAnimating()
            })
        } else {
            startCountdown()
        }
    }
    
    func startCountdown() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdownLabel), userInfo: nil, repeats: true)
    }
    
    func updateCountdownLabel() {
        if countdownIndex == countdownNums.count {
            countdownLabel.text = nil
            flashLabel.isHidden = false
            imagePickerController.takePicture()
            countdownIndex = 0
            timer.invalidate()
        } else {
            countdownLabel.text = countdownNums[countdownIndex]
            countdownIndex += 1
        }
    }
    
    // MARK: - Navigation
    
    @IBAction func startButtonPressed(_ sender: AnyObject) {
        attemptShowImagePicker()
    }

}
