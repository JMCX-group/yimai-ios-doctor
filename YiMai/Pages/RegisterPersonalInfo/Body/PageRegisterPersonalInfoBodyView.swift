//
//  PageRegisterPersonalInfoBodyView.swift
//  YiMai
//
//  Created by why on 16/4/20.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageRegisterPersonalInfoBodyView: NSObject {
    private var ParentView: UIView? = nil
    private var NavController: UINavigationController? = nil
    private var Actions: PageRegisterPersonalInfoActions? = nil
    
    private var BodyView: UIScrollView = UIScrollView()
    
    private var UserRealnameInput: YMTextField? = nil
    private var HospitalInput: YMTouchableView? = nil
    private var HospitalDepartmentInput: YMTouchableView? = nil
    
    private let HospitalLabel = UILabel()
    private let DepartmentLabel = UILabel()
    
    private var UserRealNameString: String = ""
    private var HospitalString: String = ""
    private var HospitalDepartmentString: String = ""
    
    private var OKButton: YMButton? = nil
    private var TooltipLabel: UILabel? = nil
    
    convenience init(parentView: UIView, navController: UINavigationController) {
        self.init()
        self.ParentView = parentView
        self.NavController = navController
        self.Actions = PageRegisterPersonalInfoActions(navController: navController, bodyView: self)
        self.ViewLayout()
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
        HospitalDepartmentInput = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "ShowCity:".Sel())
        
        
        let createParam = TextFieldCreateParam()
        createParam.FontColor = YMColors.FontBlue
        createParam.Placholder = "姓名*（请提供真实姓名）"
        createParam.FontSize = 28.LayoutVal()
        
        UserRealnameInput = YMLayout.GetTextFieldWithMaxCharCount(createParam, maxCharCount: 20)
        UserRealnameInput?.SetLeftPaddingWidth(40.LayoutVal())
        
        BodyView.addSubview(UserRealnameInput!)
        BodyView.addSubview(HospitalInput!)
        BodyView.addSubview(HospitalDepartmentInput!)
        
        let inputHeight = 80.LayoutVal()
        UserRealnameInput?.anchorToEdge(Edge.Top, padding: 70.LayoutVal(), width: YMSizes.PageWidth, height: inputHeight)
        HospitalInput?.align(Align.UnderMatchingLeft, relativeTo: UserRealnameInput!, padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: inputHeight)
        HospitalDepartmentInput?.align(Align.UnderMatchingLeft, relativeTo: HospitalInput!, padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: inputHeight)
        
        DrawTouchableView(HospitalInput!, label: HospitalLabel, placeholder: "医院")
        DrawTouchableView(HospitalDepartmentInput!, label: DepartmentLabel, placeholder: "科室")
    }
    
    private func DrawButtonPanel() {
        OKButton = YMButton()
        
        let okBackgroundImageGray = UIImage(named: "CommonXLButtonBackgroundGray")
        let okBackgroundImageBlue = UIImage(named: "CommonXLButtonBackgroundBlue")
        
        OKButton?.setTitle("确定", forState: UIControlState.Normal)
        OKButton?.setBackgroundImage(okBackgroundImageGray, forState: UIControlState.Normal)
        OKButton?.setBackgroundImage(okBackgroundImageBlue, forState: UIControlState.Highlighted)
        OKButton?.setTitleColor(YMColors.FontGray, forState: UIControlState.Normal)
        OKButton?.titleLabel?.font = UIFont.systemFontOfSize(36.LayoutVal())
        
        BodyView.addSubview(OKButton!)
        OKButton?.anchorToEdge(Edge.Top, padding: 383.LayoutVal(), width: 670.LayoutVal(), height: 90.LayoutVal())
        
        OKButton?.UserStringData = YMCommonStrings.CS_PAGE_INDEX_NAME
        OKButton?.addTarget(Actions, action: "PageJumpTo:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    public func Refesh() {
        let hospital = PageHospitalSearchBodyView.HospitalSelected
        if(nil != hospital) {
            let hospitalName = hospital!["name"] as! String
            HospitalLabel.text = "\(hospitalName)"
        }
        
        let department = PageDepartmentSearchBodyView.DepartmentSelected
        if(nil != department) {
            let departmentName = department!["name"] as! String
            HospitalLabel.text = "\(departmentName)"
        }
    }
}












