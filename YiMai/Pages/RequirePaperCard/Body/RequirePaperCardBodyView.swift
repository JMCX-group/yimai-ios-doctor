//
//  RequirePaperCardBodyView.swift
//  YiMai
//
//  Created by Wang Huaiyu on 16/9/24.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class RequirePaperCardBodyView: PageBodyView {
    var RequireActions: RequirePaperCardActions!
    var PreviewButton = YMButton()
    
    var AddresseeName = ""
    var AddresseeAddr = ""
    var AddresseePhone = ""
    
    var AddresseeNameCell: YMTouchableView!
    var AddresseeAddrCell: YMTouchableView!
    var AddresseePhoneCell: YMTouchableView!

    override func ViewLayout() {
        super.ViewLayout()
        RequireActions = RequirePaperCardActions(navController: self.NavController!, target: self)
        
    }
    
    func GetCell(title: String, text: String, prev: UIView? = nil, sel: Selector? = nil) -> YMTouchableView {
        var cell: YMTouchableView!
        if(nil != sel) {
            cell = YMLayout.GetTouchableView(useObject: RequireActions, useMethod: sel!)
        } else {
            cell = YMTouchableView()
            cell.backgroundColor = YMColors.White
        }

        let titleLabel = YMLayout.GetNomalLabel(title, textColor: YMColors.FontGray, fontSize: 28.LayoutVal())
        let textLabel = YMLayout.GetNomalLabel(text, textColor: YMColors.FontLightGray, fontSize: 28.LayoutVal())
        let borderLine = UIView()
        borderLine.backgroundColor = YMColors.DividerLineGray
        
        BodyView.addSubview(cell)
        if(nil == prev) {
            cell.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 80.LayoutVal())
        } else {
            cell.align(Align.UnderMatchingLeft, relativeTo: prev!, padding: 0, width: YMSizes.PageWidth, height: 80.LayoutVal())
        }

        cell.addSubview(titleLabel)
        cell.addSubview(textLabel)
        cell.addSubview(borderLine)

        titleLabel.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: titleLabel.width, height: titleLabel.height)
        textLabel.textAlignment = NSTextAlignment.Right
        textLabel.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: 500.LayoutVal(), height: textLabel.height)
        
        borderLine.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: YMSizes.OnPx)

        cell.UserObjectData = textLabel
        return cell
    }
    
    func EnablePreview() {
        PreviewButton.enabled = true
        PreviewButton.backgroundColor = YMColors.CommonBottomBlue
    }
    
    func DisablePreview() {
        PreviewButton.enabled = false
        PreviewButton.backgroundColor = YMColors.White
    }
    
    func DrawFullBody() {
        YMLayout.ClearView(view: BodyView)
        
        AddresseeName = ""
        AddresseeAddr = ""
        AddresseePhone = ""
        
        var name = YMVar.MyUserInfo["name"] as? String
        var jobTitle = YMVar.MyUserInfo["job_title"] as? String
        let hospital = YMVar.MyUserInfo["hospital"] as? [String: AnyObject]
        let dept = YMVar.MyUserInfo["department"] as? [String: AnyObject]
        
        var hosName: String? = nil
        var deptName: String? = nil
        if(nil != hospital) {
            hosName = hospital!["name"] as? String
            if(nil == hosName) {
                hosName = ""
            }
        }
        
        if(nil != hospital) {
            deptName = dept!["name"] as? String
            if(nil == deptName) {
                deptName = ""
            }
        }
        
        if(nil == jobTitle) {
            jobTitle = ""
        }
        
        if(nil == name) {
            name = ""
        }
        
        var cell = GetCell("医院", text: hosName!)
        cell = GetCell("科室", text: deptName!, prev: cell)
        cell = GetCell("级别", text: jobTitle!, prev: cell)
        cell = GetCell("张数", text: "200", prev: cell)
        AddresseeAddrCell = GetCell("地址", text: "请填写", prev: cell, sel: "AddrTouched:".Sel())
        AddresseeNameCell = GetCell("收件人姓名", text: "请填写", prev: AddresseeAddrCell, sel: "NameTouched:".Sel())
        AddresseePhoneCell = GetCell("收件手机号", text: "请填写", prev: AddresseeNameCell, sel: "PhoneTouched:".Sel())
        
        let cardExample = YMLayout.GetSuitableImageView("CardStyleExample")
        BodyView.addSubview(cardExample)
        cardExample.align(Align.UnderCentered, relativeTo: AddresseePhoneCell,
                          padding: 0, width: cardExample.width, height: cardExample.height)
        
        PreviewButton.setTitle("预览", forState: UIControlState.Normal)
        PreviewButton.setTitleColor(YMColors.FontGray, forState: UIControlState.Disabled)
        PreviewButton.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        PreviewButton.enabled = false
        PreviewButton.backgroundColor = YMColors.White
        PreviewButton.titleLabel?.font = YMFonts.YMDefaultFont(32.LayoutVal())
        
        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: cardExample, padding: 128.LayoutVal())
        
        ParentView?.addSubview(PreviewButton)
        PreviewButton.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: 98.LayoutVal())
        
        PreviewButton.addTarget(RequireActions, action: "GoPreview:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)

        let required = "\(YMVar.MyUserInfo["application_card"]!)"
        if("1" == required) {
            PreviewButton.setTitle("已申请", forState: UIControlState.Normal)
            DisablePreview()
            
            AddresseeAddrCell.removeFromSuperview()
            AddresseeNameCell.removeFromSuperview()
            AddresseePhoneCell.removeFromSuperview()
            
            AddresseeAddr = YMVar.GetStringByKey(YMVar.MyUserInfo, key: "address")
            AddresseeName = YMVar.GetStringByKey(YMVar.MyUserInfo, key: "addressee")
            AddresseePhone = YMVar.GetStringByKey(YMVar.MyUserInfo, key: "receive_phone")
            
            AddresseeAddrCell = GetCell("地址", text: AddresseeAddr, prev: cell)
            AddresseeNameCell = GetCell("收件人姓名", text: AddresseeName, prev: AddresseeAddrCell)
            AddresseePhoneCell = GetCell("收件手机号", text: AddresseePhone, prev: AddresseeNameCell)
        }
    }
    
    func VerifyAddresseeInfo() {
        if(YMValueValidator.IsEmptyString(AddresseeAddr)) {
            DisablePreview()
            return
        }
        
        if(YMValueValidator.IsEmptyString(AddresseeName)) {
            DisablePreview()
            return
        }
        
        if(YMValueValidator.IsEmptyString(AddresseePhone)) {
            DisablePreview()
            return
        }
        
        EnablePreview()
    }
}








