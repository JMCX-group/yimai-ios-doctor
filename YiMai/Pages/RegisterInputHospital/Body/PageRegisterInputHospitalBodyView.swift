//
//  PageRegisterInputHospitalBodyView.swift
//  YiMai
//
//  Created by why on 16/4/20.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageRegisterInputHospitalBodyView: NSObject {
    private var ParentView : UIView? = nil
    private var NavController : UINavigationController? = nil
    private var Actions : PageRegisterInputHospitalActions? = nil
    
    private let BodyView : UIScrollView = UIScrollView()
    private var TopInputPanel : UIView? = nil
    
    private var InputText: YMTextField? = nil
    private var OKButton: YMButton? = nil

    convenience init(parentView: UIView, navController: UINavigationController) {
        self.init()
        self.ParentView = parentView
        self.NavController = navController
        self.Actions = PageRegisterInputHospitalActions(navController: navController, bodyView: self)
        self.ViewLayout()
    }
    
    private func ViewLayout() {
        YMLayout.BodyLayoutWithTop(ParentView!, bodyView: BodyView)
        DrawInputPanel()
    }
    
    private func DrawInputPanel() {
        TopInputPanel = UIView()
        BodyView.addSubview(TopInputPanel!)
        TopInputPanel?.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 0, otherSize: 120.LayoutVal())
        TopInputPanel?.backgroundColor = YMColors.BackgroundGray
        
        let inputTextFieldParam = TextFieldCreateParam()
        inputTextFieldParam.BackgroundImageName = "IndexInputSearchBackground"
        inputTextFieldParam.FontColor = YMColors.FontBlue
        inputTextFieldParam.FontSize = 26.LayoutVal()
        inputTextFieldParam.Placholder = YMRegisterInputSelectorStrings.CS_INPUT_HOSPITAL_PLACEHOLDER
        InputText = YMLayout.GetTextFieldWithMaxCharCount(inputTextFieldParam, maxCharCount: 20)
        
        InputText?.SetLeftPaddingWidth(20.LayoutVal())
        TopInputPanel?.addSubview(InputText!)
        InputText?.anchorInCorner(Corner.BottomLeft, xPad: 30.LayoutVal(), yPad: 30.LayoutVal(), width: 570.LayoutVal(), height: 60.LayoutVal())
        
        OKButton = YMButton()
        OKButton?.UserStringData = YMCommonStrings.CS_PAGE_REGISTER_INPUT_HOSPITAL_NAME
        
        TopInputPanel?.addSubview(OKButton!)
        OKButton?.anchorInCorner(Corner.BottomRight, xPad: 0, yPad: 0, width: 150.LayoutVal(), height: 120.LayoutVal())
        OKButton?.setTitle(YMRegisterInputSelectorStrings.CS_OK_BUTTON_TITLE, forState: UIControlState.Normal)
        OKButton?.titleLabel?.font = UIFont.systemFontOfSize(26.LayoutVal())
        OKButton?.setTitleColor(YMColors.FontGray, forState: UIControlState.Normal)
        
        OKButton?.addTarget(Actions, action: "PageJumpTo:", forControlEvents: UIControlEvents.TouchUpInside)
    }
}