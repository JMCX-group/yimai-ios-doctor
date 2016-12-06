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
        if(nil == data) {
            YMPageModalMessage.ShowNormalInfo("网络通讯故障，请稍后再试。", nav: self.NavController!, callback: GoBack)
            return
        }
        let data = data!["user"] as! [String: AnyObject]
        
        TargetView.LoadUserInfo(data)
    }
    
    func GoBack(_: UIAlertAction) {
        if(nil == PageAddFriendInfoCardViewController.BacktoController) {
            self.NavController?.popViewControllerAnimated(true)
        } else {
            self.NavController?.popToViewController(PageAddFriendInfoCardViewController.BacktoController!, animated: true)
        }
    }
    
    func GetDocInfoFailed(error: NSError) {
        YMPageModalMessage.ShowNormalInfo("网络通讯故障，请稍后再试。", nav: self.NavController!, callback: GoBack)
    }
    
    func AddSuccess(data: NSDictionary?) {
        TargetView.Loading.Hide()

        if(nil == PageAddFriendInfoCardViewController.BacktoController) {
            self.NavController?.popViewControllerAnimated(true)
        } else {
            self.NavController?.popToViewController(PageAddFriendInfoCardViewController.BacktoController!, animated: true)
        }
    }
    
    func AddFailed(error: NSError) {
        TargetView.Loading.Hide()
        YMPageModalMessage.ShowNormalInfo("网络通讯故障，请稍后再试。", nav: self.NavController!)
    }
    
    func SubmitTouched(sender: YMButton) {
        TargetView.Loading.Show()
        AddFriendApi.YMAddFriendById(PageAddFriendInfoCardBodyView.DoctorID)
    }
}