//
//  PageAppointmentActions.swift
//  YiMai
//
//  Created by why on 16/5/27.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit
import Proposer

public class PageAppointmentActions: PageJumpActions, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    public func PhotoScrollLeft(sender: UIGestureRecognizer) {
        
    }
    
    public func PhotoScrollRight(sender: UIGestureRecognizer) {
        
    }
    
    public func PhotoSelect(sender: UIGestureRecognizer) {
        let contacts: PrivateResource = PrivateResource.Photos
        
        proposeToAccess(contacts, agreed: {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .PhotoLibrary
                imagePicker.delegate = self
                
                self.NavController!.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }, rejected: {
            let alertController = UIAlertController(title: "系统提示", message: "请去隐私设置里打开照片访问权限！", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "好的", style: .Default,
                handler: {
                    action in
                        
            })
            alertController.addAction(okAction)
            self.NavController!.presentViewController(alertController, animated: true, completion: nil)
        })
    }
    
    public func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        let pageController = self.Target! as! PageAppointmentViewController
        
        let img = UIImageView(image: image)
        pageController.BodyView!.AddImage(img)

        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    public func DoAppointment(sender: UIGestureRecognizer) {
        self.NavController!.popViewControllerAnimated(true)
    }
}