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
    
    private var SettingActions: PagePersonalAccountSettingActions? = nil
    private let DefaultButtonGroupPadding = 70.LayoutVal()
    private let ExtButtonInfoPadding = 80.LayoutVal()
    private let ExtButtonInfoWidth = 400.LayoutVal()
    
    private var Loading: YMPageLoading? = nil
    
    override func ViewLayout() {
        super.ViewLayout()
        
        SettingActions = PagePersonalAccountSettingActions(navController: self.NavController!, target: self)
        
        DrawAccountBasicInfo()
        DrawExtInfo()
        DrawLoginOperating()
        
        Loading = YMPageLoading(parentView: BodyView)
        
        let userData = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_INFO)
        
        if(nil != userData) {
            DrawData(userData!)
        } else {
            Loading?.Show()
            YMCoreDataEngine.SetDataOnceHandler(YMModuleStrings.MODULE_NAME_MY_ACCOUNT_SETTING,
                                                handler: YMCoreMemDataOnceHandler(handler: LoadData))
        }
    }
    
    public func ReloadData() {
        let userData = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_INFO)
        
        if(nil != userData) {
            DrawData(userData!)
        }
    }
    
    private func LoadData(data: AnyObject?, mainQueue: NSOperationQueue) -> Bool {
        let userData = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_INFO)
        
        if(nil == userData) {
            return false
        } else {
            mainQueue.addOperationWithBlock({ 
                self.Loading?.Hide()
                self.DrawData(userData!)
            })

            return true
        }
    }
    
    private func DrawData(data: AnyObject) {
        let realData = data as! [String: AnyObject]
        AccountPhone.text = "\(realData["phone"]!)"
        AccountBindPhone.text = "\(realData["phone"]!)"

        let authTextMap = ["0":"已认证", "1":"尚未认证"]
        
        let authString = authTextMap[realData["is_auth"]! as! String]
        AuthLabel.text = authString
        
        if("<null>" == "\(realData["ID_number"]!)") {
            IDNum.text = "尚未填写身份证号码"
        } else {
            IDNum.text = "\(realData["ID_number"]!)"
        }
        EMail.text = "尚未开通邮件绑定功能"
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
            BodyView, useObject: SettingActions!, useMethod: PageJumpActions.PageJumpToByViewSenderSel,
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
            label: UILabel(), text: "绑定手机号")
        AppendExtInfo(AccountBindPhone, parent: bindPhoneButton, fontColor: YMColors.FontBlue, fontSize: 24.LayoutVal())
        
        let bindEmailButton = YMLayout.GetCommonFullWidthTouchableView(
            BodyView, useObject: SettingActions!, useMethod: PageJumpActions.PageJumpToByViewSenderSel,
            label: UILabel(), text: "邮箱地址")
        AppendExtInfo(EMail, parent: bindEmailButton, fontColor: YMColors.FontBlue, fontSize: 24.LayoutVal())
        
        IDNumButton = YMLayout.GetCommonFullWidthTouchableView(
            BodyView, useObject: SettingActions!, useMethod: PageJumpActions.PageJumpToByViewSenderSel,
            label: UILabel(), text: "身份证号码", userStringData: YMCommonStrings.CS_PAGE_PERSONAL_ID_NUM_INPUT_NAME)
        AppendExtInfo(IDNum, parent: IDNumButton!, fontColor: YMColors.FontBlue, fontSize: 24.LayoutVal())

        BodyView.addSubview(bindPhoneButton)
        BodyView.addSubview(bindEmailButton)
        BodyView.addSubview(IDNumButton!)
        
        bindPhoneButton.align(Align.UnderMatchingLeft, relativeTo: AuthButton!,
                          padding: DefaultButtonGroupPadding, width: YMSizes.PageWidth, height: YMSizes.CommonTouchableViewHeight)
        
        bindEmailButton.align(Align.UnderMatchingLeft, relativeTo: bindPhoneButton,
                          padding: 0, width: YMSizes.PageWidth, height: YMSizes.CommonTouchableViewHeight)
        
        IDNumButton?.align(Align.UnderMatchingLeft, relativeTo: bindEmailButton,
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























