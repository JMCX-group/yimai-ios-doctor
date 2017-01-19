//
//  PageAddBankcardActions.swift
//  YiMai
//
//  Created by why on 2017/1/10.
//  Copyright © 2017年 why. All rights reserved.
//

import Foundation
import Neon

class PageAddBankcardActions: PageJumpActions {
    var TargetView: PageAddBankcardBodyView!
    var AddApi: YMAPIUtility!

    
    override func ExtInit() {
        super.ExtInit()
        
        TargetView = Target as! PageAddBankcardBodyView
        AddApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_ADD_BANKCARD, success: AddCardSuccess, error: AddCardError)
    }
    
    func AddCardSuccess(data: NSDictionary?) {
        TargetView.FullPageLoading.Hide()
        NavController?.popViewControllerAnimated(true)
    }
    
    func AddCardError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        YMPageModalMessage.ShowErrorInfo("网络错误，请稍后再试", nav: NavController!)
        TargetView.FullPageLoading.Hide()
    }

    func SubmitTouched(sender: YMButton) {
        let ret = TargetView.VerifyInput()
        if(nil != ret) {
            YMPageModalMessage.ShowErrorInfo(ret!, nav: NavController!)
        } else {
            let info = TargetView.GetInfo()
            TargetView.FullPageLoading.Show()
            AddApi.YMAddBankcard(info)
        }
    }
}






































