//
//  PageAppointmentPatientConditionBodyView.swift
//  YiMai
//
//  Created by ios-dev on 16/5/28.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageAppointmentPatientConditionBodyView: PageBodyView {
    private var ConditionInput: YMTextArea? = nil
    public static var ConditionStrings: String = ""
    override func ViewLayout() {
        super.ViewLayout()
        DrawTextArea()
    }
    
    private func DrawTextArea() {
        ConditionInput = YMTextArea(aDelegate: nil)
        
        BodyView.addSubview(ConditionInput!)
        
        let padding = 40.LayoutVal()
        ConditionInput?.SetPadding(padding,right: padding,top: padding,bottom: padding)
        ConditionInput?.font = YMFonts.YMDefaultFont(28.LayoutVal())
        ConditionInput?.textColor = YMColors.FontGray
        ConditionInput?.anchorToEdge(Edge.Top, padding: 30.LayoutVal(), width: YMSizes.PageWidth, height: 320.LayoutVal())
        ConditionInput?.MaxCharCount = 500
    }
}