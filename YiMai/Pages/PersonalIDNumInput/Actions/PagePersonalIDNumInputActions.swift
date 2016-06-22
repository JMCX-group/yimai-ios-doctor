//
//  PagePersonalIDNumInputActions.swift
//  YiMai
//
//  Created by why on 16/6/20.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PagePersonalIDNumInputActions: PageJumpActions {
    private var targetView: PagePersonalIDNumInputBodyView? = nil
    private var IDNumApi: YMAPIUtility? = nil
    
    override func ExtInit() {
        targetView = self.Target as? PagePersonalIDNumInputBodyView
        IDNumApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_SET_ID_NUM, success: SetSuccess, error: SetError)
    }
    
    private func SetSuccess(data: NSDictionary?) {
        targetView?.Loading?.Hide()
        
        let realData = data!
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_USER_INFO, data: realData["data"]!)
        YMVar.MyUserInfo = realData["data"]! as! [String : AnyObject]
        self.NavController?.popViewControllerAnimated(true)
    }
    
    private func SetError(error: NSError) {
        
    }
    
    public func SetIDNum(_: YMButton) {
        let num = targetView!.GetIDNum()
        targetView?.Loading?.Show()
        IDNumApi?.YMChangeUserInfo(["ID_number": num])
    }

}