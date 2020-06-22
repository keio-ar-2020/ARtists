//
//  PickOriginalAndStyleImagesViewController.swift
//  ARtists
//
//  Created by 尾崎耀一 on 2020/06/21.
//  Copyright © 2020 ar2020. All rights reserved.
//

import UIKit
import RevealingSplashView
import os

class OriginalAndStyleImagesPickerViewController: UIViewController {
    
    private var revealingLoaded = false
    override var shouldAutorotate: Bool {
        return revealingLoaded
    }
    
    /// Image picker for accessing the photo library or camera
    private var originalImagePicker = UIImagePickerController()
    
    /// Style transferer instance reponsible for running the TF model. Uses a Int8-based model and
    /// runs inference on the CPU.
    private var cpuStyleTransferer: StyleTransferer?
    
    /// Style transferer instance reponsible for running the TF model. Uses a Float16-based model and
    /// runs inference on the GPU.
    private var gpuStyleTransferer: StyleTransferer?
    
    /// Target image to transfer a style onto.
    private var originalImage: UIImage?
    
    /// Style-representative image applied to the input image to create a pastiche.
    private var styleImage: UIImage?
    
    /// Style transfer result.
    private var styleTransferResult: StyleTransferResult?
    
    
    // UI elements
    @IBOutlet weak var originalImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var photoLibraryButton: UIButton!
    @IBOutlet weak var styleImageButton: UIButton!
    @IBOutlet weak var styleImageView: UIImageView!
    @IBOutlet weak var generateButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let revealingSplashView = RevealingSplashView(
            iconImage: UIImage(named: "ARtist-icon")!,
            iconInitialSize: CGSize(width:200, height: 200),
            backgroundColor: UIColor.white
        )
        self.view.addSubview(revealingSplashView)
        revealingSplashView.duration = 1.0
        
        revealingSplashView.useCustomIconColor = false
        
        revealingSplashView.animationType = SplashAnimationType.squeezeAndZoomOut
        
        revealingSplashView.startAnimation(){
            self.revealingLoaded = true
            self.setNeedsStatusBarAppearanceUpdate()
            print("INFO: SplashView Completed")
        }
        
        // Do any additional setup after loading the view.
        originalImageView.contentMode = .scaleAspectFit
        
        // Setup image picker
        originalImagePicker.delegate = self
        originalImagePicker.sourceType = .photoLibrary
        
        // Set default style image.
        styleImage = StyleImagePickerDataSource.defaultStyle()
        styleImageView.image = styleImage
        
        // Enable camera option only if current device has camera.
        let isCameraAvailable = UIImagePickerController.isCameraDeviceAvailable(.front) || UIImagePickerController.isCameraDeviceAvailable(.rear)
        if isCameraAvailable {
            cameraButton.isEnabled = true
        }
        
        // Initialize new style transferer instances.
        StyleTransferer.newCPUStyleTransferer { result in
            switch result {
            case .success(let transferer):
                self.cpuStyleTransferer = transferer
            case .error(let wrappedError):
                print("Failed to initialize: \(wrappedError)")
            }
        }
        StyleTransferer.newGPUStyleTransferer { result in
            switch result {
            case .success(let transferer):
                self.gpuStyleTransferer = transferer
            case .error(let wrappedError):
                print("Failed to initialize: \(wrappedError)")
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toStylizedImageViewContoller" {
            let next = segue.destination as? StylizedImageViewController
            next?.originalImage = self.originalImage
            next?.styleImage = self.styleImage
            next?.resultImage = self.styleTransferResult!.resultImage
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
//    @IBAction func onTapOriginalImageButton(_ sender: Any) {
//
//    }
    
    @IBAction func onTapCameraButton(_ sender: Any) {
        guard
            UIImagePickerController.isCameraDeviceAvailable(.front) || UIImagePickerController.isCameraDeviceAvailable(.rear)
            else {
                return
        }
        originalImagePicker.sourceType = .camera
        present(originalImagePicker, animated: true)
    }
    
    @IBAction func onTapPhotoLibraryButton(_ sender: Any) {
        originalImagePicker.sourceType = .photoLibrary
        present(originalImagePicker, animated: true)
    }
    
    @IBAction func onTapStyleImageButton(_ sender: Any) {
        let styleImagePickerController = StyleImagePickerViewController.fromStoryboard()
        styleImagePickerController.delegate = self
        present(styleImagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func onTapGenerateButton(_ sender: Any) {
        guard originalImage != nil else {
            print("ERROR: Original image is nil.")
            return
        }
        runStyleTransfer(originalImage!)
    }
    
    @IBAction func onTapBackToTop(segue: UIStoryboardSegue) {}
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// MARK: - Style Transfer

extension OriginalAndStyleImagesPickerViewController {
    /// Run style transfer on the given image, and show result on screen.
    ///  - Parameter image: The target image for style transfer.
    func runStyleTransfer(_ image: UIImage?) {
        clearResults()
        
        let shouldUseQuantizedFloat16 = true
        let transferer = shouldUseQuantizedFloat16 ? gpuStyleTransferer : cpuStyleTransferer
        
        // Make sure that the style transferer is initialized.
        guard let styleTransferer = transferer else {
            print("ERROR: Interpreter is not ready.")
            return
        }
        
        guard let image = self.originalImage else {
            print("ERROR: Select a original image.")
            return
        }
        
        // Center-crop the original image
        // let image = originalImage.cropCenter()
        
        // Cache the potentially cropped image.
        self.originalImage = image
        
        // Show the potentially cropped image on screen.
        originalImageView.image = image
        
        // Make sure that the image is ready before running style transfer.
        // guard image != nil else {
        //     print("ERROR: Image could not be cropped.")
        //     return
        // }
        
        guard let styleImage = styleImage else {
            print("ERROR: Select a style image.")
            return
        }
        
        // Run style transfer.
        styleTransferer.runStyleTransfer(
            style: styleImage,
            image: image,
            completion: { result in
                // Show the result on screen
                switch result {
                case let .success(styleTransferResult):
                    self.styleTransferResult = styleTransferResult
                case .error(_):
                    print("ERROR: `runStyleTransfer()` returns some errors.")
                    return // TODO: should tell the user failed result.
                }
                sleep(UInt32(1.0))
                self.performSegue(withIdentifier: "toStylizedImageViewContoller", sender: nil)
        })
//        performSegue(withIdentifier: "toStylizedImageViewContoller", sender: nil)
    }
    
    /// Clear result from previous run to prepare for new style transfer.
    private func clearResults() {
        
    }
}

// MARK: - UIImagePickerControllerDelegate

extension OriginalAndStyleImagesPickerViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        
        if let pickedImage = info[.originalImage] as? UIImage {
            // Rotate target image to .up orientation to avoid potential orientation misalignment.
            guard let originalImage = pickedImage.transformOrientationToUp() else {
                print("ERROR: Image orientation couldn't be fixed.")
                return
            }
            self.originalImage = originalImage.cropCenter()
            self.originalImageView.image = originalImage.cropCenter()
        }
        dismiss(animated: true)
    }
}

// MARK: StylePickerViewControllerDelegate

extension OriginalAndStyleImagesPickerViewController: StyleImagePickerViewControllerDelegate {
    
    func picker(_: StyleImagePickerViewController, didSelectStyle image: UIImage) {
        self.styleImage = image
        styleImageView.image = image
    }
}


