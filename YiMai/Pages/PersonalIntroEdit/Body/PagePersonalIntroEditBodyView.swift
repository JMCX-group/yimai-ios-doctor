//
//  PagePersonalIntroEditBodyView.swift
//  YiMai
//
//  Created by why on 16/6/22.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PagePersonalIntroEditBodyView: PageBodyView {
    public var TextInput: YMTextArea? = nil
    private var SubmitButton: YMButton? = nil
    override func ViewLayout() {
        super.ViewLayout()
        
        DrawTextArea()
        DrawSubmit()
        LoadData()
    }
    
    private func DrawTextArea() {
        TextInput = YMTextArea(aDelegate: nil)
        BodyView.addSubview(TextInput!)
        TextInput?.anchorToEdge(Edge.Top, padding: 40.LayoutVal(), width: YMSizes.PageWidth, height: 500.LayoutVal())
        TextInput?.SetPadding(30.LayoutVal(), right: 30.LayoutVal(), top: 30.LayoutVal(), bottom: 30.LayoutVal())
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
        TextInput?.text = PagePersonalIntroEditViewController.IntroText
    }
}