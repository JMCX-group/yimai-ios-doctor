//
//  PagePersonalIDNumInputBodyView.swift
//  YiMai
//
//  Created by why on 16/6/20.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon
import MWIDCardValidate

public class PagePersonalIDNumInputBodyView: PageBodyView {
    private var InputActions: PagePersonalIDNumInputActions? = nil
    private var IDInput: YMTextField? = nil
    private let ErrorInfo = UILabel()
    private let SubmitButton = YMButton()
    
    public var Loading: YMPageLoadingView? = nil
    
    public static var IDNum = ""
    
    override func ViewLayout() {
        super.ViewLayout()
        
        InputActions = PagePersonalIDNumInputActions(navController: self.NavController!, target: self)
        DrawInput()
        
        Loading = YMPageLoadingView(parentView: BodyView)
    }
    
    private func DrawInput() {
        let param = TextFieldCreateParam()
        param.FontColor = YMColors.FontBlue
        param.FontSize = 30.LayoutVal()
        param.Placholder = "仅用于为您代扣代缴个人所得税"
        param.DefaultText = PagePersonalIDNumInputBodyView.IDNum
        IDInput = YMLayout.GetTextFieldWithMaxCharCount(param, maxCharCount: 18)
        IDInput?.EditChangedCallback = CheckInput
        IDInput?.keyboardType = UIKeyboardType.PhonePad
        
        BodyView.addSubview(IDInput!)
        IDInput!.anchorToEdge(Edge.Top, padding: 70.LayoutVal(), width: YMSizes.PageWidth, height: 80.LayoutVal())
        IDInput!.SetLeftPaddingWidth(40.LayoutVal())
        
        BodyView.addSubview(ErrorInfo)
        ErrorInfo.text = "*无效身份证"
        ErrorInfo.textAlignment = NSTextAlignment.Center
        ErrorInfo.textColor = YMColors.WarningFontColor
        ErrorInfo.font = YMFonts.YMDefaultFont(24.LayoutVal())
        ErrorInfo.hidden = true
        ErrorInfo.anchorInCorner(Corner.TopRight, xPad: 0, yPad: 70.LayoutVal(), width: 70.LayoutVal(), height: 80.LayoutVal())

        BodyView.addSubview(SubmitButton)
        SubmitButton.align(Align.UnderCentered, relativeTo: IDInput!, padding: 70.LayoutVal(), width: YMSizes.PageWidth, height: 80.LayoutVal())
        
        SubmitButton.setTitle("提交", forState: UIControlState.Normal)
        SubmitButton.setTitleColor(YMColors.FontGray, forState: UIControlState.Normal)
        SubmitButton.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        SubmitButton.backgroundColor = YMColors.CommonBottomGray
        SubmitButton.enabled = false
        
        SubmitButton.addTarget(InputActions!, action: "SetIDNum:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    private func SetSubmitEnable() {
        SubmitButton.enabled = true
        SubmitButton.backgroundColor = YMColors.CommonBottomBlue
    }
    
    private func SetSubmitDisable() {
        SubmitButton.enabled = false
        SubmitButton.backgroundColor = YMColors.CommonBottomGray
    }
    
    private func CheckInput(_: YMTextField) {
        let id = IDInput!.text
        
        if(id?.characters.count >= 17) {
            SetSubmitEnable()
//            if(MWIDCardValidate.validateIdentityCard(id!)){
//                SetSubmitEnable()
//            } else {
//                ErrorInfo.hidden = false
//                SetSubmitDisable()
//            }
        } else {
            ErrorInfo.hidden = true
            SetSubmitDisable()
        }
    }
    
    public func GetIDNum() -> String {
        return IDInput!.text!
    }
}
































