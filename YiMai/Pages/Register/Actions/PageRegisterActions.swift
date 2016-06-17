//
//  PageRegisterActions.swift
//  YiMai
//
//  Created by why on 16/4/19.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

public class PageRegisterActions: PageJumpActions {
    private var TargetBodyView : PageRegisterBodyView? = nil
    private var ApiUtility: YMAPIUtility? = nil
    private var VerifyCodeEnableCounter:Int = 0
    override func ExtInit() {
        ApiUtility = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_VERIFY_CODE,
                                  success: self.GetVerifyCodeSuccess,
                                  error: self.GetVerifyCodeError)
    }
    
    private func GetVerifyCodeError(error: NSError){
        let errInfo = JSON(data: error.userInfo["com.alamofire.serialization.response.error.data"] as! NSData)
        print(errInfo)
    }
    
    private func GetVerifyCodeSuccess(data: NSDictionary?) {
        let realData = data! as! [String: AnyObject]
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_REG_VERIFY_CODE, data: realData["debug"]!)
        
        //TODO: this is a debug line
        TargetBodyView!.VerifyCodeInput?.text = "\(realData["debug"]!)"
    }
    
    convenience init(navController: UINavigationController, bodyView: PageRegisterBodyView) {
        self.init()
        self.TargetBodyView = bodyView
        self.NavController = navController
        ExtInit()
    }

    public func AgreementButtonTouched(sender: YMButton) {
        TargetBodyView?.ToggleAgreementStatus()
    }

    public func AgreementImageTouched(sender: UITapGestureRecognizer) {
        TargetBodyView?.ToggleAgreementStatus()
    }
    
    public func NextStep(sender: YMButton) {
        if(nil != TargetBodyView?.VerifyInput()){
            DoJump(sender.UserStringData)            
        }
    }
    
    public func VerifyCodeHandler(data: AnyObject?, queue:NSOperationQueue) -> Bool {
        self.VerifyCodeEnableCounter = self.VerifyCodeEnableCounter + 1
        if(0 == self.VerifyCodeEnableCounter % 10) {
            queue.addOperationWithBlock({
                let title = "重新获取(\(60 - self.VerifyCodeEnableCounter/10))"
                self.TargetBodyView!.GetVerifyCodeButton?.setTitle(title, forState: UIControlState.Disabled)
            })
        }
        
        if(600 < self.VerifyCodeEnableCounter) {
            queue.addOperationWithBlock({
                self.TargetBodyView!.GetVerifyCodeButton?.setTitle("", forState: UIControlState.Disabled)
                self.TargetBodyView!.EnableGetVerifyCodeButton()
                self.VerifyCodeEnableCounter = 0
            })
            return true
        }
        return false
    }
    
    public func GetVerifyCode(sender: YMButton) {
        let data = TargetBodyView?.VerifyPhoneBeforeGetCode()
        if(nil == data){return}
        ApiUtility?.YMGetVerifyCode(data!)
        self.TargetBodyView!.DisableGetVerifyCodeButton()
        let dataHandler = YMCoreMemDataOnceHandler(handler: self.VerifyCodeHandler)
        YMCoreDataEngine.SetDataOnceHandler(YMModuleStrings.MODULE_NAME_REG_VERIFY_CODE, handler: dataHandler)
    }
}




















