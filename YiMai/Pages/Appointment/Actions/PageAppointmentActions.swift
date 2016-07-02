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
    var ApiUtility: YMAPIUtility? = nil
    
    override func ExtInit() {
        ApiUtility = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_CREATE_NEW_APPOINTMENT,
                                  success: CreateAppointmentSuccess,
                                  error: CreateAppointmentError)
    }
    
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
    
    public func imagePickerController(picker: UIImagePickerController!,
                                      didFinishPickingImage image: UIImage!,
                                                            editingInfo: [NSObject : AnyObject]!) {
        let pageController = self.Target! as! PageAppointmentViewController
        
        let img = UIImageView(image: image)
        pageController.BodyView!.AddImage(img)

        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    public func CreateAppointmentSuccess(data: NSDictionary?) {
        print("appointment success")
        let pageController = self.Target! as! PageAppointmentViewController
        pageController.Loading?.Hide()
        self.NavController!.popViewControllerAnimated(true)
    }
    
    public func CreateAppointmentError(err: NSError) {
        YMPageModalMessage.ShowErrorInfo("网络错误，请稍后再试！", nav: self.NavController!)
    }
    
    public func DoAppointment(_: YMButton) {
        let pageController = self.Target! as! PageAppointmentViewController
        let uploadData = pageController.VerifyInput()
        
        if(nil != uploadData) {
            pageController.Loading?.Show()
            ApiUtility?.YMCreateNewAppointment(uploadData!)
        }
    }
    
    public func GoToSelectTime(_: UIGestureRecognizer) {
        if(nil == PageAppointmentViewController.SelectedDoctor) {
            YMPageModalMessage.ShowNormalInfo("请先选择医生！", nav: self.NavController!, callback: { (_) in
                self.DoJump(YMCommonStrings.CS_PAGE_APPOINTMENT_SELECT_DOCTOR_NAME)
            })
        } else {
            self.DoJump(YMCommonStrings.CS_PAGE_APPOINTMENT_SELECT_TIME_NAME)
        }
    }
    
}



















