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
    public let CommonChargeLabel = UILabel()
    public var Face2FaceCharge: YMTextField? = nil
    public let Face2FaceChargeLabel = UILabel()

    override func ViewLayout() {
        super.ViewLayout()
        SettingActions = PageAdmissionChargeSettingActions(navController: self.NavController, target: self)
        Actions = SettingActions
        
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
        Face2FaceCharge = YMLayout.GetTextFieldWithMaxCharCount(param, maxCharCount: 3)
        Face2FaceCharge?.SetBothPaddingWidth(10)
        Face2FaceCharge?.textAlignment = NSTextAlignment.Center
        Face2FaceCharge?.layer.cornerRadius = 6.LayoutVal()
        Face2FaceCharge?.layer.borderColor = YMColors.DividerLineGray.CGColor
        Face2FaceCharge?.layer.borderWidth = YMSizes.OnPx
        Face2FaceCharge?.layer.masksToBounds = true
        Face2FaceCharge?.keyboardType = UIKeyboardType.NumberPad
        
        Face2FaceChargeLabel.text = "收费"
        Face2FaceChargeLabel.font = YMFonts.YMDefaultFont(28.LayoutVal())
        Face2FaceChargeLabel.textColor = YMColors.FontLightGray
        Face2FaceChargeLabel.sizeToFit()
        
        let chargeRightLabel = UILabel()
        chargeRightLabel.text = "元"
        chargeRightLabel.font = YMFonts.YMDefaultFont(28.LayoutVal())
        chargeRightLabel.textColor = YMColors.FontLightGray
        chargeRightLabel.sizeToFit()
        
        chargeCell.addSubview(chargeRightLabel)
        chargeCell.addSubview(Face2FaceCharge!)
        chargeCell.addSubview(Face2FaceChargeLabel)
        
        chargeRightLabel.anchorToEdge(Edge.Right, padding: 30.LayoutVal(), width: chargeRightLabel.width, height: chargeRightLabel.height)
        Face2FaceCharge!.align(Align.ToTheLeftCentered, relativeTo: chargeRightLabel, padding: 10.LayoutVal(), width: 96.LayoutVal(), height: 36.LayoutVal())
        Face2FaceChargeLabel.align(Align.ToTheLeftCentered, relativeTo: Face2FaceCharge!, padding: 10.LayoutVal(), width: Face2FaceChargeLabel.width, height: Face2FaceChargeLabel.height)
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
        
        ChargeSwitch.addTarget(SettingActions!, action: "ChargeSwitchTouched:".Sel(), forControlEvents: UIControlEvents.ValueChanged)
        
        let chargeCell = UIView()
        panel.addSubview(chargeCell)
        chargeCell.align(Align.UnderMatchingLeft, relativeTo: switchCell, padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: 80.LayoutVal())
        chargeCell.backgroundColor = YMColors.White

        CommonChargeLabel.text = "收费"
        CommonChargeLabel.font = YMFonts.YMDefaultFont(28.LayoutVal())
        CommonChargeLabel.textColor = YMColors.FontLightGray
        CommonChargeLabel.sizeToFit()
        
        chargeCell.addSubview(CommonChargeLabel)
        CommonChargeLabel.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: CommonChargeLabel.width, height: CommonChargeLabel.height)

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
    
    func SetChargeOn(on: Bool) {
        if(on) {
            CommonChargeLabel.textColor = YMColors.FontGray
            CommonCharge?.textColor = YMColors.FontBlue
            CommonCharge?.enabled = true
            ChargeSwitch.on = true
        } else {
            CommonChargeLabel.textColor = YMColors.FontLightGray
            CommonCharge?.textColor = YMColors.FontLightGray
            CommonCharge?.enabled = false
            ChargeSwitch.on = false
        }
    }

    func LoadData() {
        let chargeSwitch = "\(YMVar.MyUserInfo["fee_switch"]!)"
        let commonCarge = "\(YMVar.MyUserInfo["fee"]!)"
        let f2fCarge = "\(YMVar.MyUserInfo["fee_face_to_face"]!)"
        
        CommonCharge?.text = commonCarge
        Face2FaceCharge?.text = f2fCarge
        if("1" == chargeSwitch) {
            SetChargeOn(true)
        } else {
            SetChargeOn(false)
        }
    }
    
    func UpdateVar() {
        if(ChargeSwitch.on) {
            YMVar.MyUserInfo["fee_switch"] = "1"
        } else {
            YMVar.MyUserInfo["fee_switch"] = "0"
        }
        
        YMVar.MyUserInfo["fee"] = CommonCharge?.text!
        YMVar.MyUserInfo["fee_face_to_face"] = Face2FaceCharge?.text!        
    }
    
    
    func UpdateSettings() {
        SettingActions!.UpadteSetting()
    }
}





































