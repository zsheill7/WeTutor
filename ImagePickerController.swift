//  ImagePickerController.swift
//
//  Created by Zoe on 3/6/17.
//  Copyright © 2017 TokkiTech. All rights reserved.
//


import Foundation
import Eureka

open class ImagePickerController : UIImagePickerController, TypedRowControllerType, UIImagePickerControllerDelegate{
    
    open var row: RowOf<UIImage>!
    
    open var onDismissCallback : ((UIViewController) -> ())?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    open func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        (row as? ImageRow)?.imageURL = info[UIImagePickerControllerReferenceURL] as? URL
        row.value = info[UIImagePickerControllerOriginalImage] as? UIImage
        onDismissCallback?(self)
    }
    
    open func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        onDismissCallback?(self)
    }
}

