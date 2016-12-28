//
//  PagePersonalAccountSettingBodyView.swift
//  YiMai
//
//  Created by ios-dev on 16/6/19.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PagePersonalAccountSettingBodyView: PageBodyView {
    private let AccountPhone = UILabel()
    private let AccountBindPhone = UILabel()
    private let AuthLabel = UILabel()
    private let IDNum = UILabel()
    private let EMail = UILabel()
    
    private var AuthButton: YMTouchableView? = nil
    private var IDNumButton: YMTouchableView? = nil
    private var bindEmailButton: YMTouchableView? = nil
    
    private var SettingActions: PagePersonalAccountSettingActions? = nil
    private let DefaultButtonGroupPadding = 70.LayoutVal()
    private let ExtButtonInfoPadding = 80.LayoutVal()
    private let ExtButtonInfoWidth = 400.LayoutVal()
    
    private var Loading: YMPageLoading? = nil
    
    private var EmailUpdateFlag = false
    
    override func ViewLayout() {
        super.ViewLayout()
        
        SettingActions = PagePersonalAccountSettingActions(navController: self.NavController!, target: self)
        
        DrawAccountBasicInfo()
        DrawExtInfo()
        DrawLoginOperating()
        
        Loading = YMPageLoading(parentView: BodyView)
        
//        let userData = YMVar.MyUserInfo //YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_INFO)
        
        Loading?.Show()
        LoadData()
//            YMCoreDataEngine.SetDataOnceHandler(YMModuleStrings.MODULE_NAME_MY_ACCOUNT_SETTING,
//                                                handler: YMCoreMemDataOnceHandler(handler: LoadData))
    }
    
    public func ReloadData() {
        let userData = YMVar.MyUserInfo //YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_INFO)
        DrawData(userData)
    }
    
    func AddEmail(email: String) {
        
        if(YMValueValidator.IsEmptyString(email)) {
            //Do Nothing
            EmailUpdateFlag = false
        } else if(!YMValueValidator.IsEmail(email)) {
            YMPageModalMessage.ShowErrorInfo("无效的邮箱", nav: self.NavController!)
            EmailUpdateFlag = false
            return
        } else {
            EMail.text = email
            EmailUpdateFlag = true
        }
        
//        AppendExtInfo(EMail, parent: bindEmailButton!, fontColor: YMColors.FontBlue, fontSize: 24.LayoutVal())
        FullPageLoading.Show()
        SettingActions!.SettingApi.YMChangeUserInfo(["email": email])
    }
    
    func LoadData() {
        let userData = YMVar.MyUserInfo //YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_INFO)
        
        self.Loading?.Hide()
        self.DrawData(userData)
    }
    
//    private func LoadData(data: AnyObject?, mainQueue: NSOperationQueue) -> Bool {
//        let userData = YMVar.MyUserInfo //YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_INFO)
//        
//        self.Loading?.Hide()
//        self.DrawData(userData)
//
//        return true

//        if(nil == userData) {
//            return false
//        } else {
//            mainQueue.addOperationWithBlock({ 
//                self.Loading?.Hide()
//                self.DrawData(userData!)
//            })
//
//            return true
//        }
//    }
    
    private func DrawData(data: AnyObject) {
        let realData = data as! [String: AnyObject]
        AccountPhone.text = "\(realData["phone"]!)"
        AccountBindPhone.text = "需要重新登录"
        
        let email = YMVar.GetStringByKey(realData, key: "email")

        let authTextMap = ["0":"已认证", "1":"尚未认证"]
        
        let isAuth = realData["is_auth"]! as! String
        let authString = authTextMap[realData["is_auth"]! as! String]
        AuthLabel.text = authString
        
        AuthButton?.UserStringData = YMCommonStrings.CS_PAGE_PERSONAL_DOCTOR_AUTH_NAME

        if("1" == isAuth) {
            AuthButton?.UserStringData = YMCommonStrings.CS_PAGE_PERSONAL_DOCTOR_AUTH_NAME
        } else {
//            AuthButton?.hidden = true
        }
        
        if("<null>" == "\(realData["ID_number"]!)") {
            IDNum.text = "尚未填写身份证号码"
        } else {
            IDNum.text = "\(realData["ID_number"]!)"
        }
        
        if(!EmailUpdateFlag) {
            if(YMValueValidator.IsEmptyString(email)) {
                EMail.text = "尚未绑定电子邮箱"
            } else {
                EMail.text = email
            }
//            AppendExtInfo(EMail, parent: bindEmailButton!, fontColor: YMColors.FontBlue, fontSize: 24.LayoutVal())
        } else {
            EmailUpdateFlag = false
        }
    }
    
    private func AppendExtInfo(label: UILabel, parent: UIView, fontColor: UIColor = YMColors.FontGray, fontSize: CGFloat = 28.LayoutVal()){
        parent.addSubview(label)
        label.textColor = fontColor
        label.text = ""
        label.font = YMFonts.YMDefaultFont(fontSize)
        label.textAlignment = NSTextAlignment.Right
        label.anchorToEdge(Edge.Right, padding: ExtButtonInfoPadding, width: ExtButtonInfoWidth, height: fontSize)
    }

    private func DrawAccountBasicInfo(){
        let myAccountButton = YMLayout.GetCommonFullWidthTouchableView(
            BodyView, useObject: SettingActions!, useMethod: PageJumpActions.PageJumpToByViewSenderSel,
            label: UILabel(), text: "我的账号", userStringData: "", fontSize: 28.LayoutVal(), showArrow: false)
        
        AuthButton = YMLayout.GetCommonFullWidthTouchableView(
            BodyView, useObject: SettingActions!, useMethod: "GoToAuthPage:".Sel(),
            label: UILabel(), text: "实名认证")
        
        BodyView.addSubview(myAccountButton)
        BodyView.addSubview(AuthButton!)
        
        myAccountButton.anchorToEdge(Edge.Top, padding: DefaultButtonGroupPadding,
                                     width: YMSizes.PageWidth, height: YMSizes.CommonTouchableViewHeight)
        AppendExtInfo(AccountPhone, parent: myAccountButton)
        
        AuthButton?.align(Align.UnderMatchingLeft, relativeTo: myAccountButton,
                          padding: 0, width: YMSizes.PageWidth, height: YMSizes.CommonTouchableViewHeight)
        AppendExtInfo(AuthLabel, parent: AuthButton!)
    }
    
    private func DrawExtInfo(){
        let bindPhoneButton = YMLayout.GetCommonFullWidthTouchableView(
            BodyView, useObject: SettingActions!, useMethod: PageJumpActions.PageJumpToByViewSenderSel,
            label: UILabel(), text: "绑定新手机号", userStringData: YMCommonStrings.CS_PAGE_PERSONAL_CHANGE_PHONE_NAME)
        AppendExtInfo(AccountBindPhone, parent: bindPhoneButton, fontColor: YMColors.FontGray, fontSize: 24.LayoutVal())
        
        bindEmailButton = YMLayout.GetCommonFullWidthTouchableView(
            BodyView, useObject: SettingActions!, useMethod: "EmailCellTouched:".Sel(),
            label: UILabel(), text: "邮箱地址")
        AppendExtInfo(EMail, parent: bindEmailButton!, fontColor: YMColors.FontBlue, fontSize: 24.LayoutVal())
        
        IDNumButton = YMLayout.GetCommonFullWidthTouchableView(
            BodyView, useObject: SettingActions!, useMethod: PageJumpActions.PageJumpToByViewSenderSel,
            label: UILabel(), text: "身份证号码", userStringData: YMCommonStrings.CS_PAGE_PERSONAL_ID_NUM_INPUT_NAME)
        AppendExtInfo(IDNum, parent: IDNumButton!, fontColor: YMColors.FontBlue, fontSize: 24.LayoutVal())

        BodyView.addSubview(bindPhoneButton)
        BodyView.addSubview(bindEmailButton!)
        BodyView.addSubview(IDNumButton!)
        
        bindPhoneButton.align(Align.UnderMatchingLeft, relativeTo: AuthButton!,
                          padding: DefaultButtonGroupPadding, width: YMSizes.PageWidth, height: YMSizes.CommonTouchableViewHeight)
        
        bindEmailButton!.align(Align.UnderMatchingLeft, relativeTo: bindPhoneButton,
                          padding: 0, width: YMSizes.PageWidth, height: YMSizes.CommonTouchableViewHeight)
        
        IDNumButton?.align(Align.UnderMatchingLeft, relativeTo: bindEmailButton!,
                          padding: 0, width: YMSizes.PageWidth, height: YMSizes.CommonTouchableViewHeight)
    }
    
    private func DrawLoginOperating(){
        let changePassword = YMLayout.GetCommonFullWidthTouchableView(
            BodyView, useObject: SettingActions!, useMethod: PageJumpActions.PageJumpToByViewSenderSel,
            label: UILabel(), text: "更改密码", userStringData: YMCommonStrings.CS_PAGE_PERSONAL_PASSWORD_RESET_NAME)
        
        let logoutButton = YMLayout.GetCommonFullWidthTouchableView(
            BodyView, useObject: SettingActions!, useMethod: "Logout:".Sel(),
            label: UILabel(), text: "退出登录", userStringData: "", fontSize: 28.LayoutVal(), showArrow: false)

        
        BodyView.addSubview(changePassword)
        BodyView.addSubview(logoutButton)
        
        changePassword.align(Align.UnderMatchingLeft, relativeTo: IDNumButton!,
                              padding: DefaultButtonGroupPadding, width: YMSizes.PageWidth, height: YMSizes.CommonTouchableViewHeight)
        
        logoutButton.align(Align.UnderMatchingLeft, relativeTo: changePassword,
                              padding: 0, width: YMSizes.PageWidth, height: YMSizes.CommonTouchableViewHeight)
    }
}























