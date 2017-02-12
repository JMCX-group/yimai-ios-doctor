//
//  ApointmentAcceptDetailBodyView.swift
//  YiMai
//
//  Created by superxing on 16/8/31.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon
import SwiftDate

public class ApointmentAcceptDetailBodyView: PageBodyView {
    private var AcceptActions: ApointmentAcceptDetailActions!
    private let AdmissionTimePanel = YMTouchableView()
    private let HospitalPanel = YMTouchableView()
    private let DescPanel = YMTouchableView()
    private let NeedToKnowPanel = YMTouchableView()
    
    private let SubmitButton = YMButton()
    
    public var TimeCell: YMTouchableView? = nil
    public var AdmissionTimeString: String = ""
    public let DescInput = YMTextArea(aDelegate: nil)
    public let NeedToKnowInput = YMTextArea(aDelegate: nil)
    
    private var KeyboardHeight: CGFloat = 0
    private var BlankToBottomHeight: CGFloat = 0
    
    private let PickerPanel = UIView()
    private let AdmissionDatePicker = UIDatePicker()
    private let TimeSelectBtn = YMButton()
    
    private var SaveDescToCommonText: YMTouchableImageView!
    private var GetDescFromCommonText: YMTouchableImageView!
    private var SaveNeedToKnowToCommonText: YMTouchableImageView!
    private var GetNeedToKnowFromCommonText: YMTouchableImageView!
    
    public override func ViewLayout() {
        super.ViewLayout()
        AcceptActions = ApointmentAcceptDetailActions(navController: self.NavController!, target: self)
        CreateCommonTextButton()
        DrawAdmissionTime()
        DrawHospital()
        DrawDesc()
        DrawNeedToKnow()
        DrawSubmitButton()
        DrawAdmissionDatePicker()
        
        let centerDefault = NSNotificationCenter.defaultCenter()
        centerDefault.addObserver(AcceptActions!, selector: "KeyboardWillShow:".Sel(), name: UIKeyboardWillShowNotification, object: nil)
        
        YMLayout.SetVScrollViewContentSize(self.BodyView, lastSubView: NeedToKnowPanel)
        
        BlankToBottomHeight = (ParentView?.height)! - BodyView.contentSize.height
    }
    
    func CreateCommonTextButton() {
        SaveDescToCommonText = YMLayout.GetTouchableImageView(useObject: AcceptActions!, useMethod: "SaveDescToCommonText:".Sel(), imageName: "YMIconSaveCommonText")
        GetDescFromCommonText = YMLayout.GetTouchableImageView(useObject: AcceptActions!, useMethod: "GetDescFromCommonText:".Sel(), imageName: "YMIconGetCommonText")
        SaveNeedToKnowToCommonText = YMLayout.GetTouchableImageView(useObject: AcceptActions!, useMethod: "SaveNeedToKnowToCommonText:".Sel(), imageName: "YMIconSaveCommonText")
        GetNeedToKnowFromCommonText = YMLayout.GetTouchableImageView(useObject: AcceptActions!, useMethod: "GetNeedToKnowFromCommonText:".Sel(), imageName: "YMIconGetCommonText")
    }
    
    private func DrawAdmissionDatePicker() {
        let btnPanel = UIView()
        btnPanel.backgroundColor = YMColors.DividerLineGray
        
        ParentView?.addSubview(PickerPanel)
        PickerPanel.backgroundColor = YMColors.White
        
        PickerPanel.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: 276.LayoutVal())
        
