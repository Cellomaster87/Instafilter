//
//  ViewController.swift
//  Instafilter
//
//  Created by Michele Galvagno on 28/03/2019.
//  Copyright © 2019 Michele Galvagno. All rights reserved.
//

import CoreImage
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: Outlets and Properties
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    var currentImage: UIImage!
    
    var context: CIContext!
    var currentFilter: CIFilter!
    
    // MARK: Views management
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Instafilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
    }
    
    // MARK: Actions
    @IBAction func changeFilter(_ sender: UIButton) {
        let filterAC = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        filterAC.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        filterAC.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        filterAC.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        filterAC.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        filterAC.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        filterAC.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        filterAC.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        filterAC.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popoverController = filterAC.popoverPresentationController {
            popoverController.sourceView = sender // optional? Why?
            popoverController.sourceRect = sender.bounds
        }
        
        present(filterAC, animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        guard let image = imageView.image else {
            let noImageAC = UIAlertController(title: "No Image Found!", message: "Please select an image from your Photo Library before continuing!", preferredStyle: .alert)
            noImageAC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(noImageAC, animated: true)
            
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing()
    }
    
    // MARK: Methods
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        currentImage = image
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey) }
        if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            imageView.image = processedImage
        }
    }
    
    func setFilter(action: UIAlertAction) {
        guard currentImage != nil else { return }
        guard let actionTitle = action.title else { return }
        
        currentFilter = CIFilter(name: actionTitle)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let errorAC = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            errorAC.addAction(UIAlertAction(title: "OK", style: .default))
            present(errorAC, animated: true)
        } else {
            let savedAC = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            savedAC.addAction(UIAlertAction(title: "OK", style: .default))
            present(savedAC, animated: true)
        }
    }
}

