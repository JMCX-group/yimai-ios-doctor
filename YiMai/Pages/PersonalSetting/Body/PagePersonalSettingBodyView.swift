//
//  PagePersonalSettingBodyView.swift
//  YiMai
//
//  Created by ios-dev on 16/6/19.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PagePersonalSettingBodyView: PageBodyView {
    var SettingActions: PagePersonalSettingActions? = nil
   
    override func ViewLayout() {
        super.ViewLayout()
        
        SettingActions = PagePersonalSettingActions(navController: self.NavController!, target: self)
        
        DrawButtons()
    }
    
    private func DrawButtons() {
        let accountSettingButton = YMLayout.GetCommonFullWidthTouchableView(
            BodyView, useObject: SettingActions!, useMethod: PageJumpActions.PageJumpToByViewSenderSel,
            label: UILabel(), text: "账户设置", userStringData: YMCommonStrings.CS_PAGE_ACCOUNT_SETTING_NAME)
        
        let privateSettingButton = YMLayout.GetCommonFullWidthTouchableView(
            BodyView, useObject: SettingActions!, useMethod: PageJumpActions.PageJumpToByViewSenderSel,
            label: UILabel(), text: "隐私设置")
        
        let aboutYiMaiButton = YMLayout.GetCommonFullWidthTouchableView(
            BodyView, useObject: SettingActions!, useMethod: PageJumpActions.PageJumpToByViewSenderSel,
            label: UILabel(), text: "关于医脉", userStringData: YMCommonStrings.CS_PAGE_ABOUT_YIMAI_NAME)
        
        accountSettingButton.anchorToEdge(Edge.Top, padding: 70.LayoutVal(),
                                          width: YMSizes.PageWidth, height: YMSizes.CommonTouchableViewHeight)
        
        privateSettingButton.align(Align.UnderMatchingLeft, relativeTo: accountSettingButton,
                                   padding: 0, width: YMSizes.PageWidth, height: YMSizes.CommonTouchableViewHeight)
        
        aboutYiMaiButton.align(Align.UnderMatchingLeft, relativeTo: privateSettingButton,
                               padding: 0, width: YMSizes.PageWidth, height: YMSizes.CommonTouchableViewHeight)
    }
}