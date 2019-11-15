//
//  ViewController.swift
//  WhatAnimal
//
//  Created by 1 on 11/13/19.
//  Copyright © 2019 1. All rights reserved.
//

import UIKit
import SnapKit
import CoreML
import Vision


class ViewController: UIViewController {
    
    lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .savedPhotosAlbum
        imagePickerController.allowsEditing = false
        return imagePickerController
    }()

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var animalNameLabel: UILabel = {
        let animalNameLabel = UILabel()
        animalNameLabel.font = UIFont(name: "Avenir-Heavy", size: 20)
        animalNameLabel.textColor = .black
        animalNameLabel.numberOfLines = 1
        animalNameLabel.textAlignment = .center
       // animalNameLabel.text = TEXT OF FOUND ANIMAL
        return animalNameLabel
    }()
    
    lazy var cameraButton: UIBarButtonItem = {
        let cameraButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraButtonTapped))
        return cameraButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image", "public.movie"]
        pickerController.sourceType = .camera
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.rightBarButtonItem = cameraButton
        setupUI()
    }
    
    

    @objc func cameraButtonTapped() {
        showAlert()
    }

    func detect(image: CIImage) {
        
        // Load the ML model through its generated class
        guard let model = try? VNCoreMLModel(for: PetImageClassifier().model) else {
            fatalError("can't load ML model")
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation],
                let topResult = results.first
                else {
                    fatalError("unexpected result type from VNCoreMLRequest")
                }
            
                if topResult.identifier.contains("Dog") {
                    DispatchQueue.main.async {
                        self.navigationItem.title = "Dog!"
                        self.animalNameLabel.text = "This is a Dog!"
                        self.navigationController?.navigationBar.barTintColor = UIColor.green
                        self.navigationController?.navigationBar.isTranslucent = false
                    }
                } else if topResult.identifier.contains("Cat") {
                    DispatchQueue.main.async {
                        self.navigationItem.title = "Cat!"
                        self.animalNameLabel.text = "This is a cat!"
                        self.navigationController?.navigationBar.barTintColor = UIColor.green
                        self.navigationController?.navigationBar.isTranslucent = false
                    }
                }
                    else if topResult.identifier.contains("Rabbit") {
                    DispatchQueue.main.async {
                        self.navigationItem.title = "Rabbit!"
                        self.animalNameLabel.text = "This is a rabbit!"
                        self.navigationController?.navigationBar.barTintColor = UIColor.green
                        self.navigationController?.navigationBar.isTranslucent = false
                    }
                }
                        else {
                    DispatchQueue.main.async {
                        self.navigationItem.title = "Wrong!"
                        self.animalNameLabel.text = "This is something that I cannot identify!"
                        self.navigationController?.navigationBar.barTintColor = UIColor.red
                        self.navigationController?.navigationBar.isTranslucent = false
                    }
                }
                
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do { try handler.perform([request]) }
        catch { print(error) }
        
        
        
    }
    
    
    
    
    
    

}

extension ViewController {
    func setupUI() {
        self.view.backgroundColor = UIColor(red: 72.0, green: 147.0, blue: 236.0, alpha: 0.5)
        
        self.view.addSubview(imageView)
        self.view.addSubview(animalNameLabel)
       
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(UIScreen.main.bounds.height * 0.05)
            make.width.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height / 2)
        }
        
        animalNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            debugPrint("Called")
    
            if let image = info[.originalImage] as? UIImage {
    
                imageView.image = image
    
                imagePickerController.dismiss(animated: true, completion: nil)
    
    
                guard let ciImage = CIImage(image: image) else {
                    fatalError("couldn't convert uiimage to CIImage")
                }
    
                detect(image: ciImage)
    
            }
        }
    
        //Show alert
            func showAlert() {
    
                let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
                    self.getImage(fromSourceType: .camera)
                }))
                alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
                    self.getImage(fromSourceType: .photoLibrary)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
    
            //get image from source type
           func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
    
                //Check is source type available
                if UIImagePickerController.isSourceTypeAvailable(sourceType) {
    
                    imagePickerController.sourceType = sourceType
                    self.present(imagePickerController, animated: true, completion: nil)
                }
            }
    }

//extension ViewController: UIImagePickerControllerDelegate {
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        debugPrint("Called")
//
//        if let image = info[.originalImage] as? UIImage {
//
//            imageView.image = image
//
//            imagePickerController.dismiss(animated: true, completion: nil)
//
//
//            guard let ciImage = CIImage(image: image) else {
//                fatalError("couldn't convert uiimage to CIImage")
//            }
//
//            detect(image: ciImage)
//
//        }
//    }
//
//    //Show alert
//        func showAlert() {
//
//            let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
//            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
//                self.getImage(fromSourceType: .camera)
//            }))
//            alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
//                self.getImage(fromSourceType: .photoLibrary)
//            }))
//            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//
//        //get image from source type
//       func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
//
//            //Check is source type available
//            if UIImagePickerController.isSourceTypeAvailable(sourceType) {
//
//                let imagePickerController = UIImagePickerController()
//                imagePickerController.delegate = self
//                imagePickerController.sourceType = sourceType
//                self.present(imagePickerController, animated: true, completion: nil)
//            }
//        }
//}
//
