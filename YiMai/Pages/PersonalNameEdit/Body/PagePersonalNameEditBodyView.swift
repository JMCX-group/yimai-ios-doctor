//
//  File.swift
//  YiMai
//
//  Created by why on 16/6/22.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PagePersonalNameEditBodyView: PageBodyView {
    public var TextInput: YMTextField? = nil
    private var SubmitButton: YMButton? = nil
    override func ViewLayout() {
        super.ViewLayout()
        
        DrawInput()
        DrawSubmit()
        LoadData()
    }
    
    private func DrawInput() {
        let param = TextFieldCreateParam()
        param.FontColor = YMColors.FontGray
        param.FontSize = 26.LayoutVal()
        param.Placholder = "请填写姓名"
        TextInput = YMLayout.GetTextFieldWithMaxCharCount(param, maxCharCount: 60)
        BodyView.addSubview(TextInput!)
        TextInput?.anchorToEdge(Edge.Top, padding: 40.LayoutVal(), width: YMSizes.PageWidth, height: 80.LayoutVal())
        TextInput?.SetLeftPaddingWidth(40.LayoutVal())
        TextInput?.SetRightPaddingWidth(40.LayoutVal())
    }
    
    private func DrawSubmit() {
        SubmitButton = YMButton()
        
        BodyView.addSubview(SubmitButton!)
        SubmitButton?.align(Align.UnderCentered, relativeTo: TextInput!, padding: 20.LayoutVal(), width: YMSizes.PageWidth, height: 98.LayoutVal())
        SubmitButton?.setTitle("提交", forState: UIControlState.Normal)
        SubmitButton?.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        SubmitButton?.backgroundColor = YMColors.FontBlue
        SubmitButton?.addTarget(Actions!, action: "UpdateIntro:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    public func LoadData() {
        TextInput?.text = PagePersonalNameEditViewController.UserName
    }
}