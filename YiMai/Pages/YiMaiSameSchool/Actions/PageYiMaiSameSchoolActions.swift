//
//  PageYiMaiSameSchoolActions.swift
//  YiMai
//
//  Created by why on 16/5/27.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

public class PageYiMaiSameSchoolActions: PageJumpActions, UIScrollViewDelegate{
    private var TargetView: PageYiMaiSameSchoolBodyView? = nil
    private var SameApi: YMAPIUtility? = nil
    public var ThisCacheKey: String? = nil
    
    private var SearchByCityFlag = false
    private var SearchByKeyFlag = false
    
    override func ExtInit() {
        self.TargetView = self.Target as? PageYiMaiSameSchoolBodyView
        SameApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_SAME_COLLEGE_LIST,
                               success: GetListSuccess, error: GetListError)
    }
    
    private func GetListSuccess(data: NSDictionary?) {
        TargetView?.Loading?.Hide()
        
        if(nil != ThisCacheKey) {
            YMCoreDataEngine.SaveData(ThisCacheKey!, data: data!)
            TargetView?.LoadHospitalList(data! as! [String : AnyObject])
        } else {
            YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_SAME_SAMECOLLEGE, data: data!)
            TargetView?.LoadCityList(data! as! [String : AnyObject])
            TargetView?.LoadHospitalList(data! as! [String : AnyObject])
        }
        
        if(SearchByCityFlag || SearchByKeyFlag) {
            TargetView?.LoadHospitalList(data! as! [String : AnyObject])
        }
        
        if(SearchByKeyFlag) {
            TargetView?.LoadCityList(data! as! [String : AnyObject])
        }
        
        let userInfo = data!["users"] as? [[String: AnyObject]]
        TargetView?.DrawList(userInfo)
    }
    
    private func GetListError(error: NSError) {
        if(nil != error.userInfo["com.alamofire.serialization.response.error.response"]) {
            let errInfo = JSON(data: error.userInfo["com.alamofire.serialization.response.error.data"] as! NSData)
            print(errInfo)
        }
        TargetView?.Loading?.Hide()
        ThisCacheKey = nil
    }
    
    public func GetSameSchoolList(data: [String:AnyObject]?) {
        SameApi?.YMGetSameCollegeList(data)
    }
    
    public func DocCellTouched(sender: UIGestureRecognizer) {
        let cell = sender.view! as! YMTouchableView
        let docInfo = cell.UserObjectData as! [String: AnyObject]
        
        PageYiMaiDoctorDetailBodyView.DocId = "\(docInfo["id"]!)"
        DoJump(YMCommonStrings.CS_PAGE_YIMAI_DOCTOR_DETAIL_NAME)
    }
    
    public func DoSearch(input: YMTextField) {
        let keyWord = input.text!
        
        SearchByCityFlag = false
        SearchByKeyFlag = true
        
        TargetView?.ClearList()
        TargetView?.ClearFilters()
        TargetView?.Loading?.Show()
        GetSameSchoolList(["field": keyWord])
    }
    
    public func DoParamSearch(param: [String: AnyObject]) {
        TargetView?.ClearList()
        TargetView?.Loading?.Show()
        GetSameSchoolList(param)
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let offsetHeight = scrollView.contentOffset.y + scrollView.height
        
        if(offsetHeight > contentHeight) {
            TargetView?.DrawList()
        }
    }
    
    public func CityFilterTouched(_: UIGestureRecognizer) {
        TargetView?.CityFilterList.hidden = !TargetView!.CityFilterList.hidden
        TargetView?.HospitalFilterList.hidden = true
    }
    
    public func HospitalFilterTouched(_: UIGestureRecognizer) {
        TargetView?.HospitalFilterList.hidden = !TargetView!.HospitalFilterList.hidden
        TargetView?.CityFilterList.hidden = true
    }
    
    public func CityTouched(cell: YMTableViewCell) {
        let key = TargetView?.SearchInput?.text
        let cityData = cell.CellData as! [String: AnyObject]
        let cityId = "\(cityData["id"]!)"
        let cityName = "\(cityData["name"]!)"
        
        SearchByCityFlag = true
        SearchByKeyFlag = false
        
        TargetView?.SetCity(cityName)
        DoParamSearch(["field": key!, "city": cityId])
    }
    
    public func HospitalTouched(cell: YMTableViewCell) {
        let key = TargetView?.SearchInput?.text
        let hodpitalData = cell.CellData as! [String: AnyObject]
        let hospitalId = "\(hodpitalData["id"]!)"
        let hospitalName = "\(hodpitalData["name"]!)"
        
        SearchByCityFlag = false
        SearchByKeyFlag = false
        TargetView?.SetHospital(hospitalName)
        DoParamSearch(["field": key!, "hospital": hospitalId])
    }
}
