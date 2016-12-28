//
//  PageAppointmentUpdateViewController.swift
//  YiMai
//
//  Created by why on 16/5/27.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageAppointmentUpdateViewController: PageViewController {
    private var Actions: PageAppointmentUpdateActions? = nil
    public var BodyView: PageAppointmentUpdateBodyView? = nil
    public var Loading: YMPageLoadingView? = nil
    
    public static var SelectedDoctor:[String: AnyObject]? = nil
    public static var PatientBasicInfo: [String: String]? = nil
    public static var PatientCondition: String = ""
    public static var SelectedTime: String = ""
    public static var SelectedTimeForUpload: [String]? = nil
    
    public static var AppointmentData: [String: AnyObject]? = nil

    override func PageLayout() {
        super.PageLayout()
        Actions = PageAppointmentUpdateActions(navController: self.NavController, target: self)
        BodyView = PageAppointmentUpdateBodyView(parentView: self.SelfView!, navController: self.NavController!, pageActions: Actions!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "代约", navController: self.NavController!)
        
        Loading = YMPageLoadingView(parentView: self.view)
    }

    override func PagePreRefresh() {
        PageAppointmentUpdateViewController.PatientBasicInfo = nil
        PageAppointmentUpdateViewController.PatientCondition = ""
        PageAppointmentUpdateViewController.SelectedTime = ""
        
        BodyView?.BodyView.removeFromSuperview()
        TopView?.TopViewPanel.removeFromSuperview()
        
        BodyView = PageAppointmentUpdateBodyView(parentView: self.SelfView!, navController: self.NavController!, pageActions: Actions!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "代约", navController: self.NavController!)
        
        BodyView?.Reload()
        if(nil != VerifyInput(false)) {
            BodyView?.SetConfirmEnable()
        } else {
            BodyView?.SetConfirmDisable()
        }
    }

    public func VerifyInput(showAlarm: Bool = true) -> [String:String]? {
        if(nil == PageAppointmentUpdateViewController.PatientBasicInfo) {
            if(showAlarm) {
                YMPageModalMessage.ShowErrorInfo("请填写病人基本信息！", nav: self.NavController!)
            }
            return nil
        }
        
        if(nil == PageAppointmentUpdateViewController.SelectedDoctor) {
            if(showAlarm) {
                YMPageModalMessage.ShowErrorInfo("请选择医生！", nav: self.NavController!)
            }
            return nil
        }

        let doctor = PageAppointmentUpdateViewController.SelectedDoctor!
        
        let ret =
            [
                "doctor": "\(doctor[YMYiMaiStrings.CS_DATA_KEY_USER_ID]!)"
        ]
        
        return ret
    }
}





















