//
//  PageWalletInfoActions.swift
//  YiMai
//
//  Created by superxing on 16/11/8.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

class PageWalletInfoActions: PageJumpActions {
    var TargetView: PageWalletInfoBodyView!
    var InfoApi: YMAPIUtility!
    
    override func ExtInit() {
        super.ExtInit()
        
        InfoApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_WALLET_INFO, success: GetInfoSuccess, error: GetInfoError)
        
        TargetView = Target as! PageWalletInfoBodyView
    }
    
    func GetInfoSuccess(data: NSDictionary?) {
        if(nil == data) {
            return
        }

        let realData = data!["data"] as! [String: AnyObject]

        TargetView.LoadData(realData)
    }
    
    func GetInfoError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
    }
    
    func ShowCashDetail(gr: UIGestureRecognizer) {
        DoJump(YMCommonStrings.CS_PAGE_MY_WALLET_RECORD)
    }
}







