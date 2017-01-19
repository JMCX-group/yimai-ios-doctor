//
//  ApointmentAcceptDetailActions.swift
//  YiMai
//
//  Created by superxing on 16/8/31.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class ApointmentAcceptDetailActions: PageJumpActions {
    private var TargetBodyView: ApointmentAcceptDetailBodyView? = nil
    private var SubmitApi: YMAPIUtility? = nil

    public override func ExtInit() {
        super.ExtInit()
        
        self.TargetBodyView = self.Target as? ApointmentAcceptDetailBodyView
        SubmitApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_ACCEPT_APPOINTMENT,
                                 success: self.SubmitSuccess, error: self.SubmitError)
    }
    
    public func SubmitSuccess(data: NSDictionary?) {
        self.DoJump(YMCommonStrings.CS_PAGE_MY_ADMISSIONS_LIST_NAME)
    }
    
    public func SubmitError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        self.DoJump(YMCommonStrings.CS_PAGE_MY_ADMISSIONS_LIST_NAME)
    }
    
    public func SelectTimeCellTouched(sender: UIGestureRecognizer) {
        TargetBodyView?.ShowAdmissionTime()
    }
    
    public func HospitalTouched(sender: UIGestureRecognizer) {
        
    }
    
    public func KeyboardWillShow(aNotification: NSNotification) {
        TargetBodyView?.KeyboardWillShow(aNotification)
    }
    
    public func SubmitTouched(sender: YMButton) {
//        self.DoJump(YMCommonStrings.CS_PAGE_MY_ADMISSIONS_LIST_NAME)
        SubmitApi?.YMAdmissionAgree(["id": PageAppointmentAcceptBodyView.AppointmentID,
            "visit_time": TargetBodyView!.AdmissionTimeString,
            "supplement": TargetBodyView!.DescInput.text,
            "remark": TargetBodyView!.NeedToKnowInput.text])
    }
    
    public func AdmissionTimeSelected(sender: YMButton) {
        TargetBodyView?.SetAdmissionTime()
    }
    
    func ConfirmSaveCommonText(text: String?) {
        let CommonTextDataIndex = "\(YMVar.MyDoctorId).CommonText"
        
        var commonTextArr = YMLocalData.GetData(CommonTextDataIndex) as? [String]
        if(nil == commonTextArr) {
            commonTextArr = [String]()
        }
        if(YMValueValidator.IsBlankString(text)) {
            return
        }
        
        YMPageModalMessage.ShowConfirmInfo("将以下文字保存至常用文本", info: text!, nav: NavController!, ok: { (_) in
            if(!commonTextArr!.contains(text!)) {
                commonTextArr!.append(text!)
            }
            YMLocalData.SaveData(commonTextArr!, key: CommonTextDataIndex)
            }, cancel: nil)
    }
    
    func SetDescFromCommonText(text: String) {
        TargetBodyView?.DescInput.text = text
        
        TargetBodyView?.DescInput.resignFirstResponder()
        TargetBodyView?.NeedToKnowInput.resignFirstResponder()
    }
    
    func SetNeedToKnowFromCommonText(text: String) {
        TargetBodyView?.NeedToKnowInput.text = text
        
        TargetBodyView?.DescInput.resignFirstResponder()
        TargetBodyView?.NeedToKnowInput.resignFirstResponder()
    }
    
    func SaveDescToCommonText(gr: UIGestureRecognizer) {
        ConfirmSaveCommonText(TargetBodyView?.DescInput.text)
    }
    
    func GetDescFromCommonText(gr: UIGestureRecognizer) {
        DoJump(YMCommonStrings.CS_PAGE_ACCEPET_COMMON_TEXT, ignoreExists: false, userData: SetDescFromCommonText)
    }
    
    func SaveNeedToKnowToCommonText(gr: UIGestureRecognizer) {
        ConfirmSaveCommonText(TargetBodyView?.NeedToKnowInput.text)
    }
    
    func GetNeedToKnowFromCommonText(gr: UIGestureRecognizer) {
        DoJump(YMCommonStrings.CS_PAGE_ACCEPET_COMMON_TEXT, ignoreExists: false, userData: SetNeedToKnowFromCommonText)
    }
}












