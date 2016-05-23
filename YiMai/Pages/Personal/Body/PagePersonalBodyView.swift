//
//  PagePersonalBodyView.swift
//  YiMai
//
//  Created by why on 16/4/22.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PagePersonalBodyView {
    private var ParentView: UIView? = nil
    private var NavController: UINavigationController? = nil
    private var Actions: PagePersonalActions? = nil
    
    private var BodyView: UIScrollView = UIScrollView()
    
    private var OperationArray: [YMTouchableView] = [YMTouchableView]()
    
    private var BodyTopPadding: UIView? = nil
    private var OperationHeight = 91.LayoutVal()
    
    convenience init(parentView: UIView, navController: UINavigationController, pageActions: PagePersonalActions){
        self.init()
        self.ParentView = parentView
        self.NavController = navController
        self.Actions = pageActions
        
        ViewLayout()
    }
    
    private func DrawBodyPanel() {
        ParentView?.addSubview(BodyView)
        BodyView.fillSuperview()
        BodyView.backgroundColor = YMColors.PanelBackgroundGray
        BodyView.contentInset = UIEdgeInsets(top: YMSizes.PagePersonalTopHeight, left: 0, bottom: YMSizes.PageBottomHeight, right: 0)
    }
    
    private func ViewLayout() {
        DrawBodyPanel()
        BodyTopPadding = YMLayout.DrawGrayVerticalSpace(BodyView, height: 20.LayoutVal())
        
        DrawOperations()
    }
    
    private func DrawHotLinePanel(){
        let hotlineView = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "PageJumpToByViewSender:")
        hotlineView.UserStringData = YMCommonStrings.CS_PAGE_HOT_LINE_NAME
        hotlineView.frame = CGRect(x: 0,y: 0,width: YMSizes.PageWidth, height: OperationHeight)
        hotlineView.backgroundColor = YMColors.White
        
        BodyView.addSubview(hotlineView)
        OperationArray.append(hotlineView)
        
        let icon = YMLayout.GetSuitableImageView("PersonalIconLawyerHotline")
        let dividerLine = YMLayout.GetSuitableImageView("PersonalIconDividerLine")
        let rightArrow = YMLayout.GetSuitableImageView("PersonalIconPersonalRightArrow")
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = YMColors.DividerLineGray
        
        hotlineView.addSubview(icon)
        hotlineView.addSubview(dividerLine)
        hotlineView.addSubview(rightArrow)
        hotlineView.addSubview(bottomLine)

        icon.anchorInCorner(Corner.BottomLeft, xPad: 45.LayoutVal(), yPad: 30.LayoutVal(), width: icon.width, height: icon.height)
        dividerLine.anchorInCorner(Corner.BottomLeft, xPad: 102.LayoutVal(), yPad: 30.LayoutVal(), width: dividerLine.width, height: dividerLine.height)
        rightArrow.anchorInCorner(Corner.TopRight, xPad: 40.LayoutVal(), yPad: 33.LayoutVal(), width: rightArrow.width, height: rightArrow.height)
        bottomLine.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: 1)
    }
    
    private func DrawAnOperationPanel(targetPage: String, iconName: String, title: String) -> YMTouchableView {
        let touchableView = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "PageJumpToByViewSender:")
        touchableView.UserStringData = targetPage
        touchableView.frame = CGRect(x: 0,y: 0,width: YMSizes.PageWidth, height: OperationHeight)
        touchableView.backgroundColor = YMColors.White

        BodyView.addSubview(touchableView)
        OperationArray.append(touchableView)
        
        let icon = YMLayout.GetSuitableImageView(iconName)
        let dividerLine = YMLayout.GetSuitableImageView("PersonalIconDividerLine")
        let rightArrow = YMLayout.GetSuitableImageView("PersonalIconPersonalRightArrow")
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = YMColors.DividerLineGray
        
        touchableView.addSubview(icon)
        touchableView.addSubview(dividerLine)
        touchableView.addSubview(rightArrow)
        touchableView.addSubview(bottomLine)
        
        icon.anchorInCorner(Corner.BottomLeft, xPad: 45.LayoutVal(), yPad: 30.LayoutVal(), width: icon.width, height: icon.height)
        dividerLine.anchorInCorner(Corner.BottomLeft, xPad: 102.LayoutVal(), yPad: 30.LayoutVal(), width: dividerLine.width, height: dividerLine.height)
        rightArrow.anchorInCorner(Corner.TopRight, xPad: 40.LayoutVal(), yPad: 33.LayoutVal(), width: rightArrow.width, height: rightArrow.height)
        bottomLine.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: 1)
        
        return touchableView
    }
    
    private func DrawOperations() {
        
        DrawAnOperationPanel(YMCommonStrings.CS_PAGE_MY_ADMISSIONS_SETTING_NAME, iconName: "PersonalIconMyAdmissionsSetting",title: "我的接诊设置")
        DrawAnOperationPanel(YMCommonStrings.CS_PAGE_MY_PATIENTS_NAME, iconName: "PersonalIconMyPatient",title: "我的患者")
        DrawAnOperationPanel(YMCommonStrings.CS_PAGE_MY_WALLET_NAME, iconName: "PersonalIconMyWallet",title: "我的钱包")
        DrawAnOperationPanel(YMCommonStrings.CS_PAGE_MY_SETTING_NAME, iconName: "PersonalIconMySetting",title: "设置")
        DrawHotLinePanel()
        DrawAnOperationPanel(YMCommonStrings.CS_PAGE_CONSULTANT_ZONE_NAME, iconName: "PersonalIconConsultantZone",title: "健康顾问合作专区")
        
        BodyView.groupAndAlign(group: Group.Vertical, andAlign: Align.UnderMatchingLeft,
            views: OperationArray.map({$0 as YMTouchableView}), relativeTo: BodyTopPadding!,
            padding: 0, width: YMSizes.PageWidth, height: OperationHeight)
    }
}













































