//
//  PageWalletInfoActions.swift
//  YiMai
//
//  Created by superxing on 16/11/8.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

class PageWalletInfoActions: PageJumpActions {
    var TargetView: PageWalletInfoBodyView!
    var InfoApi: YMAPIUtility!
    var CashOutApi: YMAPIUtility!
    var ListApi: YMAPIUtility!
    
    override func ExtInit() {
        super.ExtInit()
        
        InfoApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_WALLET_INFO, success: GetInfoSuccess, error: GetInfoError)
        CashOutApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_CASH_OUT, success: CashOutSuccess, error: CashOutError)
        ListApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_BANKCARD_LIST, success: GetListSuccess, error: GetListError)
        
        TargetView = Target as! PageWalletInfoBodyView
    }
    
    func GetListSuccess(data: NSDictionary?) {
        let realBody = data!["data"] as? [[String: AnyObject]]
        
        if(0 == realBody?.count) {
            YMPageModalMessage.ShowConfirmInfo("尚未添加提现银行卡", info: "是否现在添加提现银行卡？", nav: NavController!, ok: { (_) in
                    self.DoJump(YMCommonStrings.CS_PAGE_BANK_CARD_LIST_NAME, ignoreExists: true)
                }, cancel: { (_) in
                    self.TargetView.FullPageLoading.Hide()
            })
        } else {
            self.TargetView.FullPageLoading.Hide()
            TargetView.ShowBankPicker(realBody!)
        }
    }
    
    func GetListError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        YMPageModalMessage.ShowErrorInfo("网络错误，请稍后再试", nav: NavController!)
        TargetView.FullPageLoading.Hide()
    }
    
    func GetInfoSuccess(data: NSDictionary?) {
        TargetView.FullPageLoading.Hide()
        if(nil == data) {
            return
        }

        let realData = data!["data"] as! [String: AnyObject]

        TargetView.LoadData(realData)
    }
    
    func CashOutSuccess(_: NSDictionary?) {
        YMPageModalMessage.ShowNormalInfo("申请提现成功，将于下个月20日之前结算到账。", nav: NavController!)
        TargetView.FullPageLoading.Hide()
    }
    
    func CashOutError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        YMPageModalMessage.ShowNormalInfo("网络故障，请稍后再试", nav: NavController!)
        TargetView.FullPageLoading.Hide()
    }
    
    func GetInfoError(error: NSError) {
        TargetView.FullPageLoading.Hide()
        YMAPIUtility.PrintErrorInfo(error)
    }
    
    func ShowCashDetail(gr: UIGestureRecognizer) {
        DoJump(YMCommonStrings.CS_PAGE_MY_WALLET_RECORD)
    }
    
    func CashOutTouched(_: UIButton) {
        TargetView.FullPageLoading.Show()
        ListApi.YMGetBankcardList()
    }
    
    func DoCashOut(bankInfo: [String : AnyObject]) {
        let id = YMVar.GetStringByKey(bankInfo, key: "id")
        TargetView.FullPageLoading.Show()
        CashOutApi.YMRequireCashOut(["id": id])
    }
}







