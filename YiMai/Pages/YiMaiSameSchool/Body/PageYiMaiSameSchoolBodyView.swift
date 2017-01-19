//
//  PageYiMaiSameSchoolBodyView.swift
//  YiMai
//
//  Created by why on 16/5/27.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageYiMaiSameSchoolBodyView: PageBodyView {
    public var Loading: YMPageLoadingView? = nil
    private var SameSchoolActions: PageYiMaiSameSchoolActions? = nil
    private let ResultList = UIScrollView()
    public var SearchInput: YMTextField? = nil
    private var SearchPanel = UIView()
    
    private var ListPos: Int = 0
    private var NextPos: Int = 15
    private let Step:Int = 15
    private var LastCell: YMTouchableView? = nil
    private var NoMoreUser: Bool = false
    
    private let FiltersPanel = UIView()
    public let CityFilterList = UIView()
    public let HospitalFilterList = UIView()
    
    private var CityFilterButton: YMTouchableView? = nil
    private var HospitalFilterButton: YMTouchableView? = nil
    
    public var UserList: [[String: AnyObject]]? = nil
    public var CurrentCity: [String: AnyObject]? = nil
    public var CurrentHospital: [String: AnyObject]? = nil
    
    var PrevData: [String: AnyObject]? = nil
    var FilterResult: [[String: AnyObject]]? = nil
    
    var BlankContentPanel = UIView()
    
    override func ViewLayout() {
        super.ViewLayout()
        
        SameSchoolActions = PageYiMaiSameSchoolActions(navController: self.NavController!, target: self)
        Loading = YMPageLoadingView(parentView: BodyView)
        DrawSearchPanel()
        DrawFiltersPanel()
        DrawListPanel()
        DrawCityList()
        DrawHospitalList()
    }
    
    private func DrawFiltersPanel() {
        BodyView.addSubview(FiltersPanel)
        FiltersPanel.align(Align.UnderMatchingLeft, relativeTo: SearchPanel,
                           padding: 0, width: YMSizes.PageWidth, height: 80.LayoutVal())
        
        
        CityFilterButton = YMLayout.GetTouchableView(useObject: SameSchoolActions!, useMethod: "CityFilterTouched:".Sel())
        HospitalFilterButton = YMLayout.GetTouchableView(useObject: SameSchoolActions!, useMethod: "HospitalFilterTouched:".Sel())
        FiltersPanel.addSubview(CityFilterButton!)
        FiltersPanel.addSubview(HospitalFilterButton!)
        FiltersPanel.groupAndFill(group: Group.Horizontal,
                                  views: [CityFilterButton!, HospitalFilterButton!], padding: 0)
        
        func DrawFilterButton(button: YMTouchableView, text: String) {
            let titleLabel = UILabel()
            titleLabel.text = text
            titleLabel.textColor = YMColors.FontGray
            titleLabel.font = YMFonts.YMDefaultFont(28.LayoutVal())
            titleLabel.sizeToFit()
            
            button.addSubview(titleLabel)
            let titleMaxWidth = button.width - 40.LayoutVal()
            if(titleLabel.width > titleMaxWidth){
                titleLabel.anchorInCenter(width: titleMaxWidth, height: titleLabel.height)
            } else {
                titleLabel.anchorInCenter(width: titleLabel.width, height: titleLabel.height)
            }
            
            let arrIcon = YMLayout.GetSuitableImageView("YMIconFilterButtonArrow")
            button.addSubview(arrIcon)
            arrIcon.align(Align.ToTheRightCentered, relativeTo: titleLabel,
                          padding: 12.LayoutVal(), width: arrIcon.width, height: arrIcon.height)
            
            button.UserObjectData = ["label": titleLabel, "icon": arrIcon]
        }
        
        DrawFilterButton(CityFilterButton!, text: "城市")
        DrawFilterButton(HospitalFilterButton!, text: "医院")
        
        let bottom = UIView()
        FiltersPanel.addSubview(bottom)
        bottom.backgroundColor = YMColors.DividerLineGray
        bottom.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: YMSizes.OnPx)
        
        let divider = UIView()
        divider.backgroundColor = YMColors.FontBlue
        FiltersPanel.addSubview(divider)
        divider.anchorInCenter(width: YMSizes.OnPx, height: 20.LayoutVal())
    }
    
    private func DrawSearchPanel() {
        BodyView.addSubview(SearchPanel)
        SearchPanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 120.LayoutVal())
        SearchPanel.backgroundColor = YMColors.BackgroundGray
        
        let param = TextFieldCreateParam()
        param.BackgroundImageName = "YiMaiGeneralLongSearchBackground"
        param.FontColor = YMColors.FontBlue
        param.Placholder = "搜索"
        param.FontSize = 26.LayoutVal()
        
        let searchIconView = UIView(frame: CGRect(x: 0,y: 0,width: 66.LayoutVal(), height: 60.LayoutVal()))
        let searchIcon = YMLayout.GetSuitableImageView("YiMaiGeneralSearchIcon")
        
        searchIconView.addSubview(searchIcon)
        searchIcon.anchorInCenter(width: searchIcon.width, height: searchIcon.height)
        
        SearchInput = YMLayout.GetTextFieldWithMaxCharCount(param, maxCharCount: 20)
        SearchInput?.SetLeftPadding(searchIconView)
        SearchInput?.SetRightPaddingWidth(20.LayoutVal())
        
        SearchPanel.addSubview(SearchInput!)
        SearchInput?.anchorInCenter(width: 690.LayoutVal(), height: 60.LayoutVal())
        
        SearchInput?.EditEndCallback = SameSchoolActions?.DoSearch
    }
    
    public func SetCity(cityName: String) {
        let cityBtnData = CityFilterButton?.UserObjectData as! [String: AnyObject]
        let cityLabel = cityBtnData["label"] as! UILabel
        let cityIcon = cityBtnData["icon"] as! UIImageView
        
        let hosBtnData = HospitalFilterButton?.UserObjectData as! [String: AnyObject]
        let hosLabel = hosBtnData["label"] as! UILabel
        let hosIcon = hosBtnData["icon"] as! UIImageView
        
        cityIcon.hidden = true
        cityLabel.text = cityName
        cityLabel.sizeToFit()
        
        let titleMaxWidth = CityFilterButton!.width - 40.LayoutVal()
        if(cityLabel.width > titleMaxWidth){
            cityLabel.anchorInCenter(width: titleMaxWidth, height: cityLabel.height)
        } else {
            cityLabel.anchorInCenter(width: cityLabel.width, height: cityLabel.height)
        }
        
        hosIcon.hidden = false
        hosLabel.text = "医院"
        hosLabel.sizeToFit()
        hosLabel.anchorInCenter(width: hosLabel.width, height: hosLabel.height)
    }
    
    public func SetHospital(hospitalName: String) {
        //        let cityBtnData = CityFilterButton?.UserObjectData as! [String: AnyObject]
        //        let cityLabel = cityBtnData["label"] as! UILabel
        //        let cityIcon = cityBtnData["icon"] as! UIImageView
        
        let hosBtnData = HospitalFilterButton?.UserObjectData as! [String: AnyObject]
        let hosLabel = hosBtnData["label"] as! UILabel
        let hosIcon = hosBtnData["icon"] as! UIImageView
        
        hosIcon.hidden = true
        hosLabel.text = hospitalName
        hosLabel.sizeToFit()
        
        let titleMaxWidth = CityFilterButton!.width - 40.LayoutVal()
        if(hosLabel.width > titleMaxWidth){
            hosLabel.anchorInCenter(width: titleMaxWidth, height: hosLabel.height)
        } else {
            hosLabel.anchorInCenter(width: hosLabel.width, height: hosLabel.height)
        }
        
        //        cityIcon.hidden = false
        //        cityLabel.text = "城市"
        //        cityLabel.sizeToFit()
        //        cityLabel.anchorInCenter(width: cityLabel.width, height: cityLabel.height)
    }
    
    public func ClearFilters() {
        let cityBtnData = CityFilterButton?.UserObjectData as! [String: AnyObject]
        let cityLabel = cityBtnData["label"] as! UILabel
        let cityIcon = cityBtnData["icon"] as! UIImageView
        
        let hosBtnData = HospitalFilterButton?.UserObjectData as! [String: AnyObject]
        let hosLabel = hosBtnData["label"] as! UILabel
        let hosIcon = hosBtnData["icon"] as! UIImageView
        
        cityIcon.hidden = false
        cityLabel.text = "城市"
        cityLabel.sizeToFit()
        cityLabel.anchorInCenter(width: cityLabel.width, height: cityLabel.height)
        
        hosIcon.hidden = false
        hosLabel.text = "医院"
        hosLabel.sizeToFit()
        hosLabel.anchorInCenter(width: hosLabel.width, height: hosLabel.height)
    }
    
    func FilterByCity(city: String) {
//        if(nil == FilterResult) {
//            FilterResult = PrevData!["users"] as? [[String: AnyObject]]
//            if(nil == FilterResult) {
//                return
//            }
//        }
        
        FilterResult = PrevData!["users"] as? [[String: AnyObject]]
        if(nil == FilterResult) {
            return
        }

        var hosFilterData = [[String: AnyObject]]()
        
        var hosFilted = [String]()
        
        var ret = [[String: AnyObject]]()
        for user in FilterResult! {
            let cityName = YMVar.GetStringByKey(user, key: "city")
            let userHos = user["hospital"] as? [String: AnyObject]
            var userHosName = ""
            if(nil != userHos) {
                userHosName = YMVar.GetStringByKey(userHos, key: "name")
            }
            
            if(city == cityName) {
                ret.append(user)
                if(!hosFilted.contains(userHosName)) {
                    hosFilterData.append(userHos!)
                    hosFilted.append(userHosName)
                }
                
            }
        }
        
        SetHospital("医院")
        LoadHospitalList(["hospitals": ["a": ["b": hosFilterData]]])
        
        FilterResult = ret
        DrawList(ret)
    }
    
    func FilterByHos(hos: String) {
        if(nil == FilterResult) {
            FilterResult = PrevData!["users"] as? [[String: AnyObject]]
            if(nil == FilterResult) {
                return
            }
        }
        
        var ret = [[String: AnyObject]]()
        for user in FilterResult! {
            let userHos = user["hospital"] as? [String: AnyObject]
            var userHosName = ""
            if(nil != userHos) {
                userHosName = YMVar.GetStringByKey(userHos, key: "name")
            }

            if(hos == userHosName) {
                ret.append(user)
            }
        }

        DrawList(ret)
    }
    
    func GetCityForKeyWordSearch(cityName: String) -> [String: AnyObject]? {
        let cityList = PrevData!["citys"] as? [String: [ [String:AnyObject] ] ]
        if(nil == cityList) {
            return nil
        }
        
        var ret: [String:AnyObject]? =  nil
        for (provId, cityArr) in cityList! {
            for city in cityArr {
                let name = YMVar.GetStringByKey(city, key: "name")
                if(name == cityName) {
                    ret = city
                    ret!["prov"] = provId
                    break
                }
            }
            
            if(nil != ret) {
                break
            }
        }
        
        return ret
    }
    
    func GetProvForKeyWordSearch(city: [String: [[String: AnyObject]]]) -> [[String: AnyObject]] {
        let provList = PrevData!["provinces"] as? [[String: AnyObject]]
        
        var ret = [[String: AnyObject]]()
        
        for (provId, _) in city {
            for prov in provList! {
                let provIdInList = YMVar.GetStringByKey(prov, key: "id")
                if(provId == provIdInList) {
                    ret.append(prov)
                    break
                }
            }
        }
        
        return ret
    }
    
    func FilterByKey(key: String) {
        if(nil == PrevData) {return}
        let lastUserInfo = PrevData!["users"] as! [[String: AnyObject]]
        
        if("" == key) {
            ClearFilters()
            LoadCityList(PrevData!)
            LoadHospitalList(PrevData!)
            DrawList(lastUserInfo)
            FilterResult = lastUserInfo
            return
        }
        
        var cityFilterData = [String: [[String: AnyObject]]]()
        var provFilterData = [[String: AnyObject]]()
        var hosFilterData = [[String: AnyObject]]()
        
        var cityFilted = [String]()
        var hosFilted = [String]()

        var ret = [[String: AnyObject]]()
        for user in lastUserInfo {
            let userName = YMVar.GetStringByKey(user, key: "name")
            let userPhone = YMVar.GetStringByKey(user, key: "phone")
            let cityName = YMVar.GetStringByKey(user, key: "city")
            let userHos = user["hospital"] as? [String: AnyObject]
            let userDept = user["department"] as? [String: AnyObject]
            var userHosName = ""
            var userDeptName = ""
            if(nil != userHos) {
                userHosName = YMVar.GetStringByKey(userHos, key: "name")
            }
            
            if(nil != userDept) {
                userDeptName = YMVar.GetStringByKey(userDept, key: "name")
            }
            
            if(userName.containsString(key) ||
                userPhone.containsString(key) ||
                userHosName.containsString(key) ||
                userDeptName.containsString(key) ||
                cityName.containsString(key)) {
                ret.append(user)
                if(!hosFilted.contains(userHosName)) {
                    hosFilterData.append(userHos!)
                    hosFilted.append(userHosName)
                }
                
                if(cityFilted.contains(cityName)) {
                    continue
                }
                cityFilted.append(cityName)
                let city = GetCityForKeyWordSearch(cityName)
                if(nil != city) {
                    let prov = YMVar.GetStringByKey(city, key: "prov")
                    if(nil == cityFilterData[prov]) {
                        cityFilterData[prov] = [[String: AnyObject]]()
                    }
                    
                    cityFilterData[prov]?.append(city!)
                }
            }
        }
        
        provFilterData = GetProvForKeyWordSearch(cityFilterData)
        ClearFilters()
        LoadCityList(["provinces": provFilterData, "citys": cityFilterData])
        LoadHospitalList(["hospitals": ["a": ["b": hosFilterData]]])
        
        FilterResult = ret
        DrawList(ret)
    }
    
    private func DrawCityList() {
        BodyView.addSubview(CityFilterList)
        CityFilterList.alignAndFill(align: Align.UnderMatchingLeft, relativeTo: FiltersPanel, padding: 0)
    }
    
    private func DrawHospitalList() {
        BodyView.addSubview(HospitalFilterList)
        HospitalFilterList.alignAndFill(align: Align.UnderMatchingLeft, relativeTo: FiltersPanel, padding: 0)
    }
    
    private func DrawListPanel() {
        BodyView.addSubview(ResultList)
        ResultList.alignAndFill(align: Align.UnderMatchingLeft, relativeTo: FiltersPanel, padding: 0)
        
        ResultList.delegate = SameSchoolActions
    }
    
    public func LoadData() {
        let userInfo = YMVar.MyUserInfo
        let school = userInfo["college"] as? [String: AnyObject]
        BlankContentPanel.removeFromSuperview()
        if(nil == school) {
            DrawBlankContent()
        } else {
//            Loading?.Show()
            
//            let sameInfo = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_SAME_SAMECOLLEGE) as? NSDictionary
            let sameInfo = YMLocalData.GetData(YMLocalDataStrings.SAME_SCHOOL_CACHE + YMVar.MyDoctorId)
            PrevData = sameInfo as? [String: AnyObject]
            if(nil == sameInfo) {
                Loading?.Show()
                self.SameSchoolActions?.GetSameSchoolList(nil)
            } else {
                YMDelay(0.01, closure: {
                    let userInfo = sameInfo!["users"] as? [[String: AnyObject]]
                    self.DrawList(userInfo)
                    self.LoadCityList(sameInfo! as! [String : AnyObject])
                    self.LoadHospitalList(sameInfo! as! [String : AnyObject])
                    self.Loading?.Hide()
                    self.SameSchoolActions?.GetSameSchoolList(nil)

                })
            }
        }
    }
    
    public func LoadCityList(data: [String: AnyObject]) {
        var prov = data["provinces"] as? [[String: AnyObject]]
        var citys = data["citys"] as? [String: [ [String:AnyObject] ] ]
        
        if(nil != prov && nil != citys) {
            YMLayout.ClearView(view: CityFilterList)
            CityFilterList.hidden = true
            
            prov?.insert(["id": "clear", "name": "重置城市"], atIndex: 0)
            citys?["clear"] = [[String:AnyObject]]()
            PageSearchResultCell.GetCityTablView(prov!, citys: citys!,
                                                 parent: CityFilterList,
                                                 cityTouched: SameSchoolActions!.CityTouched,
                                                 provTouched: SameSchoolActions!.ProvTouched)
        }
    }
    
    public func LoadHospitalList(data: [String: AnyObject]) {
        var hospitals = data["hospitals"] as? [String: [ String: [ [String: AnyObject] ] ] ]
        
        if(nil != hospitals) {
            YMLayout.ClearView(view: HospitalFilterList)
            HospitalFilterList.hidden = true

            hospitals!["clear"] = ["clear": [["id": "clear", "name": "重置医院"]]]
            PageSearchResultCell.GetHospitalSearchView(hospitals!,
                                                       parent: HospitalFilterList,
                                                       hospitalTouched: SameSchoolActions!.HospitalTouched)
        }
    }
    
    public func Clear() {
        self.ClearList()
        self.SearchInput?.text = ""
        self.SameSchoolActions?.ThisCacheKey = nil
        ListPos = 0
        NextPos = 15
    }
    
    public func ClearList() {
        YMLayout.ClearView(view: ResultList)
        CityFilterList.hidden = true
        HospitalFilterList.hidden = true
        ResultList.contentSize = CGSizeMake(YMSizes.PageWidth, 0)
    }
    
    public func DrawList(data: [[String: AnyObject]]? = nil) {
        if(nil == data && nil == UserList) {
            DrawBlankContent()
            return
        }
        
        if(nil != data) {
            ListPos = 0
            NextPos = 15
            UserList?.removeAll()
            UserList = data
            LastCell = nil
            NoMoreUser = false
        } else {
            if(NoMoreUser) {
                return
            }
        }
        
        let maxPos = UserList!.count - 1
        
        for i in ListPos ... NextPos {
            if(i > maxPos) {
                NoMoreUser = true
                break
            }
            
            let thisID = "\(UserList![i]["id"]!)"
            if(thisID == YMVar.MyDoctorId) {
                continue
            }
            
            LastCell = PageSearchResultCell.LayoutACell(ResultList, info: UserList![i], prev: LastCell,
                                                        act: SameSchoolActions!, sel: "DocCellTouched:".Sel(), highlight: ActiveType.URL)
        }
        
        ListPos = NextPos + 1
        NextPos = ListPos + Step
        YMLayout.SetVScrollViewContentSize(ResultList, lastSubView: LastCell, padding: 130.LayoutVal())
    }
    
    private func DrawBlankContent(){
        let bigIcon = YMLayout.GetSuitableImageView("PageYiMaiSameSchoolBigIcon")
        YMLayout.ClearView(view: BlankContentPanel)
        BodyView.addSubview(BlankContentPanel)
        BlankContentPanel.fillSuperview()
        
        BlankContentPanel.addSubview(bigIcon)
        bigIcon.anchorToEdge(Edge.Top, padding: 260.LayoutVal(), width: bigIcon.width, height: bigIcon.height)
        
        let titleLabel = UILabel()
        titleLabel.text = "尚无同院校的医生"
        titleLabel.textColor = YMColors.FontGray
        titleLabel.font = YMFonts.YMDefaultFont(30.LayoutVal())
        titleLabel.sizeToFit()
        
        BlankContentPanel.addSubview(titleLabel)
        titleLabel.align(Align.UnderCentered, relativeTo: bigIcon, padding: 50.LayoutVal(), width: titleLabel.width, height: titleLabel.height)
        
        let inviteButton = YMLayout.GetTouchableView(useObject: SameSchoolActions!,
            useMethod: PageJumpActions.PageJumpToByViewSenderSel,
            userStringData: YMCommonStrings.CS_PAGE_YIMAI_MANUAL_ADD_FRIEND_NAME)
        
        inviteButton.frame = CGRect(x: 0,y: 0,width: 190.LayoutVal(), height: 60.LayoutVal())
        inviteButton.backgroundColor = YMColors.None
        
        let buttonTitle = UILabel()
        buttonTitle.text = "去邀请"
        buttonTitle.textColor = YMColors.FontBlue
        buttonTitle.font = YMFonts.YMDefaultFont(32.LayoutVal())
        buttonTitle.textAlignment = NSTextAlignment.Center
        buttonTitle.backgroundColor = YMColors.BackgroundGray
        
        inviteButton.addSubview(buttonTitle)
        
        BlankContentPanel.addSubview(inviteButton)
        inviteButton.align(Align.UnderCentered, relativeTo: titleLabel, padding: 30.LayoutVal(), width: inviteButton.width, height: inviteButton.height)
        buttonTitle.fillSuperview()
        buttonTitle.layer.cornerRadius = buttonTitle.height / 2
        buttonTitle.layer.masksToBounds = true
    }
}
