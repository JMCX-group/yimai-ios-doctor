//
//  PageMyPatientListBodyView.swift
//  YiMai
//
//  Created by superxing on 16/9/27.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon
import ChameleonFramework

public class PageMyPatientListBodyView: PageBodyView {
    var PatientActions: PageMyPatientListActions!
    
    let PatientCountLabel = YMLabel()
    let AppointmentCountLabel = YMLabel()
    let Face2FaceCountLabel = YMLabel()
    
    let CountView = UIView()
    
    override func ViewLayout() {
        super.ViewLayout()
        
        PatientActions = PageMyPatientListActions(navController: self.NavController!, target: self)
    }
    
    func DrawFullBody() {
        
        BodyView.addSubview(CountView)
        CountView.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 200.LayoutVal())
        
        func GetCell(iconName: String, label: YMLabel, title: String, parent: UIView) -> UIView {
            let cell = UIView()
            cell.backgroundColor = YMColors.White
            
            let icon = YMLayout.GetSuitableImageView(iconName)
            let titleLabel = YMLayout.GetNomalLabel(title, textColor: YMColors.FontBlue, fontSize: 30.LayoutVal())
            
            label.backgroundColor = HexColor("#f0f0f0")
            label.font = YMFonts.YMDefaultFont(20.LayoutVal())
            label.textAlignment = NSTextAlignment.Center
            label.textColor = YMColors.FontGray
            
            parent.addSubview(cell)
            cell.anchorToEdge(Edge.Left, padding: 0, width: 250.LayoutVal(), height: 200.LayoutVal())
            
            cell.addSubview(icon)
            cell.addSubview(titleLabel)
            cell.addSubview(label)
            
            icon.anchorToEdge(Edge.Top, padding: 40.LayoutVal(), width: icon.width, height: icon.height)
            titleLabel.align(Align.UnderCentered, relativeTo: icon, padding: 20.LayoutVal(), width: titleLabel.width, height: titleLabel.height)
            label.align(Align.UnderCentered, relativeTo: titleLabel, padding: 10.LayoutVal(), width: label.width, height: 28.LayoutVal())
            label.UserObjectData = titleLabel
            
            return cell
        }
        
        let patientCell = GetCell("PageMyPatientListIconPatient", label: PatientCountLabel, title: "患者", parent: CountView)
        let appointmentCell = GetCell("PageMyPatientListIconAppointment", label: AppointmentCountLabel, title: "约诊", parent: CountView)
        let f2cCell = GetCell("PageMyPatientListIconF2F", label: Face2FaceCountLabel, title: "当面咨询", parent: CountView)
        
        CountView.groupAndFill(group: Group.Horizontal, views: [patientCell, appointmentCell, f2cCell], padding: 0)
        
        let divider1 = UIView()
        let divider2 = UIView()
        divider1.backgroundColor = YMColors.DividerLineGray
        divider2.backgroundColor = YMColors.DividerLineGray
        
        CountView.addSubview(divider1)
        CountView.addSubview(divider2)
        
        divider1.anchorToEdge(Edge.Left, padding: 250.LayoutVal(), width: YMSizes.OnPx, height: CountView.height)
        divider2.anchorToEdge(Edge.Right, padding: 250.LayoutVal(), width: YMSizes.OnPx, height: CountView.height)
    }
    
    func Clear() {
        YMLayout.ClearView(view: BodyView)
        DrawFullBody()
    }
    
    func LoadData(data: [String: AnyObject]) {
        func ShowNumbers(text: String, label: YMLabel) {
            label.text = text
            label.sizeToFit()
            
            let titleLabel = label.UserObjectData as! UILabel
            label.align(Align.UnderCentered, relativeTo: titleLabel, padding: 10.LayoutVal(), width: label.width + 60.LayoutVal(), height: 30.LayoutVal())
            label.SetSemicircleBorder()
        }
        
        let patientListPanel = UIView()
        BodyView.addSubview(patientListPanel)
        patientListPanel.align(Align.UnderMatchingLeft, relativeTo: CountView, padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: 0)
        
        let appointmentCount = "\(data["appointment_count"]!)次"
        let f2fCount = "\(data["face_to_face_count"]!)次"
        let patientCount = "\(data["patient_count"]!)人"
        
        ShowNumbers(appointmentCount, label: AppointmentCountLabel)
        ShowNumbers(f2fCount, label: Face2FaceCountLabel)
        ShowNumbers(patientCount, label: PatientCountLabel)
        
        func GetPatientCell(patientInfo: [String: AnyObject], parent: UIView, prev: UIView?) -> UIView {
            let cell = UIView()
            cell.backgroundColor = YMColors.White
            
            parent.addSubview(cell)
            if (nil != prev ) {
                cell.align(Align.UnderMatchingLeft, relativeTo: prev!, padding: 0, width: YMSizes.PageWidth, height: 160.LayoutVal())
            } else {
                cell.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 160.LayoutVal())
            }
            
//            ["id": 2,
//             "appointment_count": 19,
//             "face_to_face_count": 0,
//             "phone": 12365234,
//             "age": 44,
//             "avatar": <null>,
//             "sex": 1,
//             "name": 特斯拉]
            
            let patientHead = YMLayout.GetSuitableImageView("PageMyPatientListIconPatientHead")
            let name = UILabel()
            let divider = UIView()
            let title = YMLayout.GetNomalLabel("患者", textColor: YMColors.FontGray, fontSize: 22.LayoutVal())
            let infoIcon = YMLayout.GetSuitableImageView("PageMyPatientListIconUserInfo")
            let gander = UILabel()
            let age = UILabel()
            let phone = UILabel()
            let admissionIcon = YMLayout.GetSuitableImageView("PageMyPatientListIconAdmission")
            let appointmentCount = UILabel()
            let f2fCount = UILabel()
            let border = UIView()
            border.backgroundColor = YMColors.DividerLineGray
            
            cell.addSubview(patientHead)
            cell.addSubview(name)
            cell.addSubview(divider)
            cell.addSubview(title)
            cell.addSubview(infoIcon)
            cell.addSubview(gander)
            cell.addSubview(age)
            cell.addSubview(phone)
            cell.addSubview(admissionIcon)
            cell.addSubview(appointmentCount)
            cell.addSubview(f2fCount)
            cell.addSubview(border)
            
            if("<null>" != "\(patientInfo["avatar"]!)") {
                if(!YMValueValidator.IsEmptyString("\(patientInfo["avatar"]!)")) {
                    YMLayout.LoadImageFromServer(patientHead, url: "\(patientInfo["avatar"])", fullUrl: nil, makeItRound: true)
                }
            }
            
            name.text = "\(patientInfo["name"]!)"
            name.textColor = YMColors.FontBlue
            name.font = YMFonts.YMDefaultFont(30.LayoutVal())
            name.sizeToFit()
            
            divider.backgroundColor = YMColors.FontBlue
            
            if("0" == "\(patientInfo["sex"]!)") {
                gander.text = "女"
            } else {
                gander.text = "男"
            }
            gander.textColor = YMColors.FontGray
            gander.font = YMFonts.YMDefaultFont(22.LayoutVal())
            gander.sizeToFit()
            
            if("0" != "\(patientInfo["age"]!)") {
                age.text = "\(patientInfo["age"]!)岁"
            }
            age.textColor = YMColors.FontBlue
            age.font = YMFonts.YMDefaultFont(22.LayoutVal())
            age.sizeToFit()
            
            phone.text = "\(patientInfo["phone"]!)"
            phone.textColor = YMColors.FontBlue
            phone.sizeToFit()
            
            if("0" != "\(patientInfo["appointment_count"]!)") {
                appointmentCount.text = "约诊 (\(patientInfo["appointment_count"]!)次)"
                appointmentCount.textColor = YMColors.FontGray
                appointmentCount.font = YMFonts.YMDefaultFont(22.LayoutVal())
                appointmentCount.sizeToFit()
            }
            
            if("0" != "\(patientInfo["face_to_face_count"])") {
                f2fCount.text = "当面咨询 (\(patientInfo["face_to_face_count"]!)次)"
                f2fCount.textColor = YMColors.FontGray
                f2fCount.font = YMFonts.YMDefaultFont(22.LayoutVal())
                f2fCount.sizeToFit()
            }
            
            patientHead.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: patientHead.width, height: patientHead.height)
            name.anchorInCorner(Corner.TopLeft, xPad: 180.LayoutVal(), yPad: 32.LayoutVal(), width: name.width, height: name.height)
            divider.align(Align.ToTheRightCentered, relativeTo: name, padding: 14.LayoutVal(), width: YMSizes.OnPx, height: 20.LayoutVal())
            title.align(Align.ToTheRightCentered, relativeTo: divider, padding: 14.LayoutVal(), width: title.width, height: title.height)
            infoIcon.align(Align.UnderMatchingLeft, relativeTo: name, padding: 14.LayoutVal(), width: infoIcon.width, height: infoIcon.height)
            gander.align(Align.ToTheRightCentered, relativeTo: infoIcon, padding: 6.LayoutVal(), width: gander.width, height: gander.height)
            age.align(Align.ToTheRightCentered, relativeTo: gander, padding: 6.LayoutVal(), width: age.width, height: age.height)
            phone.align(Align.ToTheRightCentered, relativeTo: age, padding: 6.LayoutVal(), width: phone.width, height: phone.height)
            admissionIcon.align(Align.UnderMatchingLeft, relativeTo: infoIcon, padding: 14.LayoutVal(), width: admissionIcon.width, height: admissionIcon.height)
            appointmentCount.align(Align.ToTheRightCentered, relativeTo: admissionIcon, padding: 6.LayoutVal(), width: appointmentCount.width, height: appointmentCount.height)
            f2fCount.align(Align.ToTheRightCentered, relativeTo: appointmentCount, padding: 6.LayoutVal(), width: f2fCount.width, height: f2fCount.height)
            border.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: YMSizes.OnPx)
            return cell
        }
        
        var cell: UIView? = nil
        let patientList =  data["patient_list"] as! [[String: AnyObject]]
        for patient in patientList{
            cell = GetPatientCell(patient, parent: patientListPanel, prev: cell)
        }
        
        if(nil != cell) {
            YMLayout.SetViewHeightByLastSubview(patientListPanel, lastSubView: cell!)
            YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: patientListPanel)
        }
    }
}























