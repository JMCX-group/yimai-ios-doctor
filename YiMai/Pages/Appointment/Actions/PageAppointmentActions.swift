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
import AFNetworking

public class PageAppointmentActions: PageJumpActions, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var ApiUtility: YMAPIUtility? = nil
    var UploadApi: YMAPIUtility? = nil
    var TargetController: PageAppointmentViewController? = nil
    
    var AppointmentId = ""
    var ImageForUpload: UIImage? = nil
    var PhotoIndex = 0

    override func ExtInit() {
        super.ExtInit()
        ApiUtility = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_CREATE_NEW_APPOINTMENT,
                                  success: CreateAppointmentSuccess,
                                  error: CreateAppointmentError)
        
        UploadApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_UPLOAD_PHOTO_APPOINTMENT,
                                 success: UploadSuccess,
                                 error: UploadError)
        
        TargetController = self.Target as? PageAppointmentViewController
    }
    
    public func UploadBlockBuilder(formData: AFMultipartFormData) {
        let filename = "\(PhotoIndex).jpg"
        let imgData = YMLayout.GetScaledImageData(ImageForUpload!)

        formData.appendPartWithFileData(imgData, name: "img", fileName: filename, mimeType: "image/jpeg")
    }
    
    public func UploadSuccess(data: NSDictionary?) {
        print("image \(PhotoIndex) uploaded")
        PhotoIndex += 1
        if(PhotoIndex < TargetController!.BodyView!.PhotoArray.count) {
            ImageForUpload = TargetController!.BodyView!.PhotoArray[PhotoIndex]
            UploadApi?.YMUploadAddmissionPhotos(["id": AppointmentId], blockBuilder: self.UploadBlockBuilder)
        } else {
            TargetController?.Loading?.Hide()
            self.NavController!.popViewControllerAnimated(true)
        }
    }
    
    public func UploadError(err: NSError) {
        YMAPIUtility.PrintErrorInfo(err)
        TargetController?.Loading?.Hide()
        self.NavController!.popViewControllerAnimated(true)

//        YMPageModalMessage.ShowErrorInfo("网络错误，请稍后再试！", nav: self.NavController!)
//        self.NavController!.popViewControllerAnimated(true)

    }
    
    public func PhotoScrollLeft(sender: UIGestureRecognizer) {
        
    }
    
    public func PhotoScrollRight(sender: UIGestureRecognizer) {
        
    }
    
    public func PhotoSelect(sender: UIGestureRecognizer) {
        let contacts: PrivateResource = PrivateResource.Photos
        
        proposeToAccess(contacts, agreed: {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
//                let imagePicker = UIImagePickerController()
//                imagePicker.sourceType = .PhotoLibrary
//                imagePicker.delegate = self
//                
//                self.NavController!.presentViewController(imagePicker, animated: true, completion: nil)
                
                self.TargetController?.BodyView!.ShowPhotoPicker()
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
        
        let img = UIImageView(image: image)
        TargetController?.BodyView!.AddImage(img)

        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    public func CreateAppointmentSuccess(data: NSDictionary?) {

        AppointmentId = "\(data!["id"]!)"
        if(PhotoIndex < TargetController!.BodyView!.PhotoArray.count) {
            ImageForUpload = TargetController!.BodyView!.PhotoArray[PhotoIndex]
            UploadApi?.YMUploadAddmissionPhotos(["id": AppointmentId], blockBuilder: self.UploadBlockBuilder)
        }
        
        TargetController?.Loading?.Hide()
        YMChatViewController.SendMsg = ["appointmentId": AppointmentId]
        self.NavController?.popViewControllerAnimated(true)
    }
    
    public func CreateAppointmentError(err: NSError) {
        YMAPIUtility.PrintErrorInfo(err)
        TargetController?.Loading?.Hide()
        YMPageModalMessage.ShowErrorInfo("网络错误，请稍后再试！", nav: self.NavController!)
    }
    
    public func DoAppointment(_: YMButton) {
        let uploadData = TargetController!.VerifyInput()
        
        if(nil != uploadData) {
            TargetController?.Loading?.Show()
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
    
    public func ShowPhotos(gr: UIGestureRecognizer) {
        let cellOptView = gr.view as! YMTouchableView
        print(cellOptView.UserObjectData)
    }
    
}



















