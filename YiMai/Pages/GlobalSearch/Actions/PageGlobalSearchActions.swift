//
//  PageGlobalSearchActions.swift
//  YiMai
//
//  Created by ios-dev on 16/6/27.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

public class PageGlobalSearchActions: PageJumpActions {
    private var TargetView: PageGlobalSearchBodyView? = nil
    private var SearchApi: YMAPIUtility? = nil
    private var CacheKey: String? = nil
    
    public var searchBy = "key"
    
    override func ExtInit() {
        super.ExtInit()
        
        TargetView = self.Target as? PageGlobalSearchBodyView
        SearchApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GLOBAL_SEARCH,
                                 success: SearchSuccess, error: SearchError)
    }
    
    public func SearchSuccess(data: NSDictionary?) {
        TargetView?.LoadData(data! as? [String: AnyObject])
        
        let realData = data as! [String: AnyObject]
        
        TargetView?.LastSearchData = realData

        if("key" == searchBy) {
            TargetView?.LoadCityList(realData)
            TargetView?.LoadHosList(realData)
            TargetView?.LoadDeptList(realData)
        } else if("city" == searchBy) {
            TargetView?.LoadHosList(realData)
            TargetView?.LoadDeptList(realData)
        } else if("hos" == searchBy) {
            TargetView?.LoadDeptList(realData)
        }
    }
    
    public func SearchError(error: NSError) {
        if(nil != error.userInfo["com.alamofire.serialization.response.error.response"]) {
            let response = error.userInfo["com.alamofire.serialization.response.error.response"]!
            let errInfo = JSON(data: error.userInfo["com.alamofire.serialization.response.error.data"] as! NSData)
            
            YMPageModalMessage.ShowNormalInfo("网络连接异常，请稍后再试。", nav: self.NavController!)

        } else {
            YMPageModalMessage.ShowErrorInfo("网络连接异常，请稍后再试。", nav: self.NavController!)
        }
    }
    
    public func DoSearch(param: [String: AnyObject]) {
//        CacheKey = "\(YMCoreDataKeyStrings.CS_GLOBAL_SEARCH).\(param["field"]!)"
//        let cache = YMCoreDataEngine.GetData(CacheKey!)
//        if(nil != cache) {
//            TargetView?.LoadData(cache! as! [String: AnyObject])
//        } else {
//            CacheKey = nil
//        }
        SearchApi?.YMGetSearchResult(param, progressHandler: nil)
    }
    
    public func KeyWordSearch(input: YMTextField) {
        let key = input.text
        searchBy = "key"
        
        if(YMValueValidator.IsEmptyString(key)) {
            input.text = TargetView?.LastSearchKey
            return
        }
        
        TargetView?.LastSearchKey = key!
        TargetView?.HighlightWord = ActiveType.Custom(pattern: key!)
        DoSearch(["field": key!])
    }
    
    public func CellTouched(sender: UIGestureRecognizer) {
        let cell = sender.view! as! YMTouchableView
        let docInfo = cell.UserObjectData as! [String: AnyObject]
        
        PageYiMaiDoctorDetailBodyView.DocId = "\(docInfo["id"]!)"
        DoJump(YMCommonStrings.CS_PAGE_YIMAI_DOCTOR_DETAIL_NAME)
    }
    
    public func ShowLv1FullList(_: UIGestureRecognizer) {
//        TargetView?.BodyView.contentOffset = CGPointMake(0, 0)
        TargetView?.ShowLv1FullList()
    }
    
    public func ShowLv2FullList(_: UIGestureRecognizer) {
//        TargetView?.BodyView.contentOffset = CGPointMake(0, 0)
        TargetView?.ShowLv2FullList()

    }
    
    public func ShowLv3FullList(_: UIGestureRecognizer) {
//        TargetView?.BodyView.contentOffset = CGPointMake(0, 0)
        TargetView?.ShowLv3FullList()
    }
    
    public func CityTouched(cell: YMTableViewCell) {
        searchBy = "city"
        
        let data = cell.CellData as! [String: AnyObject]
        let name = "\(data["name"]!)"

        TargetView?.CityList.hidden = true
        TargetView?.HosList.hidden = true
        TargetView?.DeptList.hidden = true
        TargetView?.FilterResultByCity(name)
    }
    
    public func ProvTouched(cell: YMTableViewCell) {
        let data = cell.CellData as! [String: AnyObject]
        let provData = data["prov"] as! [String: AnyObject]
        
        let provId = "\(provData["id"]!)"
        
        if("clear" == provId) {
            TargetView?.CityList.hidden = true
            TargetView?.HosList.hidden = true
            TargetView?.DeptList.hidden = true
            TargetView?.ResetFilter()
            
            searchBy = "key"
        }
    }

    public func HosTouched(cell: YMTableViewCell) {
        searchBy = "hos"
        
        let data = cell.CellData as! [String: AnyObject]
        let id = "\(data["id"]!)"
        let name = "\(data["name"]!)"
        TargetView?.CityList.hidden = true
        TargetView?.HosList.hidden = true
        TargetView?.DeptList.hidden = true
        TargetView?.FilterResultByHos(id, hosName: name)
    }
    
    public func DeptTouched(cell: YMTableViewCell) {
        searchBy = "dept"
        
        let data = cell.CellData as! [String: AnyObject]
        let id = "\(data["id"]!)"
        let deptName = "\(data["name"]!)"
        
        TargetView?.CityList.hidden = true
        TargetView?.HosList.hidden = true
        TargetView?.DeptList.hidden = true
        TargetView?.FilterResultByDept(id, deptName: deptName)
    }
    
    public func CityFilterTouched(_: UIGestureRecognizer) {
        TargetView?.CityList.hidden = !TargetView!.CityList.hidden
        TargetView?.HosList.hidden = true
        TargetView?.DeptList.hidden = true
    }
    
    public func HosFilterTouched(_: UIGestureRecognizer) {
        TargetView?.HosList.hidden = !TargetView!.HosList.hidden
        TargetView?.CityList.hidden = true
        TargetView?.DeptList.hidden = true

    }
    
    public func DeptFilterTouched(_: UIGestureRecognizer) {
        TargetView?.DeptList.hidden = !TargetView!.DeptList.hidden
        TargetView?.HosList.hidden = true
        TargetView?.CityList.hidden = true

    }
}






























