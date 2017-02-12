//
//  PageMyAdmissionListActions.swift
//  YiMai
//
//  Created by superxing on 16/11/23.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

class PageMyAdmissionListActions: PageJumpActions {
    var TargetView: PageMyAdmissionListBodyView!
    var GetListApi: YMAPIUtility!
    var ClearListApi: YMAPIUtility!
    
    var GetAppointmentApi: YMAPIUtility!
    
    override func ExtInit() {
        super.ExtInit()
        
        TargetView = Target as! PageMyAdmissionListBodyView
        
        GetListApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_ALL_NEW_ADMISSION_MSG, success: GetListSuccess, error: GetListError)
        ClearListApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_CLEAR_ALL_NEW_ADMISSION_MSG + "fromMsg", success: ClearListSuccess, error: ClearListError)
        GetAppointmentApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_APPOINTMENT_DETAIL + "fromMsg", success: GetAppointmentSuccess, error: GetAppointmentError)
    }
    
    func GetAppointmentSuccess(data: NSDictionary?) {
        TargetView.FullPageLoading.Hide()
        let detail = data!["other_info"] as! [String: AnyObject]
        let basic = data!["basic_info"] as! [String: AnyObject]
        
        let time = YMVar.GetStringByKey(basic, key: "date")
        let status = YMVar.GetStringByKey(detail, key: "status_code")
        let id = YMVar.GetStringByKey(basic, key: "appointment_id")

        if("wait-2" == status) {
            PageAppointmentAcceptBodyView.AppointmentID = id
            PageAppointmentAcceptBodyView.TimeInfo = time
            DoJump(YMCommonStrings.CS_PAGE_APPOINTMENT_ACCEPT_NAME, ignoreExists: false, userData: NSObject())
        } else if(status.containsString("wait")) {
            PageAppointmentProcessingBodyView.AppointmentID = id
            PageAppointmentProcessingBodyView.TimeInfo = time
            DoJump(YMCommonStrings.CS_PAGE_APPOINTMENT_PROCESSING_NAME, ignoreExists: false, userData: NSObject())
        } else {
            PageAppointmentDetailViewController.AppointmentID = id
            DoJump(YMCommonStrings.CS_PAGE_APPOINTMENT_DETAIL_NAME)
        }
    }
    
    func GetAppointmentError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        TargetView.FullPageLoading.Hide()
        YMPageModalMessage.ShowErrorInfo("网络错误，请稍后再试。", nav: self.NavController!)
    }
    
    func GetListSuccess(data: NSDictionary?) {
        if(nil == data) {
            return
        }

        let realData = data!["data"] as! [[String: AnyObject]]
        TargetView.LoadData(realData)
        TargetView.FullPageLoading.Hide()
    }
    
    func GetListError(error: NSError) {
        YMPageModalMessage.ShowErrorInfo("网络错误，请稍后再试。", nav: self.NavController!)
    }
    
    func ClearListSuccess(_: NSDictionary?) {}
    func ClearListError(error: NSError) {YMAPIUtility.PrintErrorInfo(error)}
    
    func CellTouched(gr: UIGestureRecognizer) {
        let cell = gr.view as! YMTouchableView
        
        let cellData = cell.UserObjectData as! [String: AnyObject]
        let id = "\(cellData["appointment_id"]!)"
        let msgId = YMVar.GetStringByKey(cellData, key: "id")
        
        //        data": {
        //        "id": "消息ID",
        //        "appointment_id": "约诊号; 用来跳转到对应的【预约记录】记录",
        //        "text": "显示文案",
        //        "type": "是否重要,0为不重要,1为重要; 重要的内容必须点开告知服务器变为已读; 不重要内容点开列表就全部变已读",
        //        "read": "是否已读,0为未读,1为已读; 该状态后期会将type为0的,获取时直接全部置为已读",
        //        "time": "时间"
        //    }
        
        for (idx, msg) in TargetView.PrevData.enumerate() {
            let thisId = YMVar.GetStringByKey(msg, key: "id")
            if(thisId == msgId) {
                TargetView.PrevData[idx]["read"] = "1"
                break
            }
        }
        
        ClearListApi.YMSetAdmissionRead(msgId)
        GetAppointmentApi.YMGetAdmissionDetail(id)
        
        TargetView.FullPageLoading.Show()
    }
    
    func SetAllReaden(_: AnyObject) {
        TargetView.FullPageLoading.Show()
        ClearListApi.YMClearAllNewAdmission()
        for (idx, _) in TargetView.PrevData.enumerate() {
            TargetView.PrevData[idx]["read"] = "1"
        }
        TargetView.LoadData(TargetView.PrevData)
        TargetView.FullPageLoading.Hide()
    }
}







