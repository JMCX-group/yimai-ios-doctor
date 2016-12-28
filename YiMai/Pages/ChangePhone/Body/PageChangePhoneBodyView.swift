//
//  PageChangePhoneBodyView.swift
//  YiMai
//
//  Created by why on 2016/12/25.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

class PageChangePhoneBodyView: PageBodyView {
    var ChangeActions: PageChangePhoneActions!
    
    var PhonePanel = UIView()
    var PhoneInput: YMTextField!
    
    var VerifyCodePanel = UIView()
    var VerifyCodeInput: YMTextField!
    
    var CountDownTimer: NSTimer? = nil
    var CountDownNum: Int = 60
    
    var GetVerifyCodeButton = YMButton()
    var ConfirmButton = YMButton()

    override func ViewLayout() {
        super.ViewLayout()

        ChangeActions = PageChangePhoneActions(navController: NavController!, target: self)
        DrawFullBody()
    }
    
    func DrawPhoneInputPanel() {
        BodyView.addSubview(PhonePanel)
        PhonePanel.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 70.LayoutVal(), otherSize: 90.LayoutVal())
        PhonePanel.backgroundColor = YMColors.White
        
        let param = TextFieldCreateParam()
        param.FontSize = 30.LayoutVal()
        param.FontColor = YMColors.FontBlue
        param.Placholder = "请输入新手机号"
        PhoneInput = YMLayout.GetCellPhoneField(param)
        
        PhonePanel.addSubview(PhoneInput)
        PhoneInput.fillSuperview()
        PhoneInput.SetBothPaddingWidth(40.LayoutVal())
    }
    
    func DrawVerifyInputPanel() {
        BodyView.addSubview(VerifyCodePanel)
        VerifyCodePanel.align(Align.UnderMatchingLeft, relativeTo: PhonePanel, padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: 90.LayoutVal())
        
        let param = TextFieldCreateParam()
        param.FontSize = 30.LayoutVal()
        param.FontColor = YMColors.FontGray
        param.Placholder = "验证码"
        VerifyCodeInput = YMLayout.GetTextFieldWithMaxCharCount(param, maxCharCount: 10)
        
        VerifyCodePanel.addSubview(VerifyCodeInput)
        VerifyCodeInput.fillSuperview()
        VerifyCodeInput.SetBothPaddingWidth(40.LayoutVal())
        
        VerifyCodePanel.addSubview(GetVerifyCodeButton)
        GetVerifyCodeButton.setTitle("获取验证码", forState: UIControlState.Normal)
        GetVerifyCodeButton.setTitle("获取验证码（60）", forState: UIControlState.Disabled)
        GetVerifyCodeButton.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        GetVerifyCodeButton.backgroundColor = YMColors.FontBlue
        GetVerifyCodeButton.titleLabel?.font = YMFonts.YMDefaultFont(24.LayoutVal())
        GetVerifyCodeButton.sizeToFit()
        GetVerifyCodeButton.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: GetVerifyCodeButton.width + 40.LayoutVal(), height: GetVerifyCodeButton.height)
        
        GetVerifyCodeButton.addTarget(ChangeActions, action: "GetVerifyCodeTouched:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func DisableGetVerifyCodeBtnWhenTouchdown() {
        GetVerifyCodeButton.enabled = false
        GetVerifyCodeButton.backgroundColor = YMColors.FontLighterGray
        GetVerifyCodeButton.setTitle("获取验证码", forState: UIControlState.Disabled)
        GetVerifyCodeButton.sizeToFit()
        GetVerifyCodeButton.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: GetVerifyCodeButton.width + 40.LayoutVal(), height: GetVerifyCodeButton.height)
    }
    
    func DisableGetVerifyCodeBtn() {
        if(0 > CountDownNum) {
            StopCountDown()
            EnableGetVerifyCodeBtn()
            return
        }
        GetVerifyCodeButton.enabled = false
        GetVerifyCodeButton.backgroundColor = YMColors.FontLighterGray
        GetVerifyCodeButton.setTitle("获取验证码（\(CountDownNum)）", forState: UIControlState.Disabled)
        GetVerifyCodeButton.sizeToFit()
        GetVerifyCodeButton.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: GetVerifyCodeButton.width + 40.LayoutVal(), height: GetVerifyCodeButton.height)
        CountDownNum -= 1
    }
    
    func EnableGetVerifyCodeBtn() {
        GetVerifyCodeButton.backgroundColor = YMColors.FontBlue
        GetVerifyCodeButton.enabled = true
    }
    
    func DrawFullBody(){
        DrawPhoneInputPanel()
        DrawVerifyInputPanel()

        ConfirmButton.setTitle("确定", forState: UIControlState.Normal)
        ConfirmButton.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        ConfirmButton.titleLabel?.font = YMFonts.YMDefaultFont(36.LayoutVal())
        ConfirmButton.backgroundColor = YMColors.FontBlue
        ConfirmButton.sizeToFit()
        ConfirmButton.addTarget(ChangeActions, action: "ConfirmChange:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        
        ParentView?.addSubview(ConfirmButton)
        ConfirmButton.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: 98.LayoutVal())
    }
    
    func StartCountDown() {
        CountDownTimer?.invalidate()
        CountDownNum = 60
        CountDownTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "DisableGetVerifyCodeBtn".Sel(), userInfo: nil, repeats: true)
        let runloop = NSRunLoop.currentRunLoop()
        runloop.addTimer(CountDownTimer!, forMode: NSRunLoopCommonModes)

    }
    
    func StopCountDown() {
        CountDownNum = 60
        CountDownTimer?.invalidate()
    }
}










