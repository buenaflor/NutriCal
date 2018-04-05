//
//  BaseImagePickerViewController.swift
//  NutriCal
//
//  Created by Giancarlo on 04.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit


class BaseImagePickerViewController: UIViewController {
    
    let imagePickerButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.backgroundColor = UIColor.StandardMode.TabBarColor
        button.layer.masksToBounds = true
        return button
    }()
    
    
    
    var imageFilePath: String?
    
}

extension BaseImagePickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        imagePickerButton.setImage(pickedImage, for: .normal)
        
        if let imgUrl = info[UIImagePickerControllerImageURL] as? URL{
            let imgName = imgUrl.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let localPath = documentDirectory?.appending(imgName)
            
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            let data = UIImagePNGRepresentation(image)! as NSData
            data.write(toFile: localPath!, atomically: true)
            
            imageFilePath = localPath
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
