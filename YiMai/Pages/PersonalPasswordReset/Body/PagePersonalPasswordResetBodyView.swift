//
//  PagePersonalPasswordResetBodyView.swift
//  YiMai
//
//  Created by ios-dev on 16/6/19.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PagePersonalPasswordResetBodyView: PageBodyView {
    private var SettingActions: PagePersonalPasswordResetActions? = nil
    
    private var OrgPwdInput: YMTextField? = nil
    private var NewPwdInput: YMTextField? = nil
    private var RepeatPwdInput: YMTextField? = nil
    
    private var SubmitButton: YMButton? = nil
    
    public var Loading: YMPageLoadingView? = nil

    override func ViewLayout() {
        super.ViewLayout()
        
        SettingActions = PagePersonalPasswordResetActions(navController: self.NavController!, target: self)
        DrawButtons()
        
        Loading = YMPageLoadingView(parentView: BodyView)
    }
    
    private func DrawButtons() {
        
        let param = TextFieldCreateParam()
        param.Placholder = "原密码"
        param.FontSize = 28.LayoutVal()
        param.BackgroundColor = YMColors.White
        
        OrgPwdInput = YMLayout.GetPasswordField(param)
        OrgPwdInput?.SetLeftPaddingWidth(40.LayoutVal())
        
        param.Placholder = "请输入六位以上新密码"
        NewPwdInput = YMLayout.GetPasswordField(param)
        NewPwdInput?.SetLeftPaddingWidth(40.LayoutVal())
        
        param.Placholder = "确认新密码"
        RepeatPwdInput = YMLayout.GetPasswordField(param)
        RepeatPwdInput?.SetLeftPaddingWidth(40.LayoutVal())

        BodyView.addSubview(OrgPwdInput!)
        BodyView.addSubview(NewPwdInput!)
        BodyView.addSubview(RepeatPwdInput!)
        
        let inputHeight = 80.LayoutVal()
        OrgPwdInput?.anchorToEdge(Edge.Top, padding: 70.LayoutVal(), width: YMSizes.PageWidth, height: inputHeight)
        NewPwdInput?.align(Align.UnderMatchingLeft, relativeTo: OrgPwdInput!,
                           padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: inputHeight)
        RepeatPwdInput?.align(Align.UnderMatchingLeft, relativeTo: NewPwdInput!,
                           padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: inputHeight)
        
        SubmitButton = YMButton()
        SubmitButton?.setTitle("提交", forState: UIControlState.Normal)
        SubmitButton?.setTitleColor(YMColors.FontGray, forState: UIControlState.Normal)
        SubmitButton?.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        SubmitButton?.backgroundColor = YMColors.CommonBottomGray
        SubmitButton?.enabled = false
        
        SubmitButton?.addTarget(SettingActions, action: "StartChange:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        
        BodyView.addSubview(SubmitButton!)
        SubmitButton!.align(Align.UnderCentered, relativeTo: RepeatPwdInput!, padding: 70.LayoutVal(), width: YMSizes.PageWidth, height: inputHeight)
        
        OrgPwdInput?.EditChangedCallback = CheckInput
        NewPwdInput?.EditChangedCallback = CheckInput
        RepeatPwdInput?.EditChangedCallback = CheckInput
    }
    
    private func SetSubmitEnable() {
        SubmitButton?.enabled = true
        SubmitButton?.backgroundColor = YMColors.CommonBottomBlue
    }
    
    private func SetSubmitDisable() {
        SubmitButton?.enabled = false
        SubmitButton?.backgroundColor = YMColors.CommonBottomGray
    }
    
    private func CheckInput(_: YMTextField) {
        let org = OrgPwdInput?.text
        let new = NewPwdInput?.text
        let repeatNew = RepeatPwdInput?.text

        if(YMValueValidator.IsEmptyString(org)) {
            SetSubmitDisable()
            return
        }
        
        if(YMValueValidator.IsEmptyString(new)) {
            SetSubmitDisable()
            return
        }
        
        if(YMValueValidator.IsEmptyString(repeatNew)) {
            SetSubmitDisable()
            return
        }
        
        if(new!.characters.count < 6) {
            SetSubmitDisable()
            return
        }
        
        if(new != repeatNew) {
            SetSubmitDisable()
            return
        }
        
        SetSubmitEnable()
    }
    
    public func GetInput() -> [String:String] {
        let org = OrgPwdInput?.text
        let new = NewPwdInput?.text
        
        return [
            "org":org!,
            "new":new!
        ]
    }
    
    public func Clear() {
        OrgPwdInput?.text = ""
        NewPwdInput?.text = ""
        RepeatPwdInput?.text = ""
        SetSubmitDisable()
    }
}



















