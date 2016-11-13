//
//  PageWalletRecordActions.swift
//  YiMai
//
//  Created by old-king on 16/11/13.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

class PageWalletRecordActions: PageJumpActions {
    var TargetView: PageWalletRecordBodyView!
    var RecordApi: YMAPIUtility!
    
    override func ExtInit() {
        super.ExtInit()
        
        TargetView = Target as! PageWalletRecordBodyView
        RecordApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_WALLET_RECORD, success: GetRecordSuccess, error: GetRecordError)
    }

    func GetRecordSuccess(data: NSDictionary?) {
        if(nil == data) {
            return
        }
        
        let realData = data!["data"] as! [[String: AnyObject]]
        TargetView.LoadData(realData)
    }
    
    func GetRecordError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
    }
}