        PickerPanel.addSubview(AdmissionDatePicker)
        PickerPanel.addSubview(btnPanel)
        AdmissionDatePicker.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: 216.LayoutVal())
        AdmissionDatePicker.locale = NSLocale(localeIdentifier: "zh_CN")
        
        AdmissionDatePicker.minuteInterval = 15
        AdmissionDatePicker.minimumDate = NSDate()
        AdmissionDatePicker.date = NSDate()
        
        btnPanel.align(Align.AboveMatchingLeft, relativeTo: AdmissionDatePicker, padding: 0, width: YMSizes.PageWidth, height: 60.LayoutVal())
        btnPanel.addSubview(TimeSelectBtn)
        
        TimeSelectBtn.setTitle("确定", forState: UIControlState.Normal)
        TimeSelectBtn.titleLabel?.font = YMFonts.YMDefaultFont(24.LayoutVal())
        TimeSelectBtn.setTitleColor(YMColors.FontBlue, forState: UIControlState.Normal)
        TimeSelectBtn.sizeToFit()
        TimeSelectBtn.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: TimeSelectBtn.width, height: TimeSelectBtn.height)
        
        TimeSelectBtn.addTarget(AcceptActions!, action: "AdmissionTimeSelected:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        
        PickerPanel.hidden = true
    }
    
    public func KeyboardWillShow(aNotification: NSNotification) {
        PickerPanel.hidden = true
        let userinfo: NSDictionary = aNotification.userInfo!
        
        let nsValue = userinfo.objectForKey(UIKeyboardFrameEndUserInfoKey)
        
        let keyboardRec = nsValue?.CGRectValue()
        
        let height = keyboardRec?.size.height
        
        self.KeyboardHeight = height!
        
        let offset = -self.KeyboardHeight + self.BlankToBottomHeight + YMSizes.PageTopHeight
        if(offset >= 0){
            return
        }
        
        UIView.animateWithDuration(0.4, animations: {
            self.BodyView.frame.origin.y = -self.KeyboardHeight + self.BlankToBottomHeight + YMSizes.PageTopHeight
        })
    }
    
    private func DrawAdmissionTime() {
        BodyView.addSubview(AdmissionTimePanel)
        AdmissionTimePanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 144.LayoutVal())
        let title = YMLayout.GetYMPanelTitleLabel("就诊时间", fontColor: YMColors.FontGray, fontSize: 24.LayoutVal(),
                                      backgroundColor: YMColors.BackgroundGray, height: 60.LayoutVal(),
                                      paddingLeft: 40.LayoutVal(), panel: AdmissionTimePanel)
        

        TimeCell = YMLayout.GetYMTouchableCell("选择时间",
                                               padding: 40.LayoutVal(), showArrow: true,
                                               action: AcceptActions!, method: "SelectTimeCellTouched:".Sel(),
                                               width: YMSizes.PageWidth, height: 84.LayoutVal(), fontSize: 26.LayoutVal(), panel: AdmissionTimePanel)
        
        TimeCell?.align(Align.UnderMatchingLeft, relativeTo: title, padding: 0, width: YMSizes.PageWidth, height: 84.LayoutVal())
    }
    
    private func DrawHospital() {
//        BodyView.addSubview(HospitalPanel)
//        HospitalPanel.align(Align.UnderMatchingLeft, relativeTo: AdmissionTimePanel, padding: 0, width: YMSizes.PageWidth, height: 144.LayoutVal())
//        let title = YMLayout.GetYMPanelTitleLabel("就诊医院", fontColor: YMColors.FontGray, fontSize: 24.LayoutVal(),
//                                      backgroundColor: YMColors.BackgroundGray, height: 60.LayoutVal(),
//                                      paddingLeft: 40.LayoutVal(), panel: HospitalPanel)
//        
//        
//        let HosCell = YMLayout.GetYMTouchableCell("我的医院",
//                                               padding: 40.LayoutVal(), showArrow: false,
//                                               action: AcceptActions!, method: "HospitalTouched:".Sel(),
//                                               width: YMSizes.PageWidth, height: 84.LayoutVal(), fontSize: 26.LayoutVal(), panel: HospitalPanel)
//        
//        HosCell.align(Align.UnderMatchingLeft, relativeTo: title, padding: 0, width: YMSizes.PageWidth, height: 84.LayoutVal())
    }
    
    private func DrawDesc() {
        BodyView.addSubview(DescPanel)
        DescPanel.align(Align.UnderMatchingLeft, relativeTo: AdmissionTimePanel, padding: 0, width: YMSizes.PageWidth, height: 260.LayoutVal())
        let title = YMLayout.GetYMPanelTitleLabel("补充说明", fontColor: YMColors.FontGray, fontSize: 24.LayoutVal(),
                                      backgroundColor: YMColors.BackgroundGray, height: 60.LayoutVal(),
                                      paddingLeft: 40.LayoutVal(), panel: DescPanel)
        
        
        DescPanel.addSubview(DescInput)
        DescInput.align(Align.UnderMatchingLeft, relativeTo: title, padding: 0, width: YMSizes.PageWidth, height: 200.LayoutVal())
        DescInput.placeholder = "请填写"
        DescInput.placeholderFont = YMFonts.YMDefaultFont(24.LayoutVal())
        DescInput.SetPadding(40.LayoutVal(), right: 126.LayoutVal(), top: 10.LayoutVal(), bottom: 0)

        DescPanel.addSubview(GetDescFromCommonText)
        DescPanel.addSubview(SaveDescToCommonText)
        
        GetDescFromCommonText.anchorInCorner(Corner.TopRight, xPad: 30.LayoutVal(), yPad: 80.LayoutVal(), width: 66.LayoutVal(), height: 66.LayoutVal())
        SaveDescToCommonText.anchorInCorner(Corner.BottomRight, xPad: 30.LayoutVal(), yPad: 22.LayoutVal(), width: 66.LayoutVal(), height: 66.LayoutVal())
        
        DescInput.EditEndCallback = self.EndInputInfo
    }
    
    private func DrawNeedToKnow() {
        BodyView.addSubview(NeedToKnowPanel)
        NeedToKnowPanel.align(Align.UnderMatchingLeft, relativeTo: DescPanel, padding: 0, width: YMSizes.PageWidth, height: 260.LayoutVal())
        let title = YMLayout.GetYMPanelTitleLabel("就诊须知", fontColor: YMColors.FontGray, fontSize: 24.LayoutVal(),
                                                  backgroundColor: YMColors.BackgroundGray, height: 60.LayoutVal(),
                                                  paddingLeft: 40.LayoutVal(), panel: NeedToKnowPanel)
        
        
        NeedToKnowPanel.addSubview(NeedToKnowInput)
        NeedToKnowInput.align(Align.UnderMatchingLeft, relativeTo: title, padding: 0, width: YMSizes.PageWidth, height: 200.LayoutVal())
        NeedToKnowInput.placeholder = "请填写"
        NeedToKnowInput.placeholderFont = YMFonts.YMDefaultFont(24.LayoutVal())
        NeedToKnowInput.SetPadding(40.LayoutVal(), right: 126.LayoutVal(), top: 10.LayoutVal(), bottom: 0)
        
        NeedToKnowPanel.addSubview(GetNeedToKnowFromCommonText)
        NeedToKnowPanel.addSubview(SaveNeedToKnowToCommonText)
        
        GetNeedToKnowFromCommonText.anchorInCorner(Corner.TopRight, xPad: 30.LayoutVal(), yPad: 80.LayoutVal(), width: 66.LayoutVal(), height: 66.LayoutVal())
        SaveNeedToKnowToCommonText.anchorInCorner(Corner.BottomRight, xPad: 30.LayoutVal(), yPad: 22.LayoutVal(), width: 66.LayoutVal(), height: 66.LayoutVal())
        
        NeedToKnowInput.EditEndCallback = self.EndInputInfo
    }
    
    public func EndInputInfo(sender: YMTextArea) {
        UIView.animateWithDuration(0.4, animations: {
            self.BodyView.frame.origin.y = 0
        })
    }
    
    private func DrawSubmitButton() {
        ParentView?.addSubview(SubmitButton)
        
        SubmitButton.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: 98.LayoutVal())
        SubmitButton.backgroundColor = YMColors.CommonBottomGray
        SubmitButton.setTitle("确认接诊", forState: UIControlState.Normal)
        SubmitButton.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        SubmitButton.setTitleColor(YMColors.FontGray, forState: UIControlState.Disabled)
        SubmitButton.enabled = false
        SubmitButton.titleLabel?.font = YMFonts.YMDefaultFont(34.LayoutVal())
        
        SubmitButton.addTarget(AcceptActions!, action: "SubmitTouched:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    public func EnableSubmitButton() {
        SubmitButton.backgroundColor = YMColors.CommonBottomBlue
        SubmitButton.enabled = true
    }
    
    public func DisableSubmitButton() {
        SubmitButton.backgroundColor = YMColors.CommonBottomGray
        SubmitButton.enabled = false
    }
    
    public func SetAdmissionTime() {
        PickerPanel.hidden = true
        
        let cellData = TimeCell!.UserObjectData as! [String: AnyObject]
        let cellLabel = cellData["label"] as! UILabel
        
        let formatter = NSDateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy年MM月dd日 a HH:mm"
        cellLabel.text = formatter.stringFromDate(AdmissionDatePicker.date)
        cellLabel.sizeToFit()
        
        AdmissionTimeString = AdmissionDatePicker.date.toString(DateFormat.Custom("YYYY-MM-dd HH:mm:ss"))! //formatter.stringFromDate(AdmissionDatePicker.date)
        
        EnableSubmitButton()
    }
    
    public func ShowAdmissionTime() {
        DescInput.resignFirstResponder()
        NeedToKnowInput.resignFirstResponder()
        PickerPanel.hidden = false
    }
}



































