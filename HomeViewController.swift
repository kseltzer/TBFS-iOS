//
//  HomeViewController.swift
//  TBFS
//
//  Created by Kimberly Seltzer on 9/21/16.
//  Copyright © 2016 The Best Friends Show. All rights reserved.
//

import UIKit
import ImageIO
import AssetsLibrary
import MobileCoreServices
import Photos

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
//        mostRecentGifImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2).concatenating(CGAffineTransform(scaleX: -1.0, y: 1.0))
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
            let editedImage = addWatermark(image: cropToSquare(image: image))
            capturedImages.append(editedImage)
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
                self.makeGif(with: self.capturedImages, frameDelay: 0.3)
            })
        } else {
            startCountdown()
        }
    }
    
    func startCountdown() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdownLabel), userInfo: nil, repeats: true)
    }
    
    func addWatermark(image: UIImage) -> UIImage{
        let tbfsLogo = UIImage(named: "logo_corner_white")
        
        UIGraphicsBeginImageContext(image.size);
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        tbfsLogo?.draw(in: CGRect(x: 10, y: image.size.height - (tbfsLogo!.size.height + 10), width: tbfsLogo!.size.width, height: tbfsLogo!.size.height), blendMode: .normal, alpha: 0.65)
        
        let updatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return updatedImage!
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
    
    func makeGif(with images: [UIImage], loopCount: Int = 0, frameDelay: Float) {
        let fileProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: loopCount]]
        let frameProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFDelayTime as String: frameDelay]]
        
        let documentsDirectory = NSTemporaryDirectory()
        let url: NSURL? = NSURL(fileURLWithPath: documentsDirectory).appendingPathComponent("animated.gif") as NSURL?
        
        if let url = url {
            let destination = CGImageDestinationCreateWithURL(url, kUTTypeGIF, images.count, nil)
            CGImageDestinationSetProperties(destination!, fileProperties as CFDictionary?)
            
            for i in 0..<images.count {
                CGImageDestinationAddImage(destination!, images[i].cgImage!, frameProperties as CFDictionary?)
            }
            
            CGImageDestinationFinalize(destination!)
            
            // save GIF to photo album
            PHPhotoLibrary.shared().performChanges({
                // Request creating an asset from the image.
                let creationRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: url as URL)
                // Request editing the album.
                guard let addAssetRequest = PHAssetCollectionChangeRequest(for: PHAssetCollection())
                    else { return }
                // Get a placeholder for the new asset and add it to the album editing request.
                addAssetRequest.addAssets([creationRequest?.placeholderForCreatedAsset!] as NSArray)
                }, completionHandler: { success, error in
                    if !success { NSLog("error creating asset: \(error)") }
            })
            
        }
    }
    
    func cropToSquare(image originalImage: UIImage) -> UIImage {
        // Create a copy of the image without the imageOrientation property so it is in its native orientation (landscape)
        let contextImage: UIImage = UIImage(cgImage: originalImage.cgImage!)
        
        // Get the size of the contextImage
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat
        var posY: CGFloat
        var width: CGFloat
        var height: CGFloat
        
        // Check to see which length is the longest and create the offset based on that length, then set the width and height of our rect
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            width = contextSize.height
            height = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            width = contextSize.width
            height = contextSize.width
        }
        
        let rect = CGRect(x: posX, y: posY, width: width, height: height)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: originalImage.scale, orientation: .leftMirrored)

        
        return image
    }
    
    // MARK: - Navigation
    
    @IBAction func startButtonPressed(_ sender: AnyObject) {
        attemptShowImagePicker()
    }

}
