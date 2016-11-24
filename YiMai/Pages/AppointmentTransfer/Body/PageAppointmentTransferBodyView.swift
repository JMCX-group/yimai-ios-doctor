//
//  PageAppointmentTransferBodyView.swift
//  YiMai
//
//  Created by why on 16/5/27.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon
import Photos

public class PageAppointmentTransferBodyView: PageBodyView {
    private var PatientBasicInfoPanel: YMTouchableView? = nil
    private var PatientConditionPanel: YMTouchableView? = nil
    private var PhotoIcon = YMLayout.GetSuitableImageView("PageAppointmentTransferPhotoIcon")
    
    private var PhotoPanel: UIView? = nil
    private var PhotoInnerPanel: UIScrollView? = nil
    
    private var PhotoScrollLeftButton: YMTouchableView? = nil
    private var PhotoScrollRightButton: YMTouchableView? = nil
    
    private var SelectDoctorPanel: UIView? = nil
    private var SelectDoctorButton: YMTouchableView? = nil
    private let SelectDoctorButtonIcon = YMLayout.GetSuitableImageView("PageAppointmentTransferAddDoctorIcon")
    private let SelectDoctorButtonLabel = UILabel()
    private var SelectedDoctorCell: UIView? = nil
    
    private var SelectTimePanel: UIView? = nil
    private var SelectTimeButton: YMTouchableView? = nil
    private let SelectTimeLabel = UILabel()
    
    private var ConfirmButton: YMButton? = nil
    
    private var MorePhotoButton: UIView? = nil
    private var LastImage: UIView? = nil
    private var ImageCount: Int = 0
    
    public static var PatientBasicInfoString: String = ""
    public static var PatientConditionString: String = ""
    public static var AppointmentTimeString: String = "点击此处选择时间"
    private var AllowedSelection: UInt = 10
    public var PhotoArray = [UIImage]()
    
    public func DeleteImage() {
        AllowedSelection += 1
    }
    
    public func ImagesSelected(selectedPhotos: [PHAsset]) {
        for asset in selectedPhotos {
            let img = YMLayout.TransPHAssetToUIImage(asset)
            let imgView = UIImageView(image: img)

            self.PhotoArray.append(img)
            AddImage(imgView)
            
        }
        
        if(UInt(selectedPhotos.count) > AllowedSelection) {
            AllowedSelection = 0
        } else {
            AllowedSelection = AllowedSelection - UInt(selectedPhotos.count)
        }
        
        if(AllowedSelection > 10) {
            AllowedSelection = 0
        }
    }

    
    func ParseData() {
        let patientInfo = PageAppointmentTransferViewController.AppointmentData!["patient_info"] as! [String: AnyObject]
        PageAppointmentTransferViewController.SelectedTime = PageAppointmentAcceptBodyView.TimeInfo
        PageAppointmentTransferViewController.PatientBasicInfo = ["name": "\(patientInfo["name"]!)"]
        PageAppointmentTransferViewController.PatientCondition = patientInfo["history"] as! String
    }
    
    public func Reload() {
        ParseData()
        self.DrawDocCell(PageAppointmentTransferViewController.SelectedDoctor)
        self.UpdateSelectedTime()
        self.UpdateBasicInfo()
        self.UpdateCondition()
    }

    override func ViewLayout() {
        YMLayout.BodyLayoutWithTop(ParentView!, bodyView: BodyView)
        BodyView.backgroundColor = YMColors.PanelBackgroundGray

        DrawPatientBasicInfoPanel()
        DrawPatientConditionPanel()
        DrawPhotoPanel()
        DrawSelectDoctorPanel()
        DrawSelectTimePanel()
        DrawConfirmButton()
    }
    
