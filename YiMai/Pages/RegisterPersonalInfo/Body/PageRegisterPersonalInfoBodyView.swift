//
//  PageRegisterPersonalInfoBodyView.swift
//  YiMai
//
//  Created by why on 16/4/20.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

class CityPickview: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    var ComponentCount: Int = 0
    var ComponentRows: [Int] = [Int]()

    var Parent: UIView!
    var Panel: YMTouchableView!
    let ButtonPanel = UIView()
    
    let CityPicker = UIPickerView()
    let ConfirmBtn = YMButton()
    let CancelBtn = YMButton()

    var SelectedProv: String = "1"
    
    var DataLoaded = false
    
    var Actions: AnyObject!
    
    var Provinces: [[String: AnyObject]]!
    var CitysInProv: [String:[[String: AnyObject]]]!
    
    convenience init(parent: UIView, actions: AnyObject) {
        self.init()

        Parent = parent
        Actions = actions
        DrawPanel()
    }
    
    func GetSelectedCityId() -> String {
        let citys = CitysInProv[SelectedProv]
        
        let row = CityPicker.selectedRowInComponent(1)
        if(nil != citys) {
            let cityInfo = citys![row]
            let cityId = YMVar.GetStringByKey(cityInfo, key: "id")
            return cityId
        }
        
        return "1"
    }
    
    func DrawButton(btn: YMButton, title: String, color: UIColor, sel: Selector) {
        btn.setTitle(title, forState: UIControlState.Normal)
        btn.setTitleColor(color, forState: UIControlState.Normal)
        btn.sizeToFit()
        btn.titleLabel?.font = YMFonts.YMDefaultFont(28.LayoutVal())
        
        btn.addTarget(Actions, action: sel, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func DrawPanel() {
        Panel = YMLayout.GetTouchableView(useObject: Actions, useMethod: "HideCityPicker:".Sel())
        Panel.backgroundColor = YMColors.OpacityBlackMask
        Panel.hidden = true

        Parent.addSubview(Panel)
        Panel.fillSuperview()

        Panel.addSubview(ButtonPanel)
        Panel.addSubview(CityPicker)
        
        ButtonPanel.addSubview(CancelBtn)
        ButtonPanel.addSubview(ConfirmBtn)
        
        CityPicker.backgroundColor = YMColors.PanelBackgroundGray
        ButtonPanel.backgroundColor = YMColors.BackgroundGray
        
        CityPicker.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: YMSizes.PageHeight / 3)
        ButtonPanel.align(Align.AboveMatchingLeft, relativeTo: CityPicker, padding: 0, width: YMSizes.PageWidth, height: 60.LayoutVal())
        
        DrawButton(ConfirmBtn, title: "确定", color: YMColors.FontBlue, sel: "CitySelected:".Sel())
        DrawButton(CancelBtn, title: "取消", color: YMColors.FontBlue, sel: "HideCityPicker:".Sel())
        
        ConfirmBtn.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: CancelBtn.width, height: 60.LayoutVal())
        CancelBtn.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: CancelBtn.width, height: 60.LayoutVal())
    }
    
    func Show() {
        Panel.removeFromSuperview()
        Parent.addSubview(Panel)
        Panel.hidden = false
    }
    
    func Hide() {
        Panel.hidden = true
    }
    
    func DataTransform(data: [String: AnyObject]) {
        Provinces = data["provinces"] as! [[String: AnyObject]]
        CitysInProv = data["citys"] as! [String:[[String: AnyObject]]]
        
        ComponentCount = Provinces.count
        ComponentRows.removeAll()
        
        for provInfo in Provinces {
            let provId = YMVar.GetStringByKey(provInfo, key: "id")
            let cityInProv = CitysInProv[provId]
            
            ComponentRows.append(cityInProv!.count)
        }
        
        SelectedProv = YMVar.GetStringByKey(Provinces.first, key: "id")
    }
    
    func LoadData(data: [String: AnyObject], reload: Bool = false) {
        DataTransform(data)
        if(DataLoaded) {
            if(reload) {
                CityPicker.reloadAllComponents()
            }
            return
        }
        DataLoaded = true
        CityPicker.delegate = self
        CityPicker.dataSource = self
        CityPicker.reloadAllComponents()
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(0 == component) {
            let provInfo = Provinces[row]
            let provName = YMVar.GetStringByKey(provInfo, key: "name")
            return provName
        } else {
            let citys = CitysInProv[SelectedProv]
            if(nil != citys) {
                let cityInfo = citys![row]
                let cityName = YMVar.GetStringByKey(cityInfo, key: "name")
                return cityName
            } else {
                return ""
            }
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(0 == component) {
            let provInfo = Provinces[row]
            
            let selectedProv = YMVar.GetStringByKey(provInfo, key: "id")
            if(selectedProv != SelectedProv) {
                SelectedProv = selectedProv
                pickerView.reloadComponent(1)
            }
        }
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(0 == component) {
            return ComponentRows.count
        } else {
            let citys = CitysInProv[SelectedProv]
            return citys!.count
        }
    }
}


public class PageRegisterPersonalInfoBodyView: NSObject {
    private var ParentView: UIView? = nil
    private var NavController: UINavigationController? = nil
    var Actions: PageRegisterPersonalInfoActions? = nil
    
    private var BodyView: UIScrollView = UIScrollView()
    
    public var UserRealnameInput: YMTextField? = nil
    private var HospitalInput: YMTouchableView? = nil
    private var HospitalDepartmentInput: YMTouchableView? = nil
    private var JobtitleInput: YMTouchableView? = nil
    
    private let HospitalLabel = UILabel()
    private let DepartmentLabel = UILabel()
    let JobtitleLabel = UILabel()
    
    public var UserRealNameString: String = ""

    public var HospitalId: String = ""
    public var HospitalDepartmentId: String = ""
    public var Jobtitle = ""
    
    public var OKButton: YMButton? = nil
    private var TooltipLabel: UILabel? = nil
    
    public var Loading: YMPageLoadingView? = nil
    
    var CityPicker: CityPickview!
    
    convenience init(parentView: UIView, navController: UINavigationController) {
        self.init()
        self.ParentView = parentView
        self.NavController = navController
        self.Actions = PageRegisterPersonalInfoActions(navController: navController, bodyView: self)
        self.ViewLayout()
        
        CityPicker = CityPickview(parent: ParentView!, actions: Actions!)
        Loading = YMPageLoadingView(parentView: parentView)
    }

    private func ViewLayout() {
        YMLayout.BodyLayoutWithTop(ParentView!, bodyView: BodyView)
        DrawInputPanel()
        DrawButtonPanel()
    }
    
    private func GetTouchableReadonlyInput(placeholder: String, action: Selector) -> YMTextField {
        let createParam = TextFieldCreateParam()
        createParam.FontColor = YMColors.FontBlue
        createParam.Placholder = placeholder
        createParam.FontSize = 28.LayoutVal()
        
        let newTextField = YMLayout.GetTextField(createParam)

        newTextField.SetLeftPaddingWidth(40.LayoutVal())
        
        let rightPaddingFrame = CGRect(x: 0,y: 0,width: 60.LayoutVal(),height: 80.LayoutVal())
        let rightPaddingView = UIView(frame: rightPaddingFrame)
        let rightArrowImage = YMLayout.GetTouchableImageView(useObject: Actions!, useMethod: action, imageName: "RegisterPersonalInfoIconRightArrow")

        rightPaddingView.addSubview(rightArrowImage)
        rightArrowImage.anchorToEdge(Edge.Left, padding: 0, width: rightArrowImage.width, height: rightArrowImage.height)
        newTextField.SetRightPadding(rightPaddingView)
        newTextField.Editable = false
        
        newTextField.addTarget(Actions, action: action, forControlEvents: UIControlEvents.TouchDown)
        
        return newTextField
    }
    
    private func DrawTouchableView(view: UIView, label: UILabel, placeholder: String) {
        
        label.text = placeholder
        label.textColor = YMColors.FontGray
        label.font = YMFonts.YMDefaultFont(28.LayoutVal())
        label.sizeToFit()
        
        view.addSubview(label)
        label.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: 650.LayoutVal(), height: label.height)

        let icon = YMLayout.GetSuitableImageView("RegisterPersonalInfoIconRightArrow")
        view.addSubview(icon)
        
