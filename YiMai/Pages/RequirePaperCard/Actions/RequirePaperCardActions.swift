//
//  RequirePaperCardActions.swift
//  YiMai
//
//  Created by Wang Huaiyu on 16/9/24.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class RequirePaperCardActions: PageJumpActions {
    var TargetView: RequirePaperCardBodyView!
    
    override func ExtInit() {
        super.ExtInit()
        
        TargetView = Target as! RequirePaperCardBodyView
    }
    
    func AddrLoaded(text: String) {
        if(YMValueValidator.IsEmptyString(text)) {
            return
        }
        TargetView.AddresseeAddr = text
        let textLabel = TargetView.AddresseeAddrCell.UserObjectData as! UILabel
        textLabel.text = text
        
        TargetView.VerifyAddresseeInfo()
    }
    
    func NameLoaded(text: String) {
        if(YMValueValidator.IsEmptyString(text)) {
            return
        }
        TargetView.AddresseeName = text
        let textLabel = TargetView.AddresseeNameCell.UserObjectData as! UILabel
        textLabel.text = text
        
        TargetView.VerifyAddresseeInfo()
    }
    
    func PhoneLoaded(text: String) {
        if(YMValueValidator.IsEmptyString(text)) {
            return
        }
        TargetView.AddresseePhone = text
        let textLabel = TargetView.AddresseePhoneCell.UserObjectData as! UILabel
        textLabel.text = text
        
        TargetView.VerifyAddresseeInfo()
    }
    
    func AddrTouched(gr: UIGestureRecognizer) {
        PageCommonTextInputViewController.TitleString = "收件人地址"
        PageCommonTextInputViewController.Placeholder = "请输入收件人地址（最多200字）"
        PageCommonTextInputViewController.InputType = PageCommonTextInputType.Text
        PageCommonTextInputViewController.InputMaxLen = 200
        PageCommonTextInputViewController.Result = AddrLoaded
        
        DoJump(YMCommonStrings.CS_PAGE_COMMON_TEXT_INPUT)
    }
    
    func NameTouched(gr: UIGestureRecognizer) {
        PageCommonTextInputViewController.TitleString = "收件人姓名"
        PageCommonTextInputViewController.Placeholder = "请输入收件人姓名"
        PageCommonTextInputViewController.InputType = PageCommonTextInputType.Text
        PageCommonTextInputViewController.InputMaxLen = 20
        PageCommonTextInputViewController.Result = NameLoaded
        
        DoJump(YMCommonStrings.CS_PAGE_COMMON_TEXT_INPUT)
    }
    
    func PhoneTouched(gr: UIGestureRecognizer) {
        PageCommonTextInputViewController.TitleString = "收件人联系电话"
        PageCommonTextInputViewController.Placeholder = "请输入收件人联系电话"
        PageCommonTextInputViewController.InputType = PageCommonTextInputType.Tel
        PageCommonTextInputViewController.Result = PhoneLoaded
        
        DoJump(YMCommonStrings.CS_PAGE_COMMON_TEXT_INPUT)
    }
    
    func GoPreview(_: YMButton) {
        PaperCardPreviewBodyView.AddressInfo["address"] = TargetView!.AddresseeAddr
        PaperCardPreviewBodyView.AddressInfo["addressee"] = TargetView!.AddresseeName
        PaperCardPreviewBodyView.AddressInfo["receive_phone"] = TargetView!.AddresseePhone
        
                if(YMValueValidator.IsEmptyString(TargetView!.AddresseeAddr)) {
                    YMPageModalMessage.ShowErrorInfo("请输入收件人地址", nav: NavController!)
                    return
                }
        
                if(YMValueValidator.IsEmptyString(TargetView!.AddresseeAddr)) {
                    YMPageModalMessage.ShowErrorInfo("请输入收件人姓名", nav: NavController!)
                    return
                }
        
                if(YMValueValidator.IsEmptyString(TargetView!.AddresseeAddr)) {
                    YMPageModalMessage.ShowErrorInfo("请输入收件人手机号", nav: NavController!)
                    return
                }

        DoJump(YMCommonStrings.CS_PAGE_PAPER_CARD_PREVIEW)
    }
}