    private func DrawPatientTextLabel(text: String, panel: UIView, textColor: UIColor) {
        let textLabel = UILabel()
        textLabel.text = text;
        textLabel.font = YMFonts.YMDefaultFont(28.LayoutVal())
        textLabel.textColor = textColor
        textLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        
        panel.addSubview(textLabel)
        textLabel.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: 630.LayoutVal(), height: 80.LayoutVal())
    }
    
    private func UpdateBasicInfo(){
        if(nil == PageAppointmentTransferViewController.PatientBasicInfo){
            DrawPatientBasicInfoPanel()
        } else {
            let info = PageAppointmentTransferViewController.PatientBasicInfo!
            let name = info["name"]!
            
            for view in PatientBasicInfoPanel!.subviews{
                view.removeFromSuperview()
            }
            
            DrawPatientTextLabel(name, panel: PatientBasicInfoPanel!, textColor: YMColors.FontGray)

        }
    }
    
    private func DrawPatientBasicInfoPanel() {
        PatientBasicInfoPanel = YMLayout.GetTouchableView(useObject: Actions!,
                                                          useMethod: PageJumpActions.DoNothingSel,
                                                          userStringData: YMCommonStrings.CS_PAGE_APPOINTMENT_PATIENT_BASIC_INFO_NAME)
        BodyView.addSubview(PatientBasicInfoPanel!)
        PatientBasicInfoPanel?.anchorToEdge(Edge.Top, padding: 30.LayoutVal(), width: YMSizes.PageWidth, height: 80.LayoutVal())
        
        DrawPatientTextLabel("患者基本信息（必填）", panel: PatientBasicInfoPanel!, textColor: YMColors.FontGray)
    }
    
    private func UpdateCondition() {
        for view in PatientConditionPanel!.subviews{
            view.removeFromSuperview()
        }
        
        if("" == PageAppointmentTransferViewController.PatientCondition){
            DrawPatientTextLabel("现病史", panel: PatientConditionPanel!, textColor: YMColors.FontGray)
        } else {
            DrawPatientTextLabel(PageAppointmentTransferViewController.PatientCondition, panel: PatientConditionPanel!, textColor: YMColors.FontGray)
        }
    }
    
    private func DrawPatientConditionPanel() {
        PatientConditionPanel = YMLayout.GetTouchableView(useObject: Actions!,
                                                          useMethod: PageJumpActions.DoNothingSel,
                                                          userStringData: YMCommonStrings.CS_PAGE_APPOINTMENT_PATIENT_CONDITION_NAME)
        BodyView.addSubview(PatientConditionPanel!)
        PatientConditionPanel?.align(Align.UnderMatchingLeft, relativeTo: PatientBasicInfoPanel!,
                                     padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: 80.LayoutVal())
        
        DrawPatientTextLabel("现病史", panel: PatientConditionPanel!, textColor: YMColors.FontGray)
    }
    
    private func GetTooltipCell(info: String = "", prevCell: UIView? = nil, background: UIImageView? = nil) -> UIView {
        let cell = UIView()
        PhotoInnerPanel?.addSubview(cell)
        
        var userData = [String: AnyObject]()

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
        cell.layer.masksToBounds = true
        
        if(nil != background) {
            cell.addSubview(background!)
            background!.anchorInCenter(width: cell.width, height: cell.height)
        }

        userData["cell"] = cell

        return cell
    }
    
    private func DrawPhotoPanel() {
        PhotoPanel = UIView()
        BodyView.addSubview(PhotoPanel!)
        PhotoPanel?.align(Align.UnderMatchingLeft, relativeTo: PatientConditionPanel!, padding: 92.LayoutVal(), width: YMSizes.PageWidth, height: 254.LayoutVal())
        PhotoPanel?.backgroundColor = YMColors.White
        
        PhotoInnerPanel = UIScrollView()
        PhotoPanel?.addSubview(PhotoInnerPanel!)
        
        PhotoInnerPanel?.anchorInCorner(Corner.TopLeft, xPad: 58.LayoutVal(), yPad: 80.LayoutVal(), width: 635.LayoutVal(), height: 144.LayoutVal())
        
        PhotoScrollLeftButton = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "PhotoScrollLeft:".Sel())
        PhotoScrollRightButton = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "PhotoScrollRight:".Sel())
        
        PhotoPanel?.addSubview(PhotoScrollLeftButton!)
        PhotoPanel?.addSubview(PhotoScrollRightButton!)
        
        let scrollLeftIcon = YMLayout.GetSuitableImageView("PageAppointmentTransferPhotoScrollLeft")
        let scrollRightIcon = YMLayout.GetSuitableImageView("PageAppointmentTransferPhotoScrollRight")
        
        PhotoScrollLeftButton?.addSubview(scrollLeftIcon)
        PhotoScrollRightButton?.addSubview(scrollRightIcon)

        PhotoScrollLeftButton?.anchorInCorner(Corner.TopLeft, xPad: 0, yPad: 80.LayoutVal(), width: 40.LayoutVal(), height: 144.LayoutVal())
        PhotoScrollRightButton?.anchorInCorner(Corner.TopRight, xPad: 0, yPad: 80.LayoutVal(), width: 40.LayoutVal(), height: 144.LayoutVal())
        
        scrollLeftIcon.anchorToEdge(Edge.Right, padding: 0, width: scrollLeftIcon.width, height: scrollLeftIcon.height)
        scrollRightIcon.anchorToEdge(Edge.Left, padding: 0, width: scrollRightIcon.width, height: scrollRightIcon.height)
        
        var cell = GetTooltipCell("病例资料", prevCell: nil)
        cell = GetTooltipCell("病例资料", prevCell: cell)
        cell = GetTooltipCell("病例资料", prevCell: cell)
        cell = GetTooltipCell("其他", prevCell: cell)
        MorePhotoButton = GetTooltipCell("更多资料", prevCell: cell)
        
        MorePhotoButton?.hidden = true
    }
    
    private func DrawDocCell(data: [String: AnyObject]?) {
        if(nil == data) {return}
        
        SelectedDoctorCell = UIView()
        let dataObj = data!
        let head = dataObj[YMYiMaiStrings.CS_DATA_KEY_USERHEAD] as! String
        let name = dataObj[YMYiMaiStrings.CS_DATA_KEY_NAME] as! String
        let hospital = dataObj[YMYiMaiStrings.CS_DATA_KEY_HOSPATIL] as! String
        let department = dataObj[YMYiMaiStrings.CS_DATA_KEY_DEPARTMENT] as! String
        let jobTitle = dataObj[YMYiMaiStrings.CS_DATA_KEY_JOB_TITLE] as! String
        
        let nameLabel = UILabel()
        let divider = UIView(frame: CGRect(x: 0,y: 0,width: YMSizes.OnPx,height: 20.LayoutVal()))
        let jobTitleLabel = UILabel()
        let deptLabel = UILabel()
        let hosLabel = UILabel()
        let userHeadBackground = YMLayout.GetSuitableImageView("YiMaiGeneralHeadImageBorder")
        
        nameLabel.text = name
        nameLabel.textColor = YMColors.FontBlue
        nameLabel.font = YMFonts.YMDefaultFont(30.LayoutVal())
        nameLabel.sizeToFit()
        
        divider.backgroundColor = YMColors.FontBlue
        
        jobTitleLabel.text = jobTitle
        jobTitleLabel.textColor = YMColors.FontGray
        jobTitleLabel.font = YMFonts.YMDefaultFont(22.LayoutVal())
        jobTitleLabel.sizeToFit()
        
        deptLabel.text = department
        deptLabel.textColor = YMColors.FontBlue
        deptLabel.font = YMFonts.YMDefaultFont(22.LayoutVal())
        deptLabel.sizeToFit()
        
        hosLabel.text = hospital
        hosLabel.textColor = YMColors.FontGray
        hosLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
        hosLabel.sizeToFit()
        hosLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail

        
        SelectedDoctorCell!.addSubview(userHeadBackground)
        SelectedDoctorCell!.addSubview(nameLabel)
        SelectedDoctorCell!.addSubview(divider)
        SelectedDoctorCell!.addSubview(jobTitleLabel)
        SelectedDoctorCell!.addSubview(deptLabel)
        SelectedDoctorCell!.addSubview(hosLabel)
        
        SelectDoctorButton!.addSubview(SelectedDoctorCell!)

        SelectedDoctorCell!.fillSuperview()
        SelectedDoctorCell?.backgroundColor = YMColors.White

        
        userHeadBackground.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: userHeadBackground.width, height: userHeadBackground.height)
        nameLabel.anchorInCorner(Corner.TopLeft, xPad: 180.LayoutVal(), yPad: 25.LayoutVal(), width: nameLabel.width, height: nameLabel.height)
        divider.align(Align.ToTheRightCentered, relativeTo: nameLabel, padding: 15.LayoutVal(), width: YMSizes.OnPx, height: divider.height)
        jobTitleLabel.align(Align.ToTheRightCentered, relativeTo: divider, padding: 15.LayoutVal(), width: jobTitleLabel.width, height: jobTitleLabel.height)
        deptLabel.align(Align.UnderMatchingLeft, relativeTo: nameLabel, padding: 6.LayoutVal(), width: deptLabel.width, height: deptLabel.height)
        hosLabel.align(Align.UnderMatchingLeft, relativeTo: deptLabel, padding: 6.LayoutVal(), width: 540.LayoutVal(), height: hosLabel.height)
        
        YMLayout.LoadImageFromServer(userHeadBackground, url: head, fullUrl: nil, makeItRound: true)
    }
    
    private func DrawSelectDoctorPanel() {
        let titleLabel = UILabel()
        
        titleLabel.text = "选择医生"
        titleLabel.textColor = YMColors.FontGray
        titleLabel.font = YMFonts.YMDefaultFont(24.LayoutVal())
        titleLabel.sizeToFit()
        
        SelectDoctorPanel = UIView()
        BodyView.addSubview(SelectDoctorPanel!)
        SelectDoctorPanel?.align(Align.UnderMatchingLeft, relativeTo: PhotoPanel!, padding: 0, width: YMSizes.PageWidth, height: 210.LayoutVal())
        
        SelectDoctorPanel?.addSubview(titleLabel)
        titleLabel.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 0, width: titleLabel.width, height: 60.LayoutVal())
        
        SelectDoctorButton = YMLayout.GetTouchableView(useObject: Actions!,
            useMethod: PageJumpActions.PageJumpToByViewSenderSel,
            userStringData: YMCommonStrings.CS_PAGE_APPOINTMENT_SELECT_DOCTOR_NAME)
        
        SelectDoctorPanel?.addSubview(SelectDoctorButton!)
        SelectDoctorButton?.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: 150.LayoutVal())
        
        SelectDoctorButton?.addSubview(SelectDoctorButtonIcon)
        SelectDoctorButtonIcon.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: SelectDoctorButtonIcon.width, height: SelectDoctorButtonIcon.height)
        
        
        SelectDoctorButtonLabel.textColor = YMColors.FontGray
        SelectDoctorButtonLabel.text = "点击选择医生"
        SelectDoctorButtonLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
        SelectDoctorButtonLabel.sizeToFit()
        
        SelectDoctorButton?.addSubview(SelectDoctorButtonLabel)
        SelectDoctorButtonLabel.align(Align.ToTheRightCentered,
            relativeTo: SelectDoctorButtonIcon,
            padding: 24.LayoutVal(),
            width: SelectDoctorButtonLabel.width, height: SelectDoctorButtonLabel.height)
    }
    
    public func UpdateSelectedTime() {
        if("" == PageAppointmentTransferViewController.SelectedTime) {
            SelectTimeLabel.text = PageAppointmentTransferBodyView.AppointmentTimeString
        } else {
            SelectTimeLabel.text = PageAppointmentTransferViewController.SelectedTime
        }
    }

    private func DrawSelectTimePanel() {
        let titleLabel = UILabel()
        
        titleLabel.text = "期望就诊时间"
        titleLabel.textColor = YMColors.FontGray
        titleLabel.font = YMFonts.YMDefaultFont(24.LayoutVal())
        titleLabel.sizeToFit()
        
        SelectTimePanel = UIView()
        BodyView.addSubview(SelectTimePanel!)
        SelectTimePanel?.align(Align.UnderMatchingLeft, relativeTo: SelectDoctorPanel!, padding: 0, width: YMSizes.PageWidth, height: 144.LayoutVal())
        
        SelectTimePanel?.addSubview(titleLabel)
        titleLabel.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 0, width: titleLabel.width, height: 60.LayoutVal())
        
        SelectTimeButton = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "GoToSelectTime:".Sel(), userStringData: YMCommonStrings.CS_PAGE_APPOINTMENT_SELECT_TIME_NAME)
        
        SelectTimePanel?.addSubview(SelectTimeButton!)
        SelectTimeButton?.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: 84.LayoutVal())
        
        SelectTimeLabel.text = PageAppointmentTransferBodyView.AppointmentTimeString
        SelectTimeLabel.textColor = YMColors.FontGray
        SelectTimeLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
        SelectTimeLabel.sizeToFit()
        
        let icon = YMLayout.GetSuitableImageView("YMIconTimelineTime")
        
        SelectTimeButton?.addSubview(SelectTimeLabel)
        SelectTimeButton?.addSubview(icon)
        
        icon.anchorToEdge(Edge.Left, padding: 70.LayoutVal(), width: icon.width, height: icon.height)
        SelectTimeLabel.align(Align.ToTheRightCentered, relativeTo: icon, padding: 10.LayoutVal(), width: 500.LayoutVal(), height: SelectTimeLabel.height)
        //        SelectTimeLabel.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 0, width: 500.LayoutVal(), height: 84.LayoutVal())
    }
    
    private func DrawConfirmButton() {
        ConfirmButton = YMButton()
        ParentView!.addSubview(ConfirmButton!)
        ConfirmButton?.anchorToEdge(Edge.Bottom, padding: 0.LayoutVal(), width: YMSizes.PageWidth, height: 98.LayoutVal())
        
        ConfirmButton?.addTarget(Actions!, action: "DoAppointment:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)

        ConfirmButton?.backgroundColor = YMColors.CommonBottomGray
        ConfirmButton?.setTitle("发送转诊请求", forState: UIControlState.Normal)
        ConfirmButton?.setTitleColor(YMColors.FontGray, forState: UIControlState.Disabled)
        ConfirmButton?.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        ConfirmButton?.titleLabel?.font = YMFonts.YMDefaultFont(34.LayoutVal())
        ConfirmButton?.enabled = false
    }
    
    public func SetConfirmEnable() {
        ConfirmButton?.enabled = true
        ConfirmButton?.backgroundColor = YMColors.CommonBottomBlue
    }
    
    public func SetConfirmDisable() {
        ConfirmButton?.enabled = false
        ConfirmButton?.backgroundColor = YMColors.CommonBottomGray
    }
    
    public func AddImage(image: UIImageView) {
        self.LastImage = GetTooltipCell("病例资料", prevCell: LastImage, background: image)
        
        ImageCount = ImageCount + 1
        
//        if(ImageCount > 3) {
//            MorePhotoButton?.hidden = false
//            MorePhotoButton!.align(Align.ToTheRightMatchingTop, relativeTo: LastImage!, padding: 19.LayoutVal(), width: 144.LayoutVal(), height: 144.LayoutVal())
//            let x = CGFloat(ImageCount - 3) * (self.MorePhotoButton!.width + 19.LayoutVal())
//            let pos = CGPointMake(x, MorePhotoButton!.frame.origin.y)
//            PhotoInnerPanel?.setContentOffset(pos, animated: true)
//            
//            PhotoInnerPanel?.contentSize = CGSizeMake(
//                MorePhotoButton!.frame.origin.x + MorePhotoButton!.width,
//                PhotoInnerPanel!.height
//            )
//        } else {
            PhotoInnerPanel?.contentSize = CGSizeMake(
                self.LastImage!.frame.origin.x + self.LastImage!.width,
                PhotoInnerPanel!.height
            )
//        }
    }
}

































