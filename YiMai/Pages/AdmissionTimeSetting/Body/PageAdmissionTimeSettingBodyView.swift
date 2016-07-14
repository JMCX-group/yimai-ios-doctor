//
//  PageAdmissionTimeSettingBodyView.swift
//  YiMai
//
//  Created by superxing on 16/7/14.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageAdmissionTimeSettingBodyView: PageBodyView {
    var SettingActions: PageAdmissionTimeSettingActions? = nil
    override func ViewLayout() {
        super.ViewLayout()
        SettingActions = PageAdmissionTimeSettingActions(navController: NavController!,
                                                         target: self)
        
        DrawFixedSchedule()
        DrawFlexible()
    }
    
    public func DrawTopTabButton(topVeiw: UIView) {
        let tabBtn = UISegmentedControl(items: ["固定排班", "灵活排班"])
        topVeiw.addSubview(tabBtn)
        
        tabBtn.anchorToEdge(Edge.Bottom, padding: 20.LayoutVal(),
                            width: 344.LayoutVal(), height: 50.LayoutVal())
        
        tabBtn.tintColor = YMColors.White
        
        tabBtn.setTitleTextAttributes([NSFontAttributeName : YMFonts.YMDefaultFont(24.LayoutVal())!],
                                      forState: UIControlState.Normal)
        
        tabBtn.selectedSegmentIndex = 0
        
        tabBtn.addTarget(SettingActions!, action: "TabTouched:".Sel(), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    public func DrawFixedSchedule() {
        
    }
    
    public func DrawFlexible() {
        
    }
}