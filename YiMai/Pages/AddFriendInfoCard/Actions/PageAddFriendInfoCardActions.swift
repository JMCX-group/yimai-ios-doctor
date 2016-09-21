//
//  PageAddFriendInfoCardActions.swift
//  YiMai
//
//  Created by superxing on 16/9/21.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PageAddFriendInfoCardActions: PageJumpActions {
    var TargetView: PageAddFriendInfoCardBodyView!
    var GetDocApi: YMAPIUtility!
    var AddFriendApi: YMAPIUtility!
    
    override func ExtInit() {
        super.ExtInit()
        
        TargetView = Target as! PageAddFriendInfoCardBodyView
        GetDocApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_DOCTOR_BY_ID + "-fromQRCard",
                                 success: GetDocInfoSuccess, error: GetDocInfoFailed)
        
        AddFriendApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_ADD_FRIEND + "-fromQRCard",
                                    success: AddSuccess, error: AddFailed)
    }
    
    func GetDocInfoSuccess(data: NSDictionary?) {
        print(data)
        if(nil == data) {
            YMPageModalMessage.ShowNormalInfo("网络通讯故障，请稍后再试。", nav: self.NavController!, callback: GoBack)
            return
        }
        let data = data!["user"] as! [String: AnyObject]
        
        TargetView.LoadUserInfo(data)
    }
    
    func GoBack(_: UIAlertAction) {
        self.NavController?.popViewControllerAnimated(true)
    }
    
    func GetDocInfoFailed(error: NSError) {
        YMPageModalMessage.ShowNormalInfo("网络通讯故障，请稍后再试。", nav: self.NavController!, callback: GoBack)
    }
    
    func AddSuccess(data: NSDictionary?) {
        self.NavController?.popViewControllerAnimated(true)
    }
    
    func AddFailed(error: NSError) {
        YMPageModalMessage.ShowNormalInfo("网络通讯故障，请稍后再试。", nav: self.NavController!)
    }
    
    func SubmitTouched(sender: YMButton) {
        AddFriendApi.YMAddFriendById(PageAddFriendInfoCardBodyView.DoctorID)
    }
}