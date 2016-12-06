//
//  PagePersonalPasswordResetActions.swift
//  YiMai
//
//  Created by ios-dev on 16/6/19.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

public class PagePersonalPasswordResetActions: PageJumpActions {
    private var ChangePwdApi: YMAPIUtility? = nil
    private var targetView: PagePersonalPasswordResetBodyView? = nil
    
    override func ExtInit() {
        ChangePwdApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_CHANGE_PASSWORD,
                                    success: ChangePwdSuccess, error: ChangePwdError)
        
        targetView = Target as? PagePersonalPasswordResetBodyView
    }
    
    private func ChangePwdSuccess(data: NSDictionary?) {
        targetView?.Loading?.Hide()
        
        let input = targetView?.GetInput()
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_USER_ORG_PASSWORD, data: input!["new"]!)
        self.NavController!.popViewControllerAnimated(true)
    }
    
    private func ChangePwdError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        
        YMPageModalMessage.ShowErrorInfo("网络故障，请稍后再试！", nav: self.NavController!)
        targetView?.Loading?.Hide()
    }
    
    public func StartChange(_: YMButton) {
        let orgPassword = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_ORG_PASSWORD) as! String
        let input = targetView?.GetInput()
        
        if(orgPassword != input!["org"]){
            YMPageModalMessage.ShowErrorInfo("原始密码不正确，请重新输入！", nav: self.NavController!)
            return
        }
        targetView?.Loading?.Show()

        ChangePwdApi?.YMChangeUserInfo(["password": input!["new"]!])
    }
}