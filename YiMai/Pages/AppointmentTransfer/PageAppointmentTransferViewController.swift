//
//  PageAppointmentTransferViewController.swift
//  YiMai
//
//  Created by why on 16/5/27.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageAppointmentTransferViewController: PageViewController {
    private var Actions: PageAppointmentTransferActions? = nil
    public var BodyView: PageAppointmentTransferBodyView? = nil
    public var Loading: YMPageLoadingView? = nil
    
    public static var SelectedDoctor:[String: AnyObject]? = nil
    public static var PatientBasicInfo: [String: String]? = nil
    public static var PatientCondition: String = ""
    public static var SelectedTime: String = ""
    public static var SelectedTimeForUpload: [String]? = nil
    
    public static var AppointmentData: [String: AnyObject]? = nil
    
    public static var NewAppointment = true

    override func PageLayout() {
        super.PageLayout()
        Actions = PageAppointmentTransferActions(navController: self.NavController, target: self)
        BodyView = PageAppointmentTransferBodyView(parentView: self.SelfView!, navController: self.NavController!, pageActions: Actions!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "预约", navController: self.NavController!)
        
        Loading = YMPageLoadingView(parentView: self.view)
    }

    override func PagePreRefresh() {
//        if(PageAppointmentTransferViewController.NewAppointment) {
//            
//            PageAppointmentTransferViewController.SelectedDoctor = nil
//            PageAppointmentTransferViewController.PatientBasicInfo = nil
//            PageAppointmentTransferViewController.PatientCondition = ""
//            PageAppointmentTransferViewController.SelectedTime = ""
//            
//            BodyView?.BodyView.removeFromSuperview()
//            TopView?.TopViewPanel.removeFromSuperview()
//            
//            BodyView = PageAppointmentTransferBodyView(parentView: self.SelfView!, navController: self.NavController!, pageActions: Actions!)
//            TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "预约", navController: self.NavController!)
//            PageAppointmentTransferViewController.NewAppointment = false
//        } else {
//            BodyView?.Reload()
//            if(nil != VerifyInput(false)) {
//                BodyView?.SetConfirmEnable()
//            } else {
//                BodyView?.SetConfirmDisable()
//            }
//        }
        
//        PageAppointmentTransferViewController.SelectedDoctor = nil
        PageAppointmentTransferViewController.PatientBasicInfo = nil
        PageAppointmentTransferViewController.PatientCondition = ""
        PageAppointmentTransferViewController.SelectedTime = ""
        
        BodyView?.BodyView.removeFromSuperview()
        TopView?.TopViewPanel.removeFromSuperview()
        
        BodyView = PageAppointmentTransferBodyView(parentView: self.SelfView!, navController: self.NavController!, pageActions: Actions!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "转诊", navController: self.NavController!)
        PageAppointmentTransferViewController.NewAppointment = false
        
        BodyView?.Reload()
        if(nil != VerifyInput(false)) {
            BodyView?.SetConfirmEnable()
        } else {
            BodyView?.SetConfirmDisable()
        }
    }

    public func VerifyInput(showAlarm: Bool = true) -> [String:String]? {
        if(nil == PageAppointmentTransferViewController.PatientBasicInfo) {
            if(showAlarm) {
                YMPageModalMessage.ShowErrorInfo("请填写病人基本信息！", nav: self.NavController!)
            }
            return nil
        }
        
        if(nil == PageAppointmentTransferViewController.SelectedDoctor) {
            if(showAlarm) {
                YMPageModalMessage.ShowErrorInfo("请选择医生！", nav: self.NavController!)
            }
            return nil
        }

        let doctor = PageAppointmentTransferViewController.SelectedDoctor!
        
        let ret =
            [
                "doctor": "\(doctor[YMYiMaiStrings.CS_DATA_KEY_USER_ID]!)"
        ]
        
        return ret
    }
}





















