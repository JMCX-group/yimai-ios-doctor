//
//  PagePersonalDetailEditBodyView.swift
//  YiMai
//
//  Created by why on 16/6/22.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PagePersonalDetailEditBodyView: PageBodyView {
    private let ExtButtonInfoPadding = 80.LayoutVal()
    private let ExtButtonInfoWidth = 400.LayoutVal()
    private let CommonFontSize = 28.LayoutVal()
    private let PanelPadding = 40.LayoutVal()
    private var editActions: PagePersonalDetailEditActions? = nil
    
    private var UserHead: YMTouchableView? = nil
    private var YiMaiCode: YMTouchableView? = nil
    private var Username: YMTouchableView? = nil
    private var Gender: YMTouchableView? = nil
    
    private var Hospital: YMTouchableView? = nil
    private var Department: YMTouchableView? = nil
    private var JobTitle: YMTouchableView? = nil
    private var School: YMTouchableView? = nil
    private var IDNum: YMTouchableView? = nil
    
    private var Tags: YMTouchableView? = nil
    private var Intro: YMTouchableView? = nil
    
    private var UserHeadLabel = UILabel()
    private let NameLabel = UILabel()
    private let YiMaiCodeLabel = UILabel()
    private let GenderLabel = UILabel()
    
    private let HospitalLabel = UILabel()
    private let DepartmentLabel = UILabel()
    private let JobTitleLabel = UILabel()
    private let SchoolLabel = UILabel()
    private let IDNumLabel = UILabel()

    private let TagsLabel = UILabel()
    private let IntroLabel = UILabel()
    
    public var Loading: YMPageLoadingView? = nil
    
    override func ViewLayout() {
        super.ViewLayout()
        editActions = self.Actions as? PagePersonalDetailEditActions
        DrawBasicPanel()
        DrawExtPanel()
        DrawIntroPanel()
        LoadData()
        Loading = YMPageLoadingView(parentView: BodyView)
    }
    
    private func AppendExtInfo(label: UILabel, parent: UIView, title: String = "", fontColor: UIColor = YMColors.FontGray, fontSize: CGFloat = 28.LayoutVal()){
        parent.addSubview(label)
        label.textColor = fontColor
        label.text = title
        label.font = YMFonts.YMDefaultFont(fontSize)
        label.textAlignment = NSTextAlignment.Right
        label.anchorToEdge(Edge.Right, padding: ExtButtonInfoPadding, width: ExtButtonInfoWidth, height: fontSize)
    }
    
    private func DrawBasicPanel() {
        UserHead = YMLayout.GetCommonLargeFullWidthTouchableView(
            BodyView, useObject: editActions!, useMethod: "ChangeHeadImage:".Sel(),
            label: UILabel(), text: "头像", userStringData: "", fontSize: CommonFontSize, showArrow: false)
        
        YiMaiCode = YMLayout.GetCommonFullWidthTouchableView(
            BodyView, useObject: editActions!, useMethod: PageJumpActions.PageJumpToByViewSenderSel,
            label: UILabel(), text: "医脉码", userStringData: "", fontSize: CommonFontSize, showArrow: false)
        
        Username = YMLayout.GetCommonFullWidthTouchableView(
            BodyView, useObject: editActions!, useMethod: PageJumpActions.PageJumpToByViewSenderSel,
            label: UILabel(), text: "姓名")
        Username?.UserStringData = YMCommonStrings.CS_PAGE_PERSONAL_NAME_EDIT_NAME
        
        Gender = YMLayout.GetCommonFullWidthTouchableView(
            BodyView, useObject: editActions!, useMethod: "SelectGender:".Sel(),
            label: UILabel(), text: "性别")

        UserHead?.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 0, otherSize: UserHead!.height)
        YiMaiCode?.align(Align.UnderMatchingLeft, relativeTo: UserHead!, padding: 0, width: YiMaiCode!.width, height: YiMaiCode!.height)
        Username?.align(Align.UnderMatchingLeft, relativeTo: YiMaiCode!, padding: 0, width: Username!.width, height: Username!.height)
        Gender?.align(Align.UnderMatchingLeft, relativeTo: Username!, padding: 0, width: Gender!.width, height: Gender!.height)
    }
    
    private func DrawExtPanel() {
        Hospital = YMLayout.GetCommonFullWidthTouchableView(
            BodyView, useObject: editActions!, useMethod: "SelectHospital:".Sel(),
            label: UILabel(), text: "医院")
        
        Department = YMLayout.GetCommonFullWidthTouchableView(
            BodyView, useObject: editActions!, useMethod: "SelectDepartment:".Sel(),
            label: UILabel(), text: "科室")
        
        JobTitle = YMLayout.GetCommonFullWidthTouchableView(
            BodyView, useObject: editActions!, useMethod: "InputJobTitle:".Sel(),
            label: UILabel(), text: "职称")
        
        School = YMLayout.GetCommonFullWidthTouchableView(
            BodyView, useObject: editActions!, useMethod: "InputSchool:".Sel(),
            label: UILabel(), text: "毕业院校")
        
        IDNum = YMLayout.GetCommonFullWidthTouchableView(
            BodyView, useObject: editActions!, useMethod: PageJumpActions.PageJumpToByViewSenderSel,
            label: UILabel(), text: "身份证号")
        IDNum?.UserStringData = YMCommonStrings.CS_PAGE_PERSONAL_ID_NUM_INPUT_NAME
        
        Hospital?.align(Align.UnderMatchingLeft, relativeTo: Gender!, padding: PanelPadding, width: Hospital!.width, height: Hospital!.height)
        Department?.align(Align.UnderMatchingLeft, relativeTo: Hospital!, padding: 0, width: Department!.width, height: Department!.height)
        JobTitle?.align(Align.UnderMatchingLeft, relativeTo: Department!, padding: 0, width: JobTitle!.width, height: JobTitle!.height)
        School?.align(Align.UnderMatchingLeft, relativeTo: JobTitle!, padding: 0, width: School!.width, height: School!.height)
        IDNum?.align(Align.UnderMatchingLeft, relativeTo: School!, padding: 0, width: IDNum!.width, height: IDNum!.height)
    }
    
    private func DrawIntroPanel() {
        Tags = YMLayout.GetCommonFullWidthTouchableView(
            BodyView, useObject: editActions!, useMethod: PageJumpActions.PageJumpToByViewSenderSel,
            label: UILabel(), text: "特长")
        
        Intro = YMLayout.GetCommonFullWidthTouchableView(
            BodyView, useObject: editActions!, useMethod: PageJumpActions.PageJumpToByViewSenderSel,
            label: UILabel(), text: "个人简介")
        Intro?.UserStringData = YMCommonStrings.CS_PAGE_PERSONAL_INTRO_EDIT_NAME

        Tags?.align(Align.UnderMatchingLeft, relativeTo: IDNum!, padding: PanelPadding, width: Tags!.width, height: Tags!.height)
        Intro?.align(Align.UnderMatchingLeft, relativeTo: Tags!, padding: 0, width: Intro!.width, height: Intro!.height)
    }
    
    public func LoadData() {
        let userInfo = YMVar.MyUserInfo
        
        let headUrl = userInfo["head_url"] as? String
        if(nil != headUrl) {
            if("<null>" == headUrl!) {
                AppendExtInfo(UserHeadLabel, parent: UserHead!, title: "请上传")
            }
        } else {
            AppendExtInfo(UserHeadLabel, parent: UserHead!, title: "请上传")
        }
        
        let userName = userInfo["name"] as? String
        if(!YMValueValidator.IsEmptyString(userName)) {
            PagePersonalNameEditViewController.UserName = userName!
            AppendExtInfo(NameLabel, parent: Username!, title: userName!)
        } else {
            AppendExtInfo(NameLabel, parent: Username!, title: "请填写")
        }
        
        let yimaiCode = userInfo["code"] as? String
        if(nil != yimaiCode) {
            AppendExtInfo(YiMaiCodeLabel, parent: YiMaiCode!, title: yimaiCode!)
        }
        
        let gender = userInfo["sex"]
        if(nil == gender) {
            AppendExtInfo(GenderLabel, parent: Gender!, title: "请选择")
        } else {
            let genderIdx = "\(gender!)"
            if("1" == genderIdx) {
                AppendExtInfo(GenderLabel, parent: Gender!, title: "男")
            } else {
                AppendExtInfo(GenderLabel, parent: Gender!, title: "女")
            }
        }
        
        let hospital = userInfo["hospital"] as? [String: AnyObject]
        if(nil != hospital) {
            AppendExtInfo(HospitalLabel, parent: Hospital!, title: hospital!["name"] as! String)
        } else {
            AppendExtInfo(HospitalLabel, parent: Hospital!, title: "请选择")
        }
        
        let dept = userInfo["department"] as? [String: AnyObject]
        if(nil != dept) {
            AppendExtInfo(DepartmentLabel, parent: Department!, title: dept!["name"] as! String)
        } else {
            AppendExtInfo(DepartmentLabel, parent: Department!, title: "请选择")
        }
        
        let jobTitle = userInfo["job_title"] as? String
        if(nil != jobTitle) {
            AppendExtInfo(JobTitleLabel, parent: JobTitle!, title: jobTitle!)
        } else {
            AppendExtInfo(JobTitleLabel, parent: JobTitle!, title: "请填写")
        }
        
        let school = userInfo["college"] as? [String: AnyObject]
        if(nil != school) {
            AppendExtInfo(SchoolLabel, parent: School!, title: school!["name"] as! String)
        } else {
            AppendExtInfo(SchoolLabel, parent: School!, title: "请填写")
        }
        
        let idNum = userInfo["ID_number"] as? String
        if(nil != idNum) {
            if("<null>" != idNum!){
                AppendExtInfo(IDNumLabel, parent: IDNum!, title: idNum!)
            } else {
                AppendExtInfo(IDNumLabel, parent: IDNum!, title: "请填写")
            }
        } else {
            AppendExtInfo(SchoolLabel, parent: School!, title: "请填写")
        }
        
        let intro = userInfo["personal_introduction"] as? String
        if(nil != intro){
            PagePersonalIntroEditViewController.IntroText = intro!
        } else {
            PagePersonalIntroEditViewController.IntroText = ""
        }
        
        AppendExtInfo(TagsLabel, parent: Tags!, title: "编辑")
        AppendExtInfo(IntroLabel, parent: Intro!, title: "编辑")
    }
    
    public func Reload() {
        let newHospital = PageHospitalSearchBodyView.HospitalSelected
        let newDepartment = PageDepartmentSearchBodyView.DepartmentSelected
        let userInfo = YMVar.MyUserInfo
        
        var showLoadingFlag = false
        if(nil != newHospital){
            showLoadingFlag = true
            let unpackedHospital = newHospital! as! [String: AnyObject]
            let hospitalId = "\(unpackedHospital["id"]!)"
            editActions!.UpdateUserInfo(["hospital": hospitalId])
        }
        
        if(nil != newDepartment) {
            showLoadingFlag = true
            let unpackedDept = newDepartment as! [String: AnyObject]
            let deptId = "\(unpackedDept["id"]!)"
            editActions!.UpdateUserInfo(["department": deptId])
        }
        
        let intro = userInfo["personal_introduction"] as? String
        if(intro != PagePersonalIntroEditViewController.IntroText) {
            showLoadingFlag = true
            if(nil == intro) {
                editActions!.UpdateUserInfo(["personal_introduction": ""])
            } else {
                editActions!.UpdateUserInfo(["personal_introduction": PagePersonalIntroEditViewController.IntroText])
            }
        }
        
        let userName = userInfo["name"] as? String
        if(userName != PagePersonalNameEditViewController.UserName) {
            showLoadingFlag = true
            if(nil == userName) {
                editActions!.UpdateUserInfo(["name": ""])
            } else {
                editActions!.UpdateUserInfo(["name": PagePersonalNameEditViewController.UserName])
            }
        }
        
        if(showLoadingFlag) {
            Loading?.Show()
        } else {
            LoadData()
        }
    }
}































