//
//  PaperCardPreviewActions.swift
//  YiMai
//
//  Created by Wang Huaiyu on 16/9/24.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PaperCardPreviewActions: PageJumpActions {
    var SubmitApi: YMAPIUtility!
    var RequireCardApi: YMAPIUtility!
    var TargetView: PaperCardPreviewBodyView!
    
    var UpdatedUserInfo = [String: AnyObject]()
    
    override func ExtInit() {
        super.ExtInit()
        
        SubmitApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_SUBMIT_PAPER_CARD_REQUIRE, success: SubmitSuccess, error: SubmitError)
        RequireCardApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_PAPER_CARD_REQUIRE, success: ReqSuccess, error: ReqError)
        
        TargetView = Target as! PaperCardPreviewBodyView
    }
    
    func ReqSuccess(data: NSDictionary?) {
        TargetView.FullPageLoading.Hide()
        YMVar.MyUserInfo = UpdatedUserInfo
        YMVar.MyUserInfo["application_card"] = "1"
        PaperCardPreviewBodyView.AddressInfo.removeAll()
        JumpBack()
    }
    
    func ReqError(_: NSError) {
        TargetView.FullPageLoading.Hide()
        YMPageModalMessage.ShowErrorInfo("网络故障，请稍后再试。", nav: self.NavController!)
    }
    
    func SubmitSuccess(data: NSDictionary?) {
        if(nil == data) {
            YMPageModalMessage.ShowErrorInfo("网络故障，请稍后再试。", nav: self.NavController!)
            return
        }
        UpdatedUserInfo = data!["data"] as! [String: AnyObject]
        RequireCardApi.YMRequirePaperCard()
    }
    
    func SubmitError(_: NSError) {
        YMPageModalMessage.ShowErrorInfo("网络故障，请稍后再试。", nav: self.NavController!)
    }
    
    func JumpBack() {
        let controllers = self.NavController!.viewControllers
        let targetController = controllers[controllers.count - 3]
        self.NavController?.popToViewController(targetController, animated: true)
    }
    
    func ConfirmTouched(_: YMButton) {
        TargetView.FullPageLoading.Show()
        SubmitApi.YMChangeUserInfo([
            "address": PaperCardPreviewBodyView.AddressInfo["address"]!,
            "addressee": PaperCardPreviewBodyView.AddressInfo["addressee"]!,
            "receive_phone": PaperCardPreviewBodyView.AddressInfo["receive_phone"]!
            ])
    }
}











