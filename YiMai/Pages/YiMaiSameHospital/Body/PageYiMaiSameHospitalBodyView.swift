//
//  PageYiMaiSameHospitalBodyView.swift
//  YiMai
//
//  Created by why on 16/5/27.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageYiMaiSameHospitalBodyView: PageBodyView {
    public var Loading: YMPageLoadingView? = nil
    private var SameHospitalActions: PageYiMaiSameHospitalActions? = nil
    private let ResultList = UIScrollView()
    private var SearchInput: YMTextField? = nil
    private var SearchPanel = UIView()
    
    var BlankContentPanel = UIView()
    var PrevData = [[String: AnyObject]]()
    
    override func ViewLayout() {
        super.ViewLayout()
        
        SameHospitalActions = PageYiMaiSameHospitalActions(navController: self.NavController!, target: self)
        Loading = YMPageLoadingView(parentView: BodyView)
        DrawSearchPanel()
        DrawListPanel()
    }
    
    private func DrawSearchPanel() {
        BodyView.addSubview(SearchPanel)
        SearchPanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 120.LayoutVal())
        SearchPanel.backgroundColor = YMColors.BackgroundGray
        
        YMLayout.ClearView(view: SearchPanel)
        
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
        
        SearchInput?.EditEndCallback = SameHospitalActions?.DoSearch
    }
    
    private func DrawListPanel() {
        BodyView.addSubview(ResultList)
        ResultList.alignAndFill(align: Align.UnderMatchingLeft, relativeTo: SearchPanel, padding: 0)
        YMLayout.ClearView(view: ResultList)
    }
    
    public func LoadData() {
        let userInfo = YMVar.MyUserInfo
        let hospital = userInfo["hospital"] as? [String: AnyObject]
        
        BlankContentPanel.removeFromSuperview()
        
        if(nil == hospital) {
            DrawBlankContent()
        } else {
//            Loading?.Show()
            SameHospitalActions!.GetSameHospitalList(nil)
        }
    }
    
    public func Clear() {
        self.ClearList()
        self.SearchInput?.text = ""
    }

    public func ClearList() {
        YMLayout.ClearView(view: ResultList)
        ResultList.contentSize = CGSizeMake(YMSizes.PageWidth, 0)
    }
    
    func Filter(key: String) {
        var ret = [[String: AnyObject]]()
        
        for user in PrevData {
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
            }
        }
        
        DrawList(ret)
    }
    
    public func DrawList(data: [[String: AnyObject]]?) {
        if(nil == data) {
            DrawBlankContent()
            return
        }
        
        var prev: YMTouchableView? = nil
        
        for v in data! {
            let thisID = "\(v["id"]!)"
            if(thisID == YMVar.MyDoctorId) {
                continue
            }
            prev = PageSearchResultCell.LayoutACell(ResultList, info: v, prev: prev,
                                                    act: SameHospitalActions!, sel: "DocCellTouched:".Sel(), highlight: ActiveType.URL)
        }

        YMLayout.SetVScrollViewContentSize(ResultList, lastSubView: prev, padding: 130.LayoutVal())
    }
    
    public func DrawBlankContent(){
        let bigIcon = YMLayout.GetSuitableImageView("PageYiMaiSameHospitalBigIcon")

        YMLayout.ClearView(view: BlankContentPanel)
        BodyView.addSubview(BlankContentPanel)
        BlankContentPanel.fillSuperview()

        BlankContentPanel.addSubview(bigIcon)
        bigIcon.anchorToEdge(Edge.Top, padding: 260.LayoutVal(), width: bigIcon.width, height: bigIcon.height)

        let titleLabel = UILabel()
        titleLabel.text = "尚无同医院的医生"
        titleLabel.textColor = YMColors.FontGray
        titleLabel.font = YMFonts.YMDefaultFont(30.LayoutVal())
        titleLabel.sizeToFit()
        
        BlankContentPanel.addSubview(titleLabel)
        titleLabel.align(Align.UnderCentered, relativeTo: bigIcon, padding: 50.LayoutVal(), width: titleLabel.width, height: titleLabel.height)
        
        let inviteButton = YMLayout.GetTouchableView(useObject: SameHospitalActions!,
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