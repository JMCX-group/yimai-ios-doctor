//
//  PageChangePhoneActions.swift
//  YiMai
//
//  Created by why on 2016/12/25.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

class PageChangePhoneActions: PageJumpActions {
    var TargetView: PageChangePhoneBodyView!
    var ChangePhoneApi: YMAPIUtility!
    var GetVerifyCodeApi: YMAPIUtility!
    
    override func ExtInit() {
        super.ExtInit()
        
        TargetView = Target as! PageChangePhoneBodyView
        ChangePhoneApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_CHANGE_PHONE, success: ChangePhoneSuccess, error: ChangePhoneError)
        GetVerifyCodeApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_VERIFY_CODE + "-fromChangePhone", success: GetVerifyCodeSuccess, error: GetVerifyCodeError)
    }
    
    func GetVerifyCodeSuccess(data: NSDictionary?) {
        if(nil == data) {
            return
        }
        let realData = data! as! [String: AnyObject]
        let verifyCode = YMVar.GetStringByKey(realData, key: "debug")
        TargetView.VerifyCodeInput.text = verifyCode
    }
    
    func GetVerifyCodeError(error:NSError) {
        YMPageModalMessage.ShowErrorInfo("网络错误，请稍后再试", nav: NavController!)
        TargetView.StopCountDown()
        TargetView.EnableGetVerifyCodeBtn()
    }

    func ChangePhoneSuccess(_: NSDictionary?) {
        YMPageModalMessage.ShowNormalInfo("绑定新手机成功，请重新登录。", nav: NavController!) { (_) in
            YMDelay(0.1, closure: {
                YMCoreDataEngine.Clear()
                YMLocalData.ClearLogin()
                YMVar.Clear()
                YMBackgroundRefresh.Stop()
                //        YMAPICommonVariable.ClearCallbackMap()
                PagePersonalIntroEditViewController.IntroText = ""
                PagePersonalNameEditViewController.UserName = ""
                PageRegisterPersonalInfoViewController.NeedInit = true
                PagePersonalIDNumInputBodyView.IDNum = ""
                self.TargetView.FullPageLoading.Hide()
                self.DoJump(YMCommonStrings.CS_PAGE_LOGIN_NAME)
            })
        }
    }

    func ChangePhoneError(error: NSError) {
        TargetView.FullPageLoading.Hide()

        let response = error.userInfo["com.alamofire.serialization.response.error.response"]!
        let errData = error.userInfo["com.alamofire.serialization.response.error.data"] as? NSData
        let errStr = NSString(data: errData!, encoding: NSUTF8StringEncoding) as! String
        let errMsg = YMVar.TryToGetDictFromJsonStringData(errStr)
        
        var errMsgStr = "网络错误，请稍后再试"
        let httpCode = response.statusCode
        if(httpCode >= 400 && httpCode < 500) {
            errMsgStr = errMsg!["message"] as! String
        }

        YMPageModalMessage.ShowErrorInfo(errMsgStr, nav: NavController!) {(_) in
            self.TargetView.StopCountDown()
            self.TargetView.EnableGetVerifyCodeBtn()
        }
    }
    
    func GetVerifyCodeTouched(sender: YMButton) {
        //获取验证码
        let phone = TargetView.PhoneInput.text
        if(!YMValueValidator.IsCellPhoneNum(phone)) {
            YMPageModalMessage.ShowErrorInfo("请输入合法手机号", nav: NavController!)
            return
        }
        TargetView.DisableGetVerifyCodeBtnWhenTouchdown()
        
        TargetView.StartCountDown()
        GetVerifyCodeApi.YMGetVerifyCode(["phone": phone!])
    }
    
    func ConfirmChange(sender: YMButton) {
        let phone = TargetView.PhoneInput.text
        if(!YMValueValidator.IsCellPhoneNum(phone)) {
            YMPageModalMessage.ShowErrorInfo("请输入合法手机号", nav: NavController!) { (_) in
                self.TargetView.PhoneInput.becomeFirstResponder()
            }

            return
        }
        
        let code = TargetView.VerifyCodeInput.text
        if(YMValueValidator.IsBlankString(code)) {
            YMPageModalMessage.ShowErrorInfo("请输入验证码", nav: NavController!) { (_) in
                self.TargetView.VerifyCodeInput.becomeFirstResponder()
            }
            return
        }

        TargetView.FullPageLoading.Show()
        ChangePhoneApi.YMResetUserPhone(["phone": phone!, "verify_code": code!])
    }
}












