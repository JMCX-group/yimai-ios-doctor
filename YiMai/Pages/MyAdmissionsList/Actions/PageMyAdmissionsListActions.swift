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
        let realData = data!["data"]!
        PageMyAdmissionsListViewController.CompletedAdmissions = realData["completed"]! as! [[String:AnyObject]]
        PageMyAdmissionsListViewController.WaitCompletedAdmissions = realData["wait_complete"]! as! [[String:AnyObject]]
        PageMyAdmissionsListViewController.WaitReplyAdmissions = realData["wait_reply"]! as! [[String:AnyObject]]
        
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
    
    public func AdmissionTouched(sender: UIGestureRecognizer) {
        let controller = self.Target! as! PageMyAdmissionsListViewController
    }
}






