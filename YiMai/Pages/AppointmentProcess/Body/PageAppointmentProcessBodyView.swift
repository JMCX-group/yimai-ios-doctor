//
//  PageAppointmentProcessBodyView.swift
//  YiMai
//
//  Created by superxing on 16/9/2.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageAppointmentProcessBodyView: PageBodyView {
    private var ProcessActions: PageAppointmentProcessActions? = nil

    private let DPPanel = UIView()
    private let DocCell = UIView()
    private let PatientCell = UIView()
    
    private var HisPanel = UIView()
    private var ImageListPanel = UIView()
    private var AdmissionTimePanel = UIView()
    private var DescPanel = UIView()
    private var NeedToKnowPanel = UIView()
    
    public var Loading: YMPageLoadingView? = nil
    
    private let AppointmentNum = UILabel()
    
    public static var AdmissionNum: String = ""
    
    override func ViewLayout() {
        super.ViewLayout()
        
        ProcessActions = PageAppointmentProcessActions(navController: self.NavController!, target: self)
        Loading = YMPageLoadingView(parentView: self.BodyView)

        DrawDPPanel()
        DrawAppointmentNum()
        
        Loading?.Show()
    }
    
    private func DrawDPPanel() {
        BodyView.addSubview(DPPanel)
        DPPanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 310.LayoutVal())
        
        DocCell.backgroundColor = YMColors.White
        PatientCell.backgroundColor = YMColors.White
        
        DPPanel.addSubview(DocCell)
        DPPanel.addSubview(PatientCell)
        DPPanel.groupAndFill(group: Group.Horizontal, views: [DocCell, PatientCell], padding: 0)
        let divider = UIView()
        DPPanel.addSubview(divider)
        divider.backgroundColor = YMColors.DividerLineGray
        divider.anchorInCenter(width: YMSizes.OnPx, height: DPPanel.height)
    }
    
    private func DrawAppointmentNum() {
        BodyView.addSubview(AppointmentNum)
        AppointmentNum.font = YMFonts.YMDefaultFont(20.LayoutVal())
        AppointmentNum.textColor = YMColors.FontBlue
        AppointmentNum.textAlignment = NSTextAlignment.Center
        AppointmentNum.align(Align.UnderMatchingLeft, relativeTo: DPPanel,
                             padding: 0, width: YMSizes.PageWidth, height: 50.LayoutVal())
    }

}