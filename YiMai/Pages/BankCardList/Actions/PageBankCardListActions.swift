//
//  PageBankCardListActions.swift
//  YiMai
//
//  Created by why on 2017/1/10.
//  Copyright © 2017年 why. All rights reserved.
//

import Foundation
import Neon

class PageBankCardListActions: PageJumpActions {
    var TargetView: PageBankCardListBodyView!
    var ListApi: YMAPIUtility!
    var DelApi: YMAPIUtility!
    
    override func ExtInit() {
        super.ExtInit()

        TargetView = Target as! PageBankCardListBodyView
        
        ListApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_BANKCARD_LIST, success: GetListSuccess, error: GetListError)
        DelApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_DEL_BANKCARD, success: DelCardSuccess, error: DelError)
    }
    
    func GetListSuccess(data: NSDictionary?) {
        let realBody = data!["data"] as? [[String: AnyObject]]

        TargetView.DrawFullBody(realBody)
        TargetView.FullPageLoading.Hide()
    }
    
    func GetListError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        YMPageModalMessage.ShowErrorInfo("网络错误，请稍后再试", nav: NavController!)
        TargetView.FullPageLoading.Hide()
    }
    
    func DelCardSuccess(data: NSDictionary?) {
        let realBody = data!["data"] as? [[String: AnyObject]]
        TargetView.DrawFullBody(realBody)
        TargetView.FullPageLoading.Hide()
    }
    
    func DelError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        YMPageModalMessage.ShowErrorInfo("网络错误，请稍后再试", nav: NavController!)
        TargetView.FullPageLoading.Hide()
    }
    
    func AddCardTouched(_: UIGestureRecognizer) {
        DoJump(YMCommonStrings.CS_PAGE_ADD_BANKCARD_NAME)
    }
}


























