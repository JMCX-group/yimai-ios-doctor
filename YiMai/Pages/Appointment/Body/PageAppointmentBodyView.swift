//
//  PageAppointmentBodyView.swift
//  YiMai
//
//  Created by why on 16/5/27.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageAppointmentBodyView: PageBodyView {
    private var PatientBasicInfoPanel: YMTouchableView? = nil
    private var PatientConditionPanel: YMTouchableView? = nil
    private var PhotoIcon = YMLayout.GetSuitableImageView("PageAppointmentPhotoIcon")
    
    private var PhotoPanel: UIView? = nil
    private var PhotoInnerPanel: UIScrollView? = nil
    
    private var PhotoScrollLeftButton: YMTouchableView? = nil
    private var PhotoScrollRightButton: YMTouchableView? = nil
    
    private var SelectDocotorPanel: UIView? = nil
    private var SelectDocotorButton: YMTouchableView? = nil
    private let SelectDocotorButtonIcon = YMLayout.GetSuitableImageView("PageAppointmentAddDocotorIcon")
    private let SelectDocotorButtonLabel = UILabel()
    
    private var SelectTimePanel: UIView? = nil
    private var SelectTimeButton: YMTouchableView? = nil
    private let SelectTimeLabel = UILabel()
    
    public static var PatientBasicInfoString: String = ""
    public static var PatientConditionString: String = ""
    public static var AppointmentTimeString: String = "点击选择时间"
    
    public func Reload() {
        
    }

    override func ViewLayout() {
        YMLayout.BodyLayoutWithTop(ParentView!, bodyView: BodyView)
        BodyView.backgroundColor = YMColors.PanelBackgroundGray

        DrawPatientBasicInfoPanel()
        DrawPatientConditionPanel()
        DrawPhotoPanel()
        DrawSelectDocotorPanel()
        DrawSelectTimePanel()
        DrawPhotoButton()
    }
    
    private func BuildPatientInputPanel(placeholder: String, panel: UIView) {
        let param = TextFieldCreateParam()
        param.BackgroundColor = YMColors.None
        param.Placholder = placeholder
        param.FontSize = 28.LayoutVal()
        
        let textField = YMLayout.GetTextField(param)
        textField.Editable = false
        
        panel.addSubview(textField)
        textField.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 0, width: 630.LayoutVal(), height: 80.LayoutVal())
        
        let arrowIcon = YMLayout.GetSuitableImageView("CommonRightArrowIcon")
        panel.addSubview(arrowIcon)
        
        arrowIcon.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: arrowIcon.width, height: arrowIcon.height)
    }
    
    private func DrawPatientBasicInfoPanel() {
        PatientBasicInfoPanel = YMLayout.GetTouchableView(useObject: Actions!, useMethod: PageJumpActions.PageJumpToByViewSenderSel, userStringData: "")
        BodyView.addSubview(PatientBasicInfoPanel!)
        PatientBasicInfoPanel?.anchorToEdge(Edge.Top, padding: 30.LayoutVal(), width: YMSizes.PageWidth, height: 80.LayoutVal())
        
        BuildPatientInputPanel("患者基本信息（必填）", panel: PatientBasicInfoPanel!)
    }
    
    private func DrawPatientConditionPanel() {
        PatientConditionPanel = YMLayout.GetTouchableView(useObject: Actions!, useMethod: PageJumpActions.PageJumpToByViewSenderSel, userStringData: "")
        BodyView.addSubview(PatientConditionPanel!)
        PatientConditionPanel?.align(Align.UnderMatchingLeft, relativeTo: PatientBasicInfoPanel!, padding: 1.LayoutVal(), width: YMSizes.PageWidth, height: 80.LayoutVal())

        BuildPatientInputPanel("现病史", panel: PatientConditionPanel!)

    }
    
    private func DrawPhotoPanel() {
        PhotoPanel = UIView()
        BodyView.addSubview(PhotoPanel!)
        PhotoPanel?.align(Align.UnderMatchingLeft, relativeTo: PatientConditionPanel!, padding: 92.LayoutVal(), width: YMSizes.PageWidth, height: 254.LayoutVal())
        PhotoPanel?.backgroundColor = YMColors.White
        
        PhotoInnerPanel = UIScrollView()
        PhotoPanel?.addSubview(PhotoInnerPanel!)
        
        PhotoInnerPanel?.anchorInCorner(Corner.TopLeft, xPad: 58.LayoutVal(), yPad: 80.LayoutVal(), width: 635.LayoutVal(), height: 144.LayoutVal())
        
        PhotoScrollLeftButton = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "PhotoScrollLeft:")
        PhotoScrollRightButton = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "PhotoScrollRight:")
        
        PhotoPanel?.addSubview(PhotoScrollLeftButton!)
        PhotoPanel?.addSubview(PhotoScrollRightButton!)
        
        let scrollLeftIcon = YMLayout.GetSuitableImageView("PageAppointmentPhotoScrollLeft")
        let scrollRightIcon = YMLayout.GetSuitableImageView("PageAppointmentPhotoScrollRight")
        
        PhotoScrollLeftButton?.addSubview(scrollLeftIcon)
        PhotoScrollRightButton?.addSubview(scrollRightIcon)

        PhotoScrollLeftButton?.anchorInCorner(Corner.TopLeft, xPad: 0, yPad: 80.LayoutVal(), width: 40.LayoutVal(), height: 144.LayoutVal())
        PhotoScrollRightButton?.anchorInCorner(Corner.TopRight, xPad: 0, yPad: 80.LayoutVal(), width: 40.LayoutVal(), height: 144.LayoutVal())
        
        scrollLeftIcon.anchorToEdge(Edge.Right, padding: 0, width: scrollLeftIcon.width, height: scrollLeftIcon.height)
        scrollRightIcon.anchorToEdge(Edge.Left, padding: 0, width: scrollRightIcon.width, height: scrollRightIcon.height)
    
        func GetTooltipCell(info: String, prevCell: UIView?) -> UIView {
            let cell = UIView()
            PhotoInnerPanel?.addSubview(cell)

            let titleLabel = UILabel()
            
            titleLabel.lineBreakMode = NSLineBreakMode.ByCharWrapping
            titleLabel.numberOfLines = 2
            titleLabel.frame = CGRect(x: 0,y: 0,width: 66.LayoutVal(),height: 66.LayoutVal())
            titleLabel.text = info
            titleLabel.textColor = YMColors.FontGray
            titleLabel.font = YMFonts.YMDefaultFont(30.LayoutVal())

            titleLabel.sizeToFit()
            
            cell.addSubview(titleLabel)
            cell.backgroundColor = YMColors.BackgroundGray
            
            if(nil != prevCell) {
                cell.align(Align.ToTheRightMatchingTop, relativeTo: prevCell!, padding: 19.LayoutVal(), width: 144.LayoutVal(), height: 144.LayoutVal())
            } else {
                cell.anchorToEdge(Edge.Left, padding: 0, width: 144.LayoutVal(), height: 144.LayoutVal())
            }
            
            titleLabel.anchorInCenter(width: titleLabel.width, height: titleLabel.height)
            
            return cell
        }
        
        var cell = GetTooltipCell("病例资料", prevCell: nil)
        cell = GetTooltipCell("病例资料", prevCell: cell)
        cell = GetTooltipCell("病例资料", prevCell: cell)
        cell = GetTooltipCell("其他", prevCell: cell)
    }
    
    private func DrawSelectDocotorPanel() {
        let titleLabel = UILabel()
        
        titleLabel.text = "选择医生"
        titleLabel.textColor = YMColors.FontGray
        titleLabel.font = YMFonts.YMDefaultFont(24.LayoutVal())
        titleLabel.sizeToFit()
        
        SelectDocotorPanel = UIView()
        BodyView.addSubview(SelectDocotorPanel!)
        SelectDocotorPanel?.align(Align.UnderMatchingLeft, relativeTo: PhotoPanel!, padding: 0, width: YMSizes.PageWidth, height: 210.LayoutVal())
        
        SelectDocotorPanel?.addSubview(titleLabel)
        titleLabel.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 0, width: titleLabel.width, height: 60.LayoutVal())
        
        SelectDocotorButton = YMLayout.GetTouchableView(useObject: Actions!, useMethod: PageJumpActions.PageJumpToByViewSenderSel, userStringData: "")
        SelectDocotorPanel?.addSubview(SelectDocotorButton!)
        SelectDocotorButton?.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: 150.LayoutVal())
        
        SelectDocotorButton?.addSubview(SelectDocotorButtonIcon)
        SelectDocotorButtonIcon.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: SelectDocotorButtonIcon.width, height: SelectDocotorButtonIcon.height)
        
        SelectDocotorButtonLabel.textColor = YMColors.FontGray
        SelectDocotorButtonLabel.text = "点击选择医生"
        SelectDocotorButtonLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
        SelectDocotorButtonLabel.sizeToFit()
        
        SelectDocotorButton?.addSubview(SelectDocotorButtonLabel)
        SelectDocotorButtonLabel.align(Align.ToTheRightCentered,
            relativeTo: SelectDocotorButtonIcon,
            padding: 24.LayoutVal(),
            width: SelectDocotorButtonLabel.width, height: SelectDocotorButtonLabel.height)
    }
    
    private func DrawSelectTimePanel() {
        let titleLabel = UILabel()
        
        titleLabel.text = "期望就诊时间"
        titleLabel.textColor = YMColors.FontGray
        titleLabel.font = YMFonts.YMDefaultFont(24.LayoutVal())
        titleLabel.sizeToFit()
        
        SelectTimePanel = UIView()
        BodyView.addSubview(SelectTimePanel!)
        SelectTimePanel?.align(Align.UnderMatchingLeft, relativeTo: SelectDocotorPanel!, padding: 0, width: YMSizes.PageWidth, height: 144.LayoutVal())
        
        SelectTimePanel?.addSubview(titleLabel)
        titleLabel.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 0, width: titleLabel.width, height: 60.LayoutVal())
        
        SelectTimeButton = YMLayout.GetTouchableView(useObject: Actions!, useMethod: PageJumpActions.PageJumpToByViewSenderSel, userStringData: "")
        
        SelectTimePanel?.addSubview(SelectTimeButton!)
        SelectTimeButton?.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: 84.LayoutVal())
        
        SelectTimeLabel.text = PageAppointmentBodyView.AppointmentTimeString
        SelectTimeLabel.textColor = YMColors.FontGray
        SelectTimeLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
        SelectTimeLabel.sizeToFit()
        
        SelectTimeButton?.addSubview(SelectTimeLabel)
        SelectTimeLabel.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 0, width: SelectTimeLabel.width, height: 84.LayoutVal())
    }
    
    private func DrawPhotoButton() {
        let photoButton = YMLayout.GetTouchableImageView(useObject: Actions!, useMethod: "PhotoSelect:", imageName: "PageAppointmentPhotoIcon")
        
        BodyView.addSubview(photoButton)
        photoButton.anchorToEdge(Edge.Top, padding: 230.LayoutVal(), width: photoButton.width, height: photoButton.height)
    }
}

































