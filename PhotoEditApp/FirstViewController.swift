//
//  FirstViewController.swift
//  PhotoEditApp
//
//  Created by Revani Govender on 7/21/18.
//  Copyright © 2018 Revani Govender. All rights reserved.
//

import UIKit
import CoreImage

class FirstViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var Library: UIButton!
    @IBOutlet weak var Camera : UIButton!
    @IBOutlet weak var Save   : UIButton!
    
    @IBOutlet var FilterGestureRight: UISwipeGestureRecognizer!
    @IBOutlet var FilterGestureLeft : UISwipeGestureRecognizer!

    @IBOutlet weak var ImageView      : UIImageView!
    @IBOutlet weak var FilterImageView: UIImageView!
    
    let CIFilterNames = [
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIBoxBlur",
        "CIColorInvert",
        "CIColorCrossPolynomial",
        "CISepiaTone"
    ]
    
    var CurrentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(filterSwipe(swipe:)))
        leftSwipe.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(leftSwipe)
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(filterSwipe(swipe:)))
        rightSwipe.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(rightSwipe)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func filterSwipe(swipe: UISwipeGestureRecognizer) {

        switch swipe.direction {
        case UISwipeGestureRecognizerDirection.left:
            if CurrentIndex > 0 {
                CurrentIndex = CurrentIndex - 1
                applyFilter()
            } else {
                CurrentIndex = CIFilterNames.count - 1
                applyFilter()
            }
        case UISwipeGestureRecognizerDirection.right:
            if CurrentIndex < (CIFilterNames.count - 1) {
                CurrentIndex = CurrentIndex + 1
                applyFilter()
            } else {
                CurrentIndex = 0
                applyFilter()
            }
        default:
            break
        }
        
        
    }
    
    func applyFilter() {
        let originalImage = CIImage(image: ImageView.image!)
        NSLog(String(CurrentIndex))
        let filter = CIFilter(name: CIFilterNames[CurrentIndex])
        filter?.setDefaults()
        filter?.setValue(originalImage, forKey: kCIInputImageKey)
        
        let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as? CIImage
        
        FilterImageView.image = UIImage(ciImage: filteredImageData!)
    }

    @IBAction func CameraAction(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self;
        picker.sourceType = .camera
        
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func LibraryAction(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self;
        picker.sourceType = .photoLibrary
        
        self.present(picker, animated: true, completion: nil)

    }
    
    @IBAction func SaveAction(_ sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum(FilterImageView.image!, self, #selector(addImage(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func addImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Saved to Photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        ImageView.image = info[UIImagePickerControllerOriginalImage]as? UIImage;
        FilterImageView.image = ImageView.image
        ImageView.contentMode = .scaleAspectFit
    }
}

