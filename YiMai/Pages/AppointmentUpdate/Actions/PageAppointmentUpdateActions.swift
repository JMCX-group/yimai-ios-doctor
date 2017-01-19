//
//  PageAppointmentUpdateActions.swift
//  YiMai
//
//  Created by why on 16/5/27.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit
import Proposer
import AFNetworking

public class PageAppointmentUpdateActions: PageJumpActions, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var ApiUtility: YMAPIUtility? = nil
    var TargetController: PageAppointmentUpdateViewController? = nil
    
    var AppointmentId = ""
    var ImageForUpload: UIImage? = nil
    var PhotoIndex = 0

    override func ExtInit() {
        super.ExtInit()
        ApiUtility = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_UPDATE_APPOINTMENT_DETAIL,
                                  success: AppointmentUpdateSuccess,
                                  error: AppointmentUpdateError)
        
        TargetController = self.Target as? PageAppointmentUpdateViewController
    }

    public func PhotoScrollLeft(sender: UIGestureRecognizer) {
        
    }
    
    public func PhotoScrollRight(sender: UIGestureRecognizer) {
        
    }
    
    public func AppointmentUpdateSuccess(data: NSDictionary?) {
        TargetController?.Loading?.Hide()
        NavController?.popViewControllerAnimated(true)
    }
    
    public func AppointmentUpdateError(err: NSError) {
        YMAPIUtility.PrintErrorInfo(err)
        TargetController?.Loading?.Hide()
        NavController?.popViewControllerAnimated(true)
//        YMPageModalMessage.ShowErrorInfo("网络错误，请稍后再试！", nav: self.NavController!)
    }
    
    public func DoAppointment(_: YMButton) {
        let uploadData = TargetController!.VerifyInput()
        
        if(nil != uploadData) {
            TargetController?.Loading?.Show()
            print([
                "id": PageAppointmentDetailViewController.AppointmentID,
                "doctor": "\(uploadData!["doctor"]!)"
                ])
            ApiUtility?.YMUpdateAppointmentDetail([
                    "id": PageAppointmentDetailViewController.AppointmentID,
                    "doctor": "\(uploadData!["doctor"]!)"
                ])
        }
    }
    
    public func GoToSelectTime(_: UIGestureRecognizer) {
    }

    public func ShowPhotos(gr: UIGestureRecognizer) {
        let _ = gr.view as! YMTouchableView
    }
    
}



















