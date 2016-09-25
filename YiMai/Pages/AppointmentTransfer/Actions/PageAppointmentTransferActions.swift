//
//  PageAppointmentTransferActions.swift
//  YiMai
//
//  Created by why on 16/5/27.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit
import Proposer
import AFNetworking

public class PageAppointmentTransferActions: PageJumpActions, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var ApiUtility: YMAPIUtility? = nil
    var TargetController: PageAppointmentTransferViewController? = nil
    
    var AppointmentId = ""
    var ImageForUpload: UIImage? = nil
    var PhotoIndex = 0

    override func ExtInit() {
        super.ExtInit()
        ApiUtility = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_CREATE_NEW_APPOINTMENT,
                                  success: AppointmentTransferSuccess,
                                  error: AppointmentTransferError)
        
        TargetController = self.Target as? PageAppointmentTransferViewController
    }

    public func PhotoScrollLeft(sender: UIGestureRecognizer) {
        
    }
    
    public func PhotoScrollRight(sender: UIGestureRecognizer) {
        
    }
    
    public func AppointmentTransferSuccess(data: NSDictionary?) {
    }
    
    public func AppointmentTransferError(err: NSError) {
        YMAPIUtility.PrintErrorInfo(err)
        TargetController?.Loading?.Hide()
        YMPageModalMessage.ShowErrorInfo("网络错误，请稍后再试！", nav: self.NavController!)
    }
    
    public func DoAppointment(_: YMButton) {
        let uploadData = TargetController!.VerifyInput()
        
        if(nil != uploadData) {
            TargetController?.Loading?.Show()
            ApiUtility?.YMAppointmentTransfer([
                    "id": PageAppointmentAcceptBodyView.AppointmentID,
                    "doctor_id": uploadData!["doctor"]!
                ])
        }
    }
    
    public func GoToSelectTime(_: UIGestureRecognizer) {
    }

    public func ShowPhotos(gr: UIGestureRecognizer) {
        let cellOptView = gr.view as! YMTouchableView
        print(cellOptView.UserObjectData)
    }
    
}



















