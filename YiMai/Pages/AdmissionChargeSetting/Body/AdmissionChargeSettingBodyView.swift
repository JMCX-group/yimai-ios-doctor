//
//  AdmissionChargeSettingBodyView.swift
//  YiMai
//
//  Created by superxing on 16/8/19.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageAdmissionChargeSettingBodyView: PageBodyView {
    private var SettingActions: PageAdmissionChargeSettingActions? = nil
    
    public let ChargeSwitch = UISwitch()
    public var CommonCharge: YMTextField? = nil
    public let Face2FaceCharge: YMTextField? = nil

    override func ViewLayout() {
        super.ViewLayout()
        SettingActions = PageAdmissionChargeSettingActions(navController: self.NavController, target: self)
        
        DrawCommonChargeSettingPannel()
        DrawFace2FaceChargeSettingPanel()
    }
    
    func DrawFace2FaceChargeSettingPanel() {
        let panel = UIView()
        
        BodyView.addSubview(panel)
        panel.anchorToEdge(Edge.Top, padding: 340.LayoutVal(), width: YMSizes.PageWidth, height: 80.LayoutVal())
        
        let chargeCell = UIView()
        panel.addSubview(chargeCell)
        chargeCell.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 80.LayoutVal())
        chargeCell.backgroundColor = YMColors.White

        let chargeLabel = UILabel()
        chargeLabel.text = "当面咨询"
        chargeLabel.font = YMFonts.YMDefaultFont(28.LayoutVal())
        chargeLabel.textColor = YMColors.FontGray
        chargeLabel.sizeToFit()
        
        chargeCell.addSubview(chargeLabel)
        chargeLabel.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: chargeLabel.width, height: chargeLabel.height)
        
        let param = TextFieldCreateParam()
        param.BackgroundColor = YMColors.PanelBackgroundGray
        param.FontColor = YMColors.FontBlue
        param.FontSize = 18.LayoutVal()
        CommonCharge = YMLayout.GetTextFieldWithMaxCharCount(param, maxCharCount: 3)
        CommonCharge?.SetBothPaddingWidth(10)
        CommonCharge?.textAlignment = NSTextAlignment.Center
        CommonCharge?.layer.cornerRadius = 6.LayoutVal()
        CommonCharge?.layer.borderColor = YMColors.DividerLineGray.CGColor
        CommonCharge?.layer.borderWidth = YMSizes.OnPx
        CommonCharge?.layer.masksToBounds = true
        CommonCharge?.keyboardType = UIKeyboardType.NumberPad
        
        
        let chargeLeftLabel = UILabel()
        chargeLeftLabel.text = "收费"
        chargeLeftLabel.font = YMFonts.YMDefaultFont(28.LayoutVal())
        chargeLeftLabel.textColor = YMColors.FontLightGray
        chargeLeftLabel.sizeToFit()
        
        let chargeRightLabel = UILabel()
        chargeRightLabel.text = "元"
        chargeRightLabel.font = YMFonts.YMDefaultFont(28.LayoutVal())
        chargeRightLabel.textColor = YMColors.FontLightGray
        chargeRightLabel.sizeToFit()
        
        chargeCell.addSubview(chargeRightLabel)
        chargeCell.addSubview(CommonCharge!)
        chargeCell.addSubview(chargeLeftLabel)
        
        chargeRightLabel.anchorToEdge(Edge.Right, padding: 30.LayoutVal(), width: chargeRightLabel.width, height: chargeRightLabel.height)
        CommonCharge!.align(Align.ToTheLeftCentered, relativeTo: chargeRightLabel, padding: 10.LayoutVal(), width: 96.LayoutVal(), height: 36.LayoutVal())
        chargeLeftLabel.align(Align.ToTheLeftCentered, relativeTo: CommonCharge!, padding: 10.LayoutVal(), width: chargeLeftLabel.width, height: chargeLeftLabel.height)
    }
    
    func DrawCommonChargeSettingPannel() {
        let panel = UIView()

        BodyView.addSubview(panel)
        panel.anchorToEdge(Edge.Top, padding: 70.LayoutVal(), width: YMSizes.PageWidth, height: 0.LayoutVal())
        
        let switchCell = UIView()
        panel.addSubview(switchCell)
        switchCell.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 80.LayoutVal())
        switchCell.backgroundColor = YMColors.White
        
        let chargeSwitchLabel = UILabel()
        chargeSwitchLabel.text = "接诊收费"
        chargeSwitchLabel.font = YMFonts.YMDefaultFont(28.LayoutVal())
        chargeSwitchLabel.textColor = YMColors.FontGray
        chargeSwitchLabel.sizeToFit()
        
        switchCell.addSubview(chargeSwitchLabel)
        chargeSwitchLabel.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: chargeSwitchLabel.width, height: chargeSwitchLabel.height)
        
        switchCell.addSubview(ChargeSwitch)
        ChargeSwitch.anchorToEdge(Edge.Right, padding: 30.LayoutVal(), width: ChargeSwitch.width, height: ChargeSwitch.height)
        
        let chargeCell = UIView()
        panel.addSubview(chargeCell)
        chargeCell.align(Align.UnderMatchingLeft, relativeTo: switchCell, padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: 80.LayoutVal())
        chargeCell.backgroundColor = YMColors.White

        let chargeLabel = UILabel()
        chargeLabel.text = "收费"
        chargeLabel.font = YMFonts.YMDefaultFont(28.LayoutVal())
        chargeLabel.textColor = YMColors.FontLightGray
        chargeLabel.sizeToFit()
        
        chargeCell.addSubview(chargeLabel)
        chargeLabel.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: chargeLabel.width, height: chargeLabel.height)

        let param = TextFieldCreateParam()
        param.BackgroundColor = YMColors.PanelBackgroundGray
        param.FontColor = YMColors.FontBlue
        param.FontSize = 18.LayoutVal()
        CommonCharge = YMLayout.GetTextFieldWithMaxCharCount(param, maxCharCount: 3)
        CommonCharge?.SetBothPaddingWidth(10)
        CommonCharge?.textAlignment = NSTextAlignment.Center
        CommonCharge?.layer.cornerRadius = 6.LayoutVal()
        CommonCharge?.layer.borderColor = YMColors.DividerLineGray.CGColor
        CommonCharge?.layer.borderWidth = YMSizes.OnPx
        CommonCharge?.layer.masksToBounds = true
        CommonCharge?.keyboardType = UIKeyboardType.NumberPad
        
        
        let chargeLeftLabel = UILabel()
        chargeLeftLabel.text = "每次"
        chargeLeftLabel.font = YMFonts.YMDefaultFont(28.LayoutVal())
        chargeLeftLabel.textColor = YMColors.FontLightGray
        chargeLeftLabel.sizeToFit()
        
        let chargeRightLabel = UILabel()
        chargeRightLabel.text = "元"
        chargeRightLabel.font = YMFonts.YMDefaultFont(28.LayoutVal())
        chargeRightLabel.textColor = YMColors.FontLightGray
        chargeRightLabel.sizeToFit()
        
        chargeCell.addSubview(chargeRightLabel)
        chargeCell.addSubview(CommonCharge!)
        chargeCell.addSubview(chargeLeftLabel)
        
        chargeRightLabel.anchorToEdge(Edge.Right, padding: 30.LayoutVal(), width: chargeRightLabel.width, height: chargeRightLabel.height)
        CommonCharge!.align(Align.ToTheLeftCentered, relativeTo: chargeRightLabel, padding: 10.LayoutVal(), width: 96.LayoutVal(), height: 36.LayoutVal())
        chargeLeftLabel.align(Align.ToTheLeftCentered, relativeTo: CommonCharge!, padding: 10.LayoutVal(), width: chargeLeftLabel.width, height: chargeLeftLabel.height)
        
        YMLayout.SetViewHeightByLastSubview(panel, lastSubView: chargeCell)
    }
}





































