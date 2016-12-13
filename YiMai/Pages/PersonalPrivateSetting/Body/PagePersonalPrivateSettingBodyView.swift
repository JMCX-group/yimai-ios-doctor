//
//  PagePersonalPrivateSettingBodyView.swift
//  YiMai
//
//  Created by ios-dev on 16/6/26.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PagePersonalPrivateSettingBodyView: PageBodyView {
    private var privateActions: PagePersonalPrivateSettingActions? = nil
    private let FriendVerifySwitch = UISwitch()
    private let AllowAppointment = UISwitch()
    
    private let SubmitButton = YMButton()

    override func ViewLayout() {
        super.ViewLayout()
        
        privateActions = PagePersonalPrivateSettingActions(navController: self.NavController, target: self)
        var prev = DrawSwitchPanel("加我为好友时需要验证", switchBtn: FriendVerifySwitch, prev: nil)
        prev = DrawSwitchPanel("好友的好友可向我发起约诊", switchBtn: AllowAppointment, prev: prev)
        
        let btn = YMLayout.GetCommonFullWidthTouchableView(BodyView, useObject: privateActions!, useMethod: "BlacklistTouched:".Sel(),
                                                 label: UILabel(), text: "黑名单")
        btn.align(Align.UnderMatchingLeft, relativeTo: prev, padding: 0, width: YMSizes.PageWidth, height: btn.height)
        
        FriendVerifySwitch.addTarget(privateActions!, action: "SaveVerifyStatus:".Sel(), forControlEvents: UIControlEvents.ValueChanged)
        AllowAppointment.addTarget(privateActions!, action: "SaveAllowStatus:".Sel(), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    private func DrawSwitchPanel(text: String, switchBtn: UISwitch, prev: UIView?) -> UIView {
        let cell = UIView()
        
        BodyView.addSubview(cell)
        cell.backgroundColor = YMColors.White
        
        if(nil == prev) {
            cell.anchorToEdge(Edge.Top, padding: 70.LayoutVal(), width: YMSizes.PageWidth, height: 80.LayoutVal())
        } else {
            cell.align(Align.UnderMatchingLeft, relativeTo: prev!, padding: YMSizes.OnPx,
                       width: YMSizes.PageWidth, height: 80.LayoutVal())
        }
        
        let titleLabel = UILabel()
        titleLabel.text = text
        titleLabel.textColor = YMColors.FontGray
        titleLabel.font = YMFonts.YMDefaultFont(28.LayoutVal())
        titleLabel.sizeToFit()
        
        cell.addSubview(titleLabel)
        titleLabel.anchorToEdge(Edge.Left, padding: 40.LayoutVal(),
                                width: titleLabel.width, height: titleLabel.height)

        cell.addSubview(switchBtn)
        switchBtn.anchorToEdge(Edge.Right, padding: 40.LayoutVal(),
                               width: switchBtn.width, height: switchBtn.height)
        return cell
    }
    
    public func LoadData() {
        let privateInfo = YMLocalData.GetPrivateInfo()
        if(nil == privateInfo) {
            FriendVerifySwitch.on = true
            AllowAppointment.on = true
            
            YMLocalData.SavePrivateInfo(YMPersonalPrivateStrings.PRIVATE_FRIEND_VERIFY_KEY, data: true)
            YMLocalData.SavePrivateInfo(YMPersonalPrivateStrings.ALLOW_APPOINTMENT_KEY, data: true)
        } else {
            let verifyStatus = privateInfo?[YMPersonalPrivateStrings.PRIVATE_FRIEND_VERIFY_KEY] as? Bool
            let allowStatus = privateInfo?[YMPersonalPrivateStrings.ALLOW_APPOINTMENT_KEY] as? Bool
            
            if(nil != verifyStatus) {
                FriendVerifySwitch.on = verifyStatus!
            }
            
            if(nil != allowStatus) {
                AllowAppointment.on = allowStatus!
            }
        }
    }
}