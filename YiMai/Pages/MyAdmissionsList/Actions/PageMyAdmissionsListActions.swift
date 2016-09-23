//
//  PageMyAdmissionsListActions.swift
//  YiMai
//
//  Created by why on 16/4/28.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class AdmissionsBackendProgress: NSObject {
    var AdmissionsListApi: YMAPIUtility? = nil
    
    public func ApiError(error: NSError){
        print(error)
    }
    
    init(success: YMAPIJsonCallback) {
        super.init()
        self.AdmissionsListApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_ADMISSIONS_LIST,
            success: success, error: self.ApiError)
    }
    
    public func DoApi() {
        AdmissionsListApi?.YMGetAdmissionsList()
    }
}

public class PageMyAdmissionsListActions: PageJumpActions{
    var Api: AdmissionsBackendProgress? = nil
    
    override func ExtInit() {
        Api = AdmissionsBackendProgress(success: self.AdmissionsListSuccess)
    }
    
    private func AdmissionsListSuccess(data: NSDictionary?) {
        if(nil != data) {
            let realData = data!["data"]!
            PageMyAdmissionsListViewController.CompletedAdmissions = realData["completed"]! as! [[String:AnyObject]]
            PageMyAdmissionsListViewController.WaitCompletedAdmissions = realData["wait_complete"]! as! [[String:AnyObject]]
            PageMyAdmissionsListViewController.WaitReplyAdmissions = realData["wait_reply"]! as! [[String:AnyObject]]
        }
 
        
        let controller = self.Target! as! PageMyAdmissionsListViewController
        controller.HideLoading()
        
        controller.BodyView!.ReLoad()
    }
    
    public func GetAdmissionInfo() {
        Api?.DoApi()
    }

    public func ClearMessageList(sender: YMButton) {
        print("clear touched")
    }
    
    public func ShowComplete(sender: UIGestureRecognizer) {
        let controller = self.Target! as! PageMyAdmissionsListViewController
        
        controller.BodyView?.ShowCompletePanel()
    }
    
    public func ShowWaitComplete(sender: UIGestureRecognizer) {
        let controller = self.Target! as! PageMyAdmissionsListViewController
        
        controller.BodyView?.ShowWaitCompletePanel()

    }
    
    public func ShowWaitReply(sender: UIGestureRecognizer) {
        let controller = self.Target! as! PageMyAdmissionsListViewController
        
        controller.BodyView?.ShowWaitReplyPanel()

    }
    
    public func AdmissionCompleteTouched(sender: UIGestureRecognizer) {
        let _ = self.Target! as! PageMyAdmissionsListViewController
        let cell = sender.view as! YMTouchableView
        let cellData = cell.UserObjectData as! [String: AnyObject]
        
        let id = "\(cellData["id"]!)"
        
        PageAppointmentDetailViewController.AppointmentID = id
        DoJump(YMCommonStrings.CS_PAGE_APPOINTMENT_DETAIL_NAME)
    }
    
    public func AdmissionReplyTouched(sender: UIGestureRecognizer) {
        let _ = self.Target! as! PageMyAdmissionsListViewController
        let cell = sender.view as! YMTouchableView
        let cellData = cell.UserObjectData as! [String: AnyObject]
        
        let id = "\(cellData["id"]!)"
        let time = "\(cellData["time"]!)"
        
        PageAppointmentAcceptBodyView.AppointmentID = id
        PageAppointmentAcceptBodyView.TimeInfo = time
        DoJump(YMCommonStrings.CS_PAGE_APPOINTMENT_ACCEPT_NAME)
    }
    
    public func AdmissionWaitCompleteTouched(sender: UIGestureRecognizer) {
        let _ = self.Target! as! PageMyAdmissionsListViewController
        let cell = sender.view as! YMTouchableView
        let cellData = cell.UserObjectData as! [String: AnyObject]
        
        let id = "\(cellData["id"]!)"
        let time = "\(cellData["time"]!)"
        
        PageAppointmentProcessingBodyView.AppointmentID = id
        PageAppointmentProcessingBodyView.TimeInfo = time
        DoJump(YMCommonStrings.CS_PAGE_APPOINTMENT_PROCESSING_NAME)
    }
}






