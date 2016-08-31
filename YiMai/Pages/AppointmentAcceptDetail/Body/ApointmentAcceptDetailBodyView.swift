//
//  ApointmentAcceptDetailBodyView.swift
//  YiMai
//
//  Created by superxing on 16/8/31.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class ApointmentAcceptDetailBodyView: PageBodyView {
    private var AcceptActions: ApointmentAcceptDetailActions!
    private let AdmissionTimePanel = YMTouchableView()
    private let HospitalPanel = YMTouchableView()
    private let DescPanel = YMTouchableView()
    
    public var TimeCell: YMTouchableView? = nil
    public let DescInput = YMTextArea(aDelegate: nil)
    
    public override func ViewLayout() {
        super.ViewLayout()
        AcceptActions = ApointmentAcceptDetailActions(navController: self.NavController!, target: self)
        DrawAdmissionTime()
        DrawHospital()
    }
    
    private func DrawAdmissionTime() {
        BodyView.addSubview(AdmissionTimePanel)
        AdmissionTimePanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 144.LayoutVal())
        let title = YMLayout.GetYMPanelTitleLabel("期望就诊时间", fontColor: YMColors.FontGray, fontSize: 24.LayoutVal(),
                                      backgroundColor: YMColors.BackgroundGray, height: 60.LayoutVal(),
                                      paddingLeft: 40.LayoutVal(), panel: AdmissionTimePanel)
        

        TimeCell = YMLayout.GetYMTouchableCell("选择时间",
                                               padding: 40.LayoutVal(), showArrow: true,
                                               action: AcceptActions!, method: "SelectTimeCellTouched:".Sel(),
                                               width: YMSizes.PageWidth, height: 84.LayoutVal(), fontSize: 26.LayoutVal(), panel: AdmissionTimePanel)
        
        TimeCell?.align(Align.UnderMatchingLeft, relativeTo: title, padding: 0, width: YMSizes.PageWidth, height: 84.LayoutVal())
    }
    
    private func DrawHospital() {
        BodyView.addSubview(HospitalPanel)
        HospitalPanel.align(Align.UnderMatchingLeft, relativeTo: AdmissionTimePanel, padding: 0, width: YMSizes.PageWidth, height: 144.LayoutVal())
        let title = YMLayout.GetYMPanelTitleLabel("就诊医院", fontColor: YMColors.FontGray, fontSize: 24.LayoutVal(),
                                      backgroundColor: YMColors.BackgroundGray, height: 60.LayoutVal(),
                                      paddingLeft: 40.LayoutVal(), panel: HospitalPanel)
        
        
        let HosCell = YMLayout.GetYMTouchableCell("我的医院",
                                               padding: 40.LayoutVal(), showArrow: false,
                                               action: AcceptActions!, method: "HospitalTouched:".Sel(),
                                               width: YMSizes.PageWidth, height: 84.LayoutVal(), fontSize: 26.LayoutVal(), panel: HospitalPanel)
        
        HosCell.align(Align.UnderMatchingLeft, relativeTo: title, padding: 0, width: YMSizes.PageWidth, height: 84.LayoutVal())
    }
    
    private func DrawDesc() {
        BodyView.addSubview(DescPanel)
        DescPanel.align(Align.UnderMatchingLeft, relativeTo: HospitalPanel, padding: 0, width: YMSizes.PageWidth, height: 144.LayoutVal())
        YMLayout.GetYMPanelTitleLabel("我的医院", fontColor: YMColors.FontGray, fontSize: 24.LayoutVal(),
                                      backgroundColor: YMColors.BackgroundGray, height: 60.LayoutVal(),
                                      paddingLeft: 40.LayoutVal(), panel: DescPanel)
        
        
        DescPanel.addSubview(DescInput)
//        DescPanel.anchorToEdge(Edge., padding: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
    }
}