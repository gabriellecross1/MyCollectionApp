//
//  CameraAccess.swift
//  MyCollectionApp
//
//  Created by Gabrielle Cross on 13/02/2020.
//  Copyright © 2020 Gabrielle Cross. All rights reserved.
//

import Foundation
var imagePicker: UIImagePickerController!


class  CameraAccess: UIImagePickerControllerDelegate
{
    func CameraAccess(){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera

        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        imageView.image = info[.originalImage] as? UIImage
    }
}
