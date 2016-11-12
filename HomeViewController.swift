//
//  HomeViewController.swift
//  TBFS
//
//  Created by Kimberly Seltzer on 9/21/16.
//  Copyright © 2016 The Best Friends Show. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var bottomImageView1: UIImageView!
    @IBOutlet weak var bottomImageView2: UIImageView!
    @IBOutlet weak var bottomImageView3: UIImageView!
    @IBOutlet weak var bottomImageView4: UIImageView!
    

    @IBOutlet weak var mostRecentGifImageView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var flashLabel: UILabel!
    
    let NUM_IMAGES = 4
    var capturedImageNum = 1
    
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
        
        bottomImageView1.layoutIfNeeded()
        bottomImageView1.layer.cornerRadius = bottomImageView1.frame.height / 2.0
        bottomImageView1.clipsToBounds = true
        bottomImageView1.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        bottomImageView2.layoutIfNeeded()
        bottomImageView2.layer.cornerRadius = bottomImageView2.frame.height / 2.0
        bottomImageView2.clipsToBounds = true
        bottomImageView2.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        bottomImageView3.layoutIfNeeded()
        bottomImageView3.layer.cornerRadius = bottomImageView3.frame.height / 2.0
        bottomImageView3.clipsToBounds = true
        bottomImageView3.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        bottomImageView4.layoutIfNeeded()
        bottomImageView4.layer.cornerRadius = bottomImageView4.frame.height / 2.0
        bottomImageView4.clipsToBounds = true
        bottomImageView4.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        imagePickerController.cameraOverlayView = overlayView
        
        self.present(imagePickerController, animated: true, completion: {() -> Void in
            self.capturedImages = []
            self.startCountdown()
            })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            capturedImages.append(image)
            switch capturedImageNum {
            case 1:
                bottomImageView1.image = image
                break
            case 2:
                bottomImageView2.image = image
                break
            case 3:
                bottomImageView3.image = image
                break
            case 4:
                bottomImageView4.image = image
                break
            default:
                break
            }
            capturedImageNum += 1
        }
        flashLabel.isHidden = true
        if capturedImages.count >= NUM_IMAGES {
            capturedImageNum = 1
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
