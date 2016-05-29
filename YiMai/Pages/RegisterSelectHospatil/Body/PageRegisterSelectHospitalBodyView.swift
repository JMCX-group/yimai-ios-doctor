//
//  PageRegisterSelectHospitalBodyView.swift
//  YiMai
//
//  Created by why on 16/4/20.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageRegisterSelectHospitalBodyView: NSObject {
    private var ParentView : UIView? = nil
    private var NavController : UINavigationController? = nil
    private var Actions : PageRegisterSelectHospitalActions? = nil
    
    private let BodyView : UIScrollView = UIScrollView()
    private var TopInputPanel : UIView? = nil
    
    private var SearchText: YMTextField? = nil
    private var NotFoundButton: YMButton? = nil
    
    private var SearchImageView = YMLayout.GetSuitableImageView("CommonIconSearchHeader")
    
    convenience init(parentView: UIView, navController: UINavigationController) {
        self.init()
        self.ParentView = parentView
        self.NavController = navController
        self.Actions = PageRegisterSelectHospitalActions(navController: navController, bodyView: self)
        self.ViewLayout()
    }
    
    private func ViewLayout() {
        YMLayout.BodyLayoutWithTop(ParentView!, bodyView: BodyView)
        DrawSearchPanel()
    }
    
    private func DrawSearchPanel() {
        TopInputPanel = UIView()
        BodyView.addSubview(TopInputPanel!)
        TopInputPanel?.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 0, otherSize: 120.LayoutVal())
        TopInputPanel?.backgroundColor = YMColors.BackgroundGray
        
        let searchTextFieldParam = TextFieldCreateParam()
        searchTextFieldParam.BackgroundImageName = "IndexInputSearchBackground"
        searchTextFieldParam.FontColor = YMColors.FontBlue
        searchTextFieldParam.FontSize = 26.LayoutVal()
        searchTextFieldParam.Placholder = YMRegisterSelectHospitalStrings.CS_SEARCH_HOSPITAL_PLACEHOLDER
        SearchText = YMLayout.GetTextFieldWithMaxCharCount(searchTextFieldParam, maxCharCount: 20)
        
        let searchFieldLeftPaddingSize = CGRect(x: 0,y: 0,width: 68.LayoutVal(), height: 60.LayoutVal())
        let searchFieldLeftPadding = UIView(frame: searchFieldLeftPaddingSize)
        
        searchFieldLeftPadding.addSubview(SearchImageView)
        SearchImageView.anchorInCenter(width: SearchImageView.width, height: SearchImageView.height)

        SearchText?.SetLeftPadding(searchFieldLeftPadding)
        TopInputPanel?.addSubview(SearchText!)
        SearchText?.anchorInCorner(Corner.BottomLeft, xPad: 30.LayoutVal(), yPad: 30.LayoutVal(), width: 570.LayoutVal(), height: 60.LayoutVal())
        
        NotFoundButton = YMButton()
        NotFoundButton?.UserStringData = YMCommonStrings.CS_PAGE_REGISTER_INPUT_HOSPITAL_NAME
        
        TopInputPanel?.addSubview(NotFoundButton!)
        NotFoundButton?.anchorInCorner(Corner.BottomRight, xPad: 0, yPad: 0, width: 150.LayoutVal(), height: 120.LayoutVal())
        NotFoundButton?.setTitle(YMRegisterSelectHospitalStrings.CS_REGISTER_HOSPITAL_NOT_FOUND_BUTTON_TITLE, forState: UIControlState.Normal)
        NotFoundButton?.titleLabel?.font = UIFont.systemFontOfSize(26.LayoutVal())
        NotFoundButton?.setTitleColor(YMColors.FontGray, forState: UIControlState.Normal)
        
        NotFoundButton?.addTarget(Actions, action: "PageJumpTo:".Sel(),
                                  forControlEvents: UIControlEvents.TouchUpInside)
    }
}