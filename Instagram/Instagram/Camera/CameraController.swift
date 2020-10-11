//
//  CameraController.swift
//  Instagram
//
//  Created by Elattar on 5/3/20.
//  Copyright © 2020 Elattar. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController , AVCapturePhotoCaptureDelegate, UIViewControllerTransitioningDelegate{
    
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "arrows"), for: .normal)
        button.addTarget(self, action: #selector(handleDismissButton), for: .touchUpInside)
        return button
    }()
    
    let capturePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "camera (2)"), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    
    @objc func handleDismissButton (){
        self.dismiss(animated: true, completion: nil )
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transitioningDelegate = self
        
        setupCaptureSession()
        setupHUD()
        
    }
    
    
    let customAnimationPresentor = CustomAnimationPresentor()
    let customAnimationDismisser = CustomAnimationDismiss()
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationPresentor
    }
    

    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationDismisser
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    fileprivate func setupHUD(){
        view.addSubview(capturePhotoButton)
        capturePhotoButton.anchor(top: nil, left: nil, right: nil, bottom: view.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 24, width: 80, height: 80)
        capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.topAnchor, left: nil, right: view.rightAnchor, bottom: nil, paddingTop: 12, paddingLeft: 0, paddingRight: 12, paddingBottom: 0, width:  50, height: 50)
    }
    
    @objc func handleCapturePhoto (){
        
        let settings = AVCapturePhotoSettings()
        
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else {return}

        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String : previewFormatType]
        
        
    //i need to iphone camera to test that .. Ya rab
      if settings.isAccessibilityElement{
            output.capturePhoto(with: settings, delegate: self)

        }else{
            print("Camera Is Error")
        }
        
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer!)
        
        let image = UIImage(data: imageData!)
        
        
        let containerView = PreviewPhotoContainerView()
        containerView.previewImageView.image = image
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
               
        
        
        
//        let previewImageView = UIImageView(image: image)
//        view.addSubview(previewImageView)
//        previewImageView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
//
//        print("Finish processing photo sample buffer")
    }
    
    let output = AVCapturePhotoOutput()
    
    fileprivate func setupCaptureSession(){
        let captureSession = AVCaptureSession()
        
        //1. Setup Inputs
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do{
            guard let capDevice = captureDevice else {return}
            let input = try AVCaptureDeviceInput(device: capDevice)
            if captureSession.canAddInput(input){
                captureSession.addInput(input)
            }
            
        }catch let err{
            print("Could not setup camer input: " ,err.localizedDescription)
        }
        
        //2. Setup Output
        if captureSession.canAddOutput(output){
            captureSession.addOutput(output)
        }
        
        //3. Setup output preview
        let previewLayar = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayar.frame = view.frame
        view.layer.addSublayer(previewLayar)
        captureSession.startRunning()
        
        
        
    }
    
}
