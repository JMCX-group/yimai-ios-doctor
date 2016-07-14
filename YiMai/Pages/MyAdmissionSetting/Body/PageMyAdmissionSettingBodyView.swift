//
//  PageMyAdmissionSettingBodyView.swift
//  YiMai
//
//  Created by superxing on 16/7/14.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageMyAdmissionSettingBodyView: PageBodyView {
    var SettingActions:PageMyAdmissionSettingActions? = nil
    
    override func ViewLayout() {
        super.ViewLayout()
        
        SettingActions = PageMyAdmissionSettingActions(navController: NavController!)
        
        DrawButtons()
    }
    
    func DrawButtons() {
            let timeSettingButton = YMLayout.GetCommonFullWidthTouchableView(
                BodyView, useObject: SettingActions!, useMethod: PageJumpActions.PageJumpToByViewSenderSel,
                label: UILabel(), text: "接诊时间", userStringData: YMCommonStrings.CS_PAEG_ADMISSION_TIME_SETTING_NAME)
            
            let chargeSettingButton = YMLayout.GetCommonFullWidthTouchableView(
                BodyView, useObject: SettingActions!, useMethod: PageJumpActions.PageJumpToByViewSenderSel,
                label: UILabel(), text: "接诊收费", userStringData: YMCommonStrings.CS_PAEG_ADMISSION_CHARGE_SETTING_NAME)
        
            
            timeSettingButton.anchorToEdge(Edge.Top, padding: 70.LayoutVal(),
                                              width: YMSizes.PageWidth, height: YMSizes.CommonTouchableViewHeight)
            
            chargeSettingButton.align(Align.UnderMatchingLeft, relativeTo: timeSettingButton,
                                       padding: 0, width: YMSizes.PageWidth, height: YMSizes.CommonTouchableViewHeight)
    }
}