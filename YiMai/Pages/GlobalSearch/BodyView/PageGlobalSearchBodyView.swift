//
//  PageGlobalSearchBodyView.swift
//  YiMai
//
//  Created by ios-dev on 16/6/27.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageGlobalSearchBodyView: PageBodyView {
    private var SearchActions: PageGlobalSearchActions? = nil
    private var SearchPanel = UIView()
    private var FiltersPanel = UIView()
    
    public var CityFilterButton: YMTouchableView? = nil
    public var HosFilterButton: YMTouchableView? = nil
    public var DeptFilterButton: YMTouchableView? = nil
    
    public var Lv1Panel = UIScrollView()
    public var Lv2Panel = UIScrollView()
    public var Lv3Panel = UIScrollView()
    
    private var Lv1Data: [[String: AnyObject]]? = nil
    private var Lv2Data: [[String: AnyObject]]? = nil
    private var Lv3Data: [[String: AnyObject]]? = nil
    
    public var LastSearchData: [String: AnyObject]? = nil
    
    public let CityList = UIScrollView()
    public let HosList = UIScrollView()
    public let DeptList = UIScrollView()
    
    public var LastSearchKey = ""
    
    public var SearchInput: YMTextField? = nil

    public var CityFilterKey = ""
    public var HosFilterKey = ""
    public var DeptFilterKey = ""

    public var HighlightWord = ActiveType.Custom(pattern: PageGlobalSearchViewController.InitSearchKey)

    override func ViewLayout() {
        super.ViewLayout()
        
        SearchActions = PageGlobalSearchActions(navController: self.NavController!, target: self)
        DrawSearchPanel()
        DrawFiltersPanel()
        DrawFiltersList()
    }
    
    private func DrawFiltersList() {
        BodyView.addSubview(CityList)
        BodyView.addSubview(HosList)
        BodyView.addSubview(DeptList)
        
        CityList.alignAndFill(align: Align.UnderMatchingLeft, relativeTo: FiltersPanel, padding: 0)
        HosList.alignAndFill(align: Align.UnderMatchingLeft, relativeTo: FiltersPanel, padding: 0)
        DeptList.alignAndFill(align: Align.UnderMatchingLeft, relativeTo: FiltersPanel, padding: 0)
    }
    
    func DrawFilterButton(button: YMTouchableView, text: String) {
        YMLayout.ClearView(view: button)
        let titleLabel = UILabel()
        titleLabel.text = text
        titleLabel.textColor = YMColors.FontGray
        titleLabel.font = YMFonts.YMDefaultFont(28.LayoutVal())
        titleLabel.sizeToFit()
        
        button.addSubview(titleLabel)
        let titleMaxWidth = button.width - 60.LayoutVal()
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
    
    private func DrawFiltersPanel() {
        BodyView.addSubview(FiltersPanel)
        FiltersPanel.align(Align.UnderMatchingLeft, relativeTo: SearchPanel,
                           padding: 0, width: YMSizes.PageWidth, height: 80.LayoutVal())
        
        
        CityFilterButton = YMLayout.GetTouchableView(useObject: SearchActions!, useMethod: "CityFilterTouched:".Sel())
        HosFilterButton = YMLayout.GetTouchableView(useObject: SearchActions!, useMethod: "HosFilterTouched:".Sel())
        DeptFilterButton = YMLayout.GetTouchableView(useObject: SearchActions!, useMethod: "DeptFilterTouched:".Sel())
        
        FiltersPanel.addSubview(CityFilterButton!)
        FiltersPanel.addSubview(HosFilterButton!)
        FiltersPanel.addSubview(DeptFilterButton!)
        FiltersPanel.groupAndFill(group: Group.Horizontal,
                                  views: [CityFilterButton!, HosFilterButton!, DeptFilterButton!], padding: 0)
        
        
        DrawFilterButton(CityFilterButton!, text: "城市")
        DrawFilterButton(HosFilterButton!, text: "医院")
        DrawFilterButton(DeptFilterButton!, text: "科室")
        
        let bottom = UIView()
        FiltersPanel.addSubview(bottom)
        bottom.backgroundColor = YMColors.DividerLineGray
        bottom.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: YMSizes.OnPx)
        
        let divider1 = UIView()
        divider1.backgroundColor = YMColors.FontBlue
        FiltersPanel.addSubview(divider1)
        divider1.anchorToEdge(Edge.Left, padding: YMSizes.PageWidth / 3, width: YMSizes.OnPx, height: 20.LayoutVal())
        
        let divider2 = UIView()
        divider2.backgroundColor = YMColors.FontBlue
        FiltersPanel.addSubview(divider2)
        divider2.anchorToEdge(Edge.Right, padding: YMSizes.PageWidth / 3, width: YMSizes.OnPx, height: 20.LayoutVal())
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
        
        SearchInput?.EditEndCallback = SearchActions?.KeyWordSearch
    }
    
    public func ShowLv1FullList() {
        YMLayout.ClearView(view: Lv1Panel)
        YMLayout.ClearView(view: Lv2Panel)
        YMLayout.ClearView(view: Lv3Panel)

        Lv2Panel.hidden = true
        Lv3Panel.hidden = true
        Lv1Panel.hidden = false
        
        Lv1Panel.alignAndFill(align: Align.UnderMatchingLeft, relativeTo: FiltersPanel, padding: 0)
        Lv1Panel.contentSize = CGSizeMake(YMSizes.PageWidth, 0)

        let titleLabel = UILabel()
        let titlePanel = UIView()
        
        Lv1Panel.addSubview(titlePanel)
        titlePanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 50.LayoutVal())
        
        let friendsCount = Lv1Data?.count
        
        titleLabel.text = "医生朋友（\(friendsCount!)名）"
        
        titleLabel.textColor = YMColors.FontGray
        titleLabel.font = YMFonts.YMDefaultFont(20.LayoutVal())
        titleLabel.sizeToFit()
        titlePanel.addSubview(titleLabel)
        titleLabel.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: titleLabel.width, height: titleLabel.height)
        
        var lastCell = titlePanel
        for v in Lv1Data! {
            lastCell = PageSearchResultCell.LayoutACell(Lv1Panel, info: v, prev: lastCell, act: SearchActions!, sel: "CellTouched:".Sel(), highlight: HighlightWord)
        }
        
        DrawFiltersList()

        YMLayout.SetVScrollViewContentSize(Lv1Panel, lastSubView: lastCell)
    }
    
    public func ShowLv2FullList() {
        YMLayout.ClearView(view: Lv1Panel)
        YMLayout.ClearView(view: Lv2Panel)
        YMLayout.ClearView(view: Lv3Panel)
        
        Lv2Panel.hidden = false
        Lv3Panel.hidden = true
        Lv1Panel.hidden = true
        
        Lv2Panel.alignAndFill(align: Align.UnderMatchingLeft, relativeTo: FiltersPanel, padding: 0)
        Lv2Panel.contentSize = CGSizeMake(YMSizes.PageWidth, 0)
        
        let titleLabel = UILabel()
        let titlePanel = UIView()
        
        Lv2Panel.addSubview(titlePanel)
        titlePanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 50.LayoutVal())
        
        let friendsCount = Lv2Data?.count
        
        titleLabel.text = "二度医脉（\(friendsCount!)名）"
        
        titleLabel.textColor = YMColors.FontGray
        titleLabel.font = YMFonts.YMDefaultFont(20.LayoutVal())
        titleLabel.sizeToFit()
        titlePanel.addSubview(titleLabel)
        titleLabel.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: titleLabel.width, height: titleLabel.height)
        
        var lastCell = titlePanel
        for v in Lv2Data! {
            lastCell = PageSearchResultCell.LayoutACell(Lv2Panel, info: v, prev: lastCell, act: SearchActions!, sel: "CellTouched:".Sel(), highlight: HighlightWord)
        }
        
        DrawFiltersList()

        YMLayout.SetVScrollViewContentSize(Lv2Panel, lastSubView: lastCell)
    }
    
    public func ShowLv3FullList() {
        YMLayout.ClearView(view: Lv1Panel)
        YMLayout.ClearView(view: Lv2Panel)
        YMLayout.ClearView(view: Lv3Panel)
        
        Lv2Panel.hidden = true
        Lv3Panel.hidden = false
        Lv1Panel.hidden = true
        
        Lv3Panel.alignAndFill(align: Align.UnderMatchingLeft, relativeTo: FiltersPanel, padding: 0)
        Lv3Panel.contentSize = CGSizeMake(YMSizes.PageWidth, 0)
        
        let titleLabel = UILabel()
        let titlePanel = UIView()
        
        Lv3Panel.addSubview(titlePanel)
        titlePanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 50.LayoutVal())
        
        let friendsCount = Lv3Data?.count
        
        titleLabel.text = "其他医生（\(friendsCount!)名）"
        
        titleLabel.textColor = YMColors.FontGray
        titleLabel.font = YMFonts.YMDefaultFont(20.LayoutVal())
        titleLabel.sizeToFit()
        titlePanel.addSubview(titleLabel)
        titleLabel.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: titleLabel.width, height: titleLabel.height)
        
        var lastCell = titlePanel
        for v in Lv3Data! {
            lastCell = PageSearchResultCell.LayoutACell(Lv3Panel, info: v, prev: lastCell, act: SearchActions!, sel: "CellTouched:".Sel(), highlight: HighlightWord)
        }
        
        DrawFiltersList()

        YMLayout.SetVScrollViewContentSize(Lv3Panel, lastSubView: lastCell)
    }
    
    public func LoadData(data: [String: AnyObject]?,
                         l1: [[String: AnyObject]]? = nil,
                         l2: [[String: AnyObject]]? = nil,
                         l3: [[String: AnyObject]]? = nil) {
        YMLayout.ClearView(view: Lv1Panel)
        YMLayout.ClearView(view: Lv2Panel)
        YMLayout.ClearView(view: Lv3Panel)
        
        if(nil != data) {
            let users = data!["users"] as! [String: AnyObject]
            Lv1Data = users["friends"] as? [[String: AnyObject]]
            Lv2Data = users["friends-friends"] as? [[String: AnyObject]]
            Lv3Data = users["other"] as? [[String: AnyObject]]
        } else {
            Lv1Data = l1!
            Lv2Data = l2!
            Lv3Data = l3!
        }
        
        DrawLv1InitPanel(Lv1Data!)
        DrawLv2InitPanel(Lv2Data!)
        DrawLv3InitPanel(Lv3Data!)
        
        Lv1Panel.contentSize = CGSizeMake(YMSizes.PageWidth, 0)
        Lv2Panel.contentSize = CGSizeMake(YMSizes.PageWidth, 0)
        Lv3Panel.contentSize = CGSizeMake(YMSizes.PageWidth, 0)
        
        Lv1Panel.contentOffset = CGPointMake(0, 0)
        Lv2Panel.contentOffset = CGPointMake(0, 0)
        Lv3Panel.contentOffset = CGPointMake(0, 0)
        
//        BodyView.contentOffset = CGPointMake(0, 0)
        
        DrawFiltersList()
        
        YMLayout.SetHScrollViewContentSize(BodyView, lastSubView: Lv3Panel)
    }
    
    private func DrawLv1InitPanel(data: [[String: AnyObject]]) {
        BodyView.addSubview(Lv1Panel)
        Lv1Panel.align(Align.UnderMatchingLeft, relativeTo: FiltersPanel,
                       padding: 0, width: YMSizes.PageWidth, height: 0)
        let titleLabel = UILabel()
        let titlePanel = UIView()
        
        Lv1Panel.addSubview(titlePanel)
        titlePanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 50.LayoutVal())
        
        let friendsCount = data.count
        if(0 == friendsCount) {
            return
//            titleLabel.text = "暂无医生朋友"
        } else {
            titleLabel.text = "一度医脉（\(friendsCount)名）"
        }
        
        Lv1Panel.hidden = false
        
        titleLabel.textColor = YMColors.FontGray
        titleLabel.font = YMFonts.YMDefaultFont(20.LayoutVal())
        titleLabel.sizeToFit()
        titlePanel.addSubview(titleLabel)
        titleLabel.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: titleLabel.width, height: titleLabel.height)
        
        var lastCell = titlePanel
        if(friendsCount > 2) {
            for i in 0...1 {
                lastCell = PageSearchResultCell.LayoutACell(Lv1Panel, info: data[i], prev: lastCell, act: SearchActions!, sel: "CellTouched:".Sel(), highlight: HighlightWord)
                lastCell.backgroundColor = YMColors.White
            }
            
            let showMorePanel = YMLayout.GetTouchableView(useObject: SearchActions!, useMethod: "ShowLv1FullList:".Sel())
            let showMoreLabel = UILabel()
            showMoreLabel.text = "显示更多..."
            showMoreLabel.textColor = YMColors.FontLightBlue
            showMoreLabel.textAlignment = NSTextAlignment.Center
            showMoreLabel.font = YMFonts.YMDefaultFont(20.LayoutVal())
            
            Lv1Panel.addSubview(showMorePanel)
            
            showMorePanel.align(Align.UnderMatchingLeft, relativeTo: lastCell, padding: 0, width: YMSizes.PageWidth, height: 50.LayoutVal())
            showMorePanel.addSubview(showMoreLabel)
            showMoreLabel.fillSuperview()
            lastCell = showMorePanel
        } else {
            for v in data {
                lastCell = PageSearchResultCell.LayoutACell(Lv1Panel, info: v, prev: lastCell, act: SearchActions!, sel: "CellTouched:".Sel(), highlight: HighlightWord)
            }
        }
        
        YMLayout.SetViewHeightByLastSubview(Lv1Panel, lastSubView: lastCell)
    }
    
    private func DrawLv2InitPanel(data: [[String: AnyObject]]) {
        BodyView.addSubview(Lv2Panel)
        Lv2Panel.align(Align.UnderMatchingLeft, relativeTo: Lv1Panel,
                       padding: 0, width: YMSizes.PageWidth, height: 0)
        let titleLabel = UILabel()
        let titlePanel = UIView()
        
        Lv2Panel.addSubview(titlePanel)
        titlePanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 50.LayoutVal())
        
        let friendsCount = data.count
        if(0 == friendsCount) {
            return
//            titleLabel.text = "暂无二度医脉"
        } else {
            titleLabel.text = "二度医脉（\(friendsCount)名）"
        }
        
        Lv2Panel.hidden = false
        
        titleLabel.textColor = YMColors.FontGray
        titleLabel.font = YMFonts.YMDefaultFont(20.LayoutVal())
        titleLabel.sizeToFit()
        titlePanel.addSubview(titleLabel)
        titleLabel.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: titleLabel.width, height: titleLabel.height)

        var lastCell = titlePanel
        if(friendsCount > 2) {
            for i in 0...1 {
                lastCell = PageSearchResultCell.LayoutACell(Lv2Panel, info: data[i], prev: lastCell, act: SearchActions!, sel: "CellTouched:".Sel(), highlight: HighlightWord)
                lastCell.backgroundColor = YMColors.White
            }
            
            let showMorePanel = YMLayout.GetTouchableView(useObject: SearchActions!, useMethod: "ShowLv2FullList:".Sel())
            let showMoreLabel = UILabel()
            showMoreLabel.text = "显示更多..."
            showMoreLabel.textColor = YMColors.FontLightBlue
            showMoreLabel.textAlignment = NSTextAlignment.Center
            showMoreLabel.font = YMFonts.YMDefaultFont(20.LayoutVal())
            
            Lv2Panel.addSubview(showMorePanel)
            
            showMorePanel.align(Align.UnderMatchingLeft, relativeTo: lastCell, padding: 0, width: YMSizes.PageWidth, height: 50.LayoutVal())
            showMorePanel.addSubview(showMoreLabel)
            showMoreLabel.fillSuperview()
            lastCell = showMorePanel
        } else {
            for v in data {
                lastCell = PageSearchResultCell.LayoutACell(Lv2Panel, info: v, prev: lastCell, act: SearchActions!, sel: "CellTouched:".Sel(), highlight: HighlightWord)
            }
        }
        
        YMLayout.SetViewHeightByLastSubview(Lv2Panel, lastSubView: lastCell)
    }
    
    private func DrawLv3InitPanel(data: [[String: AnyObject]]) {
        BodyView.addSubview(Lv3Panel)
        Lv3Panel.align(Align.UnderMatchingLeft, relativeTo: Lv2Panel,
                       padding: 0, width: YMSizes.PageWidth, height: 0)
        let titleLabel = UILabel()
        let titlePanel = UIView()
        
        Lv3Panel.addSubview(titlePanel)
        titlePanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 50.LayoutVal())
        
        let friendsCount = data.count
        if(0 == friendsCount) {
            return
//            titleLabel.text = "暂无其他医生资源"
        } else {
            titleLabel.text = "其他医生（\(friendsCount)名）"
        }
        
        Lv3Panel.hidden = false
        
        titleLabel.textColor = YMColors.FontGray
        titleLabel.font = YMFonts.YMDefaultFont(20.LayoutVal())
        titleLabel.sizeToFit()
        titlePanel.addSubview(titleLabel)
        titleLabel.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: titleLabel.width, height: titleLabel.height)
        
        var lastCell = titlePanel
        if(friendsCount > 2) {
            for i in 0...1 {
                lastCell = PageSearchResultCell.LayoutACell(Lv3Panel, info: data[i], prev: lastCell, act: SearchActions!, sel: "CellTouched:".Sel(), highlight: HighlightWord)
                lastCell.backgroundColor = YMColors.White
            }
            
            let showMorePanel = YMLayout.GetTouchableView(useObject: SearchActions!, useMethod: "ShowLv3FullList:".Sel())
            let showMoreLabel = UILabel()
            showMoreLabel.text = "显示更多..."
            showMoreLabel.textColor = YMColors.FontLightBlue
            showMoreLabel.textAlignment = NSTextAlignment.Center
            showMoreLabel.font = YMFonts.YMDefaultFont(20.LayoutVal())
            
            Lv3Panel.addSubview(showMorePanel)
            
            showMorePanel.align(Align.UnderMatchingLeft, relativeTo: lastCell, padding: 0, width: YMSizes.PageWidth, height: 50.LayoutVal())
            showMorePanel.addSubview(showMoreLabel)
            showMoreLabel.fillSuperview()
            lastCell = showMorePanel
        } else {
            for v in data {
                lastCell = PageSearchResultCell.LayoutACell(Lv3Panel, info: v, prev: lastCell, act: SearchActions!, sel: "CellTouched:".Sel(), highlight: HighlightWord)
            }
        }
        
        YMLayout.SetViewHeightByLastSubview(Lv3Panel, lastSubView: lastCell)
    }
    
    public func InitSearch(key: String) {
        SearchInput?.text = key
        LastSearchKey = key
        SearchActions?.searchBy = "key"
        SearchActions?.DoSearch(["field": key])
    }
    
    public func LoadCityList(data: [String: AnyObject]) {
        var prov = data["provinces"] as? [[String: AnyObject]]
        var citys = data["citys"] as? [String: [ [String:AnyObject] ] ]
        
        if(nil != prov && nil != citys) {
            YMLayout.ClearView(view: CityList)
            CityList.hidden = true
            prov?.insert(["id": "clear", "name": "重置城市"], atIndex: 0)
            citys?["clear"] = [[String:AnyObject]]()
            PageSearchResultCell.GetCityTablView(prov!, citys: citys!,
                                                 parent: CityList,
                                                 cityTouched: SearchActions!.CityTouched,
                                                 provTouched: SearchActions!.ProvTouched)
        }
    }
    
    func FilterHosByCity() {
        
    }
    
    func FilterDeptByHos() {
        
    }

    public func LoadHosList(data: [String: AnyObject]) {
        var hospitals = data["hospitals"] as? [String: [ String: [ [String: AnyObject] ] ] ]
        
        if(nil != hospitals) {
            YMLayout.ClearView(view: HosList)
            HosList.hidden = true
            
            hospitals!["clear"] = ["clear": [["id": "clear", "name": "重置医院"]]]
//            hospitals!["a"]!["b"]! = [["id": "clear", "name": "重置医院"]]
            PageSearchResultCell.GetHospitalSearchView(hospitals!,
                                                       parent: HosList,
                                                       hospitalTouched: SearchActions!.HosTouched)
        }
    }
    
    public func LoadDeptList(data: [String: AnyObject]) {
        var dept = data["departments"] as? [[String: AnyObject]]
        
        if(nil != dept) {
            YMLayout.ClearView(view: DeptList)
            DeptList.hidden = true
            dept?.insert(["id": "clear", "name": "重置科室"], atIndex: 0)
            PageSearchResultCell.GetDeptSearchView(dept!,
                                                       parent: DeptList,
                                                       hospitalTouched: SearchActions!.DeptTouched)
        }
    }
    
    public func ResetFilter() {
        let users = LastSearchData!["users"] as! [String: AnyObject]
        Lv1Data = users["friends"] as? [[String: AnyObject]]
        Lv2Data = users["friends-friends"] as? [[String: AnyObject]]
        Lv3Data = users["other"] as? [[String: AnyObject]]
        
        HosFilterKey = ""
        CityFilterKey = ""
        
        LoadData(nil, l1: Lv1Data, l2: Lv2Data, l3: Lv3Data)
        
        DrawFilterButton(CityFilterButton!, text: "城市")
        DrawFilterButton(HosFilterButton!, text: "医院")
        DrawFilterButton(DeptFilterButton!, text: "科室")
    }
    
    public func FilterResultByCity(cityName: String) {
        var filtedHos = [[String: AnyObject]]()
        var filtedDept = [[String: AnyObject]]()
        
        var filtedHosIds = [String]()
        var filtedDeptIds = [String]()
        
        HosFilterKey = ""
        CityFilterKey = cityName

        func GetFilteredArray(org: [[String: AnyObject]], key: String) -> [[String: AnyObject]] {
            var ret = [[String: AnyObject]]()
            for v in org {
                let city = v["city"] as? String
                if(nil != city){
                    if(cityName == city) {
                        let hos = v["hospital"] as? [String: AnyObject]
                        let dept = v["department"] as? [String: AnyObject]
                        if(nil != hos) {
                            let hosId = YMVar.GetStringByKey(hos, key: "id")
                            if(!filtedHosIds.contains(hosId)) {
                                filtedHos.append(hos!)
                                filtedHosIds.append(hosId)
                            }
                        }
                        
                        if(nil != dept) {
                            let deptId = YMVar.GetStringByKey(dept, key: "id")
                            if(!filtedDeptIds.contains(deptId)) {
                                filtedDept.append(dept!)
                                filtedDeptIds.append(deptId)
                            }
                        }

                        ret.append(v)
                    }
                }
            }
            
            return ret
        }
        
        let users = LastSearchData!["users"] as! [String: AnyObject]
        Lv1Data = users["friends"] as? [[String: AnyObject]]
        Lv2Data = users["friends-friends"] as? [[String: AnyObject]]
        Lv3Data = users["other"] as? [[String: AnyObject]]
        
        let l1 = GetFilteredArray(Lv1Data!, key: cityName)
        let l2 = GetFilteredArray(Lv2Data!, key: cityName)
        let l3 = GetFilteredArray(Lv3Data!, key: cityName)

        LoadData(nil, l1: l1, l2: l2, l3: l3)
        
        DrawFilterButton(CityFilterButton!, text: cityName)
        
        LoadHosList(["hospitals": ["a": ["b": filtedHos]]])
        LoadDeptList(["departments": filtedDept])
        
        DrawFilterButton(HosFilterButton!, text: "医院")
        DrawFilterButton(DeptFilterButton!, text: "科室")
    }
    
    public func FilterResultByHos(_: String, hosName: String) {
        var filtedDept = [[String: AnyObject]]()
        var filtedDeptIds = [String]()
        
        HosFilterKey = hosName

        func GetFilteredArray(org: [[String: AnyObject]], key: String) -> [[String: AnyObject]] {
            var ret = [[String: AnyObject]]()
            for v in org {
                let hos = v["hospital"] as? [String: AnyObject]
                if(nil != hos){
                    let thisHosName = YMVar.GetStringByKey(hos, key: "name") //"\(hos!["id"]!)"
                    if(thisHosName == hosName) {
                        
                        let dept = v["department"] as? [String: AnyObject]

                        if(nil != dept) {
                            let deptId = YMVar.GetStringByKey(dept, key: "id")
                            if(!filtedDeptIds.contains(deptId)) {
                                filtedDept.append(dept!)
                                filtedDeptIds.append(deptId)
                            }
                        }
                        
                        ret.append(v)
                    }
                }
            }
            
            return ret
        }
        
        let users = LastSearchData!["users"] as! [String: AnyObject]
        Lv1Data = users["friends"] as? [[String: AnyObject]]
        Lv2Data = users["friends-friends"] as? [[String: AnyObject]]
        Lv3Data = users["other"] as? [[String: AnyObject]]
        
        let l1 = GetFilteredArray(Lv1Data!, key: hosName)
        let l2 = GetFilteredArray(Lv2Data!, key: hosName)
        let l3 = GetFilteredArray(Lv3Data!, key: hosName)
        
        LoadData(nil, l1: l1, l2: l2, l3: l3)
        

        DrawFilterButton(HosFilterButton!, text: hosName)
        
        LoadDeptList(["departments": filtedDept])
        DrawFilterButton(DeptFilterButton!, text: "科室")

    }
    
    public func FilterResultByDept(_: String, deptName: String) {
        func GetFilteredArray(org: [[String: AnyObject]], key: String) -> [[String: AnyObject]] {
            var ret = [[String: AnyObject]]()
            for v in org {
                let dept = v["department"] as? [String: AnyObject]
                let hos = v["hospital"] as? [String: AnyObject]
                if("" != HosFilterKey) {
                    if(HosFilterKey != YMVar.GetStringByKey(hos, key: "name")) {
                        continue
                    }
                }
                
                if("" != CityFilterKey) {
                    let cityName = YMVar.GetStringByKey(v, key: "city")
                    if(cityName != CityFilterKey) {
                        continue
                    }
                }

                if(nil != dept){
                    let thisDeptName = YMVar.GetStringByKey(dept, key: "name")
                    if(thisDeptName == deptName) {
                        ret.append(v)
                    }
                }
            }
            
            return ret
        }
        
        let users = LastSearchData!["users"] as! [String: AnyObject]
        Lv1Data = users["friends"] as? [[String: AnyObject]]
        Lv2Data = users["friends-friends"] as? [[String: AnyObject]]
        Lv3Data = users["other"] as? [[String: AnyObject]]
        
        let l1 = GetFilteredArray(Lv1Data!, key: deptName)
        let l2 = GetFilteredArray(Lv2Data!, key: deptName)
        let l3 = GetFilteredArray(Lv3Data!, key: deptName)
        
        LoadData(nil, l1: l1, l2: l2, l3: l3)
        
        DrawFilterButton(DeptFilterButton!, text: deptName)

//        let btnData = DeptFilterButton!.UserObjectData as! [String: AnyObject]
//        let label = btnData["label"] as! UILabel
//        label.text = deptName
        //        public var HosFilterButton: YMTouchableView? = nil
        //        public var DeptFilterButton: YMTouchableView? = nil
    }
}





































