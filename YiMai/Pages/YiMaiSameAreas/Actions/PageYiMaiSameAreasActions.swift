//
//  PageYiMaiSameAreasActions.swift
//  YiMai
//
//  Created by why on 16/5/27.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

public class PageYiMaiSameAreasActions: PageJumpActions, UIScrollViewDelegate{
    private var TargetView: PageYiMaiSameAreasBodyView? = nil
    private var SameApi: YMAPIUtility? = nil
    public var ThisCacheKey: String? = nil
    
    private var SearchByCityFlag = false
    private var SearchByKeyFlag = false
    private var SearchWord = ""
    private var SearchCity = ""
    
    override func ExtInit() {
        self.TargetView = self.Target as? PageYiMaiSameAreasBodyView
        SameApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_SAME_DEPARTMENT_LIST,
                               success: GetListSuccess, error: GetListError)
    }
    
    private func GetListSuccess(data: NSDictionary?) {
        TargetView?.Loading?.Hide()

        if(nil != ThisCacheKey) {
            YMCoreDataEngine.SaveData(ThisCacheKey!, data: data!)
            TargetView?.LoadHospitalList(data! as! [String : AnyObject])
        } else {
            TargetView?.PrevData = data! as? [String: AnyObject]
            YMLocalData.SaveData(data!, key: YMLocalDataStrings.SAME_DEPT_CACHE + YMVar.MyDoctorId)
            YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_SAME_DEPARTMENT, data: data!)
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
        YMAPIUtility.PrintErrorInfo(error)
        TargetView?.Loading?.Hide()
        ThisCacheKey = nil
    }
    
    public func GetSameAreasList(data: [String:AnyObject]?) {
        if(nil != data) {
            let field = YMVar.GetStringByKey(data!, key: "field")
            let city = YMVar.GetStringByKey(data!, key: "city")
            let hospital = YMVar.GetStringByKey(data!, key: "hospital")

            let cacheKey = "\(YMCoreDataKeyStrings.CS_SAME_DEPARTMENT).\(field).\(city).\(hospital)"
            
            let cache = YMCoreDataEngine.GetData(cacheKey) as? NSDictionary
            if(nil != cache) {
                let userInfo = cache!["users"] as? [[String: AnyObject]]
                TargetView?.DrawList(userInfo)
                TargetView?.Loading?.Hide()
            } else {
                ThisCacheKey = cacheKey
                SameApi?.YMGetSameDepartmentList(data)
            }
        } else {
            ThisCacheKey = nil
            SameApi?.YMGetSameDepartmentList(nil)
        }
    }
    
    public func DocCellTouched(sender: UIGestureRecognizer) {
        let cell = sender.view! as! YMTouchableView
        let docInfo = cell.UserObjectData as! [String: AnyObject]
        
        PageYiMaiDoctorDetailBodyView.DocId = "\(docInfo["id"]!)"
        DoJump(YMCommonStrings.CS_PAGE_YIMAI_DOCTOR_DETAIL_NAME)
    }

    public func DoSearch(input: YMTextField) {
//        let keyWord = input.text!
//        
//        SearchByCityFlag = false
//        SearchByKeyFlag = true
//
//        TargetView?.ClearList()
//        TargetView?.ClearFilters()
//        TargetView?.Loading?.Show()
//        GetSameAreasList(["field": keyWord])
        
        let keyWord = input.text!
        
        SearchByCityFlag = false
        SearchByKeyFlag = true
        
        SearchWord = keyWord
        if(YMValueValidator.IsBlankString(keyWord)) {
            SearchWord = ""
            input.text = ""
        }
        
        SearchCity = ""
        
        TargetView?.ClearList()
        TargetView?.ClearFilters()
        TargetView?.Loading?.Show()
        TargetView?.FilterByKey(SearchWord)
        TargetView?.Loading?.Hide()
    }
    
    public func DoParamSearch(param: [String: AnyObject]) {
//        TargetView?.ClearList()
//        TargetView?.Loading?.Show()
//        GetSameAreasList(param)
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
//        let key = TargetView?.SearchInput?.text
//        let cityData = cell.CellData as! [String: AnyObject]
//        let cityId = "\(cityData["id"]!)"
//        let cityName = "\(cityData["name"]!)"
//
//        SearchByCityFlag = true
//        SearchByKeyFlag = false
//
//        TargetView?.SetCity(cityName)
//        DoParamSearch(["field": key!, "city": cityId])
        
        let cityData = cell.CellData as! [String: AnyObject]
        let cityId = "\(cityData["id"]!)"
        let cityName = "\(cityData["name"]!)"
        
        TargetView?.ClearList()
        if("clear" == cityId) {
            TargetView?.FilterByKey(SearchWord)
        } else {
            SearchByCityFlag = true
            SearchByKeyFlag = false
            
            SearchCity = cityName
            
            TargetView?.SetCity(cityName)
            TargetView?.FilterByCity(cityName)
        }
    }
    
    public func HospitalTouched(cell: YMTableViewCell) {
//        let key = TargetView?.SearchInput?.text
//        let hodpitalData = cell.CellData as! [String: AnyObject]
//        let hospitalId = "\(hodpitalData["id"]!)"
//        let hospitalName = "\(hodpitalData["name"]!)"
//        
//        SearchByCityFlag = false
//        SearchByKeyFlag = false
//        TargetView?.SetHospital(hospitalName)
//        DoParamSearch(["field": key!, "hospital": hospitalId])
        
        let hodpitalData = cell.CellData as! [String: AnyObject]
        let hospitalId = "\(hodpitalData["id"]!)"
        let hospitalName = "\(hodpitalData["name"]!)"
        
        TargetView?.ClearList()
        if("clear" == hospitalId) {
            if("" != SearchCity) {
                TargetView?.FilterByCity(SearchCity)
            } else {
                TargetView?.FilterByKey(SearchWord)
            }
        } else {
            SearchByCityFlag = false
            SearchByKeyFlag = false
            
            TargetView?.SetHospital(hospitalName)
            TargetView?.FilterByHos(hospitalName)
        }
    }
    
    public func ProvTouched(cell: YMTableViewCell) {
        let data = cell.CellData as! [String: AnyObject]
        let provData = data["prov"] as! [String: AnyObject]
        
        let provId = "\(provData["id"]!)"
        
        if("clear" == provId) {
            TargetView?.ClearList()
            TargetView?.FilterByKey(SearchWord)
        }
    }
}




