        icon.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: icon.width, height: icon.height)
    }
    
    private func DrawInputPanel() {
        HospitalInput = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "ShowHospital:".Sel())
        HospitalDepartmentInput = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "ShowDept:".Sel())
        JobtitleInput = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "ShowJobTitle:".Sel())
        
        
        let createParam = TextFieldCreateParam()
        createParam.FontColor = YMColors.FontBlue
        createParam.Placholder = "姓名*（请提供真实姓名）"
        createParam.FontSize = 28.LayoutVal()
        
        UserRealnameInput = YMLayout.GetTextFieldWithMaxCharCount(createParam, maxCharCount: 20)
        UserRealnameInput?.SetLeftPaddingWidth(40.LayoutVal())
        
        BodyView.addSubview(UserRealnameInput!)
        BodyView.addSubview(HospitalInput!)
        BodyView.addSubview(HospitalDepartmentInput!)
        BodyView.addSubview(JobtitleInput!)
        
        UserRealnameInput?.EditChangedCallback = Actions!.CheckWhenNameChanged
        
        let inputHeight = 80.LayoutVal()
        UserRealnameInput?.anchorToEdge(Edge.Top, padding: 70.LayoutVal(), width: YMSizes.PageWidth, height: inputHeight)
        HospitalInput?.align(Align.UnderMatchingLeft, relativeTo: UserRealnameInput!, padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: inputHeight)
        HospitalDepartmentInput?.align(Align.UnderMatchingLeft, relativeTo: HospitalInput!, padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: inputHeight)
        JobtitleInput?.align(Align.UnderMatchingLeft, relativeTo: HospitalDepartmentInput!, padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: inputHeight)
        
        DrawTouchableView(HospitalInput!, label: HospitalLabel, placeholder: "医院")
        DrawTouchableView(HospitalDepartmentInput!, label: DepartmentLabel, placeholder: "科室")
        DrawTouchableView(JobtitleInput!, label: JobtitleLabel, placeholder: "职称")
        
        Jobtitle = ""
    }
    
    private func DrawButtonPanel() {
        OKButton = YMButton()
        
        let okBackgroundImageGray = UIImage(named: "CommonXLButtonBackgroundGray")
        let okBackgroundImageBlue = UIImage(named: "CommonXLButtonBackgroundBlue")
        
        OKButton?.setTitle("确定", forState: UIControlState.Normal)
        OKButton?.setBackgroundImage(okBackgroundImageGray, forState: UIControlState.Disabled)
        OKButton?.setBackgroundImage(okBackgroundImageBlue, forState: UIControlState.Normal)
        OKButton?.setTitleColor(YMColors.FontGray, forState: UIControlState.Disabled)
        OKButton?.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        OKButton?.titleLabel?.font = UIFont.systemFontOfSize(36.LayoutVal())
        OKButton?.enabled = false
        
        BodyView.addSubview(OKButton!)
//        OKButton?.anchorToEdge(Edge.Top, padding: 383.LayoutVal(), width: 670.LayoutVal(), height: 90.LayoutVal())
        OKButton?.align(Align.UnderCentered, relativeTo: JobtitleInput!, padding: 80.LayoutVal(), width: 670.LayoutVal(), height: 90.LayoutVal())
        
        OKButton?.UserStringData = YMCommonStrings.CS_PAGE_INDEX_NAME
        OKButton?.addTarget(Actions, action: "UpdateUserInfo:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    public func Reset() {
        YMLayout.ClearView(view: BodyView)
        ViewLayout()
        if(CityPicker.DataLoaded) {
            CityPicker.CityPicker.reloadAllComponents()
            CityPicker.CityPicker.selectRow(0, inComponent: 0, animated: false)
        }
    }
    
    public func Refesh() {
        let hospital = PageHospitalSearchBodyView.HospitalSelected
        if(nil != hospital) {
            let hosInfo = hospital as! [String: AnyObject]
            let hospitalName = hosInfo["name"] as! String
            HospitalLabel.text = "\(hospitalName)"
            HospitalId = "\(hosInfo["id"]!)"
        }
        
        let department = PageDepartmentSearchBodyView.DepartmentSelected
        if(nil != department) {
            let deptInfo = department as! [String: AnyObject]
            let departmentName = deptInfo["name"] as! String
            DepartmentLabel.text = "\(departmentName)"
            HospitalDepartmentId = "\(deptInfo["id"]!)"
        }
        
        CheckInfoComplete()
    }
    
    public func CheckInfoComplete() {
        if (!YMValueValidator.IsBlankString(UserRealnameInput?.text)
            && "" != HospitalId
            && "" != HospitalDepartmentId
            && "" != Jobtitle) {
            OKButton?.enabled = true
        } else {
            OKButton?.enabled = false
        }
    }
}












