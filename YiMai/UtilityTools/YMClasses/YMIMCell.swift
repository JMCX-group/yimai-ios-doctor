//
//  YMIMCell.swift
//  YiMai
//
//  Created by why on 2017/1/3.
//  Copyright © 2017年 why. All rights reserved.
//

import Foundation
import Neon

class YMIMCellForCard: RCMessageBaseCell {
    var JumpActions: PageJumpActions!
    var TargetDoctorId: String = ""
    var SenderId: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isDisplayReadStatus = false
    }
    
    func CellTouched(_: UIGestureRecognizer) {
        PageYiMaiDoctorDetailBodyView.DocId = TargetDoctorId
        JumpActions.DoJump(YMCommonStrings.CS_PAGE_YIMAI_DOCTOR_DETAIL_NAME, ignoreExists: true, userData: "IM")
    }
    
    func getObjectName(_: AnyObject) -> String! {
        return "YMIMCell"
    }
    
    func CellHeaderTouched(_: AnyObject) {
        if(SenderId != YMVar.MyDoctorId) {
            PageYiMaiDoctorDetailBodyView.DocId = SenderId
            JumpActions.DoJump(YMCommonStrings.CS_PAGE_YIMAI_DOCTOR_DETAIL_NAME)
        }
    }
    
    func CellLayout(model: RCMessageModel) {
        let data = model.content as! YMIMMessageContent
        let headimg = YMLayout.GetTouchableImageView(useObject: self, useMethod: "CellHeaderTouched:".Sel(), imageName: "YiMaiDefaultHead")
        
        let msgSenderId = model.senderUserId
        YMLayout.ClearView(view: baseContentView)

        if(nil == msgSenderId) {
            return
        }

        baseContentView.fillSuperview()
        baseContentView.anchorToEdge(Edge.Top, padding: 10.LayoutVal(), width: baseContentView.width, height: baseContentView.height - 10.LayoutVal())
        baseContentView.addSubview(headimg)

        if(nil != msgSenderId) {
            if(msgSenderId == YMVar.MyDoctorId) {
                headimg.anchorInCorner(Corner.TopRight, xPad: 20.LayoutVal(), yPad: 0, width: 92.LayoutVal(), height: 92.LayoutVal())
            } else {
                headimg.anchorInCorner(Corner.TopLeft, xPad: 20.LayoutVal(), yPad: 0, width: 92.LayoutVal(), height: 92.LayoutVal())
            }
        } else {
            headimg.anchorInCorner(Corner.TopLeft, xPad: 20.LayoutVal(), yPad: 0, width: 92.LayoutVal(), height: 92.LayoutVal())
        }
        
//        headimg.anchorInCorner(Corner.TopRight, xPad: 20.LayoutVal(), yPad: 0, width: 92.LayoutVal(), height: 92.LayoutVal())
        headimg.backgroundColor = YMColors.None
        headimg.layer.masksToBounds = true
        headimg.layer.cornerRadius = 10.LayoutVal()
        
        SenderId = model.senderUserId
        let userHead = YMVar.GetLocalUserHeadurl(model.senderUserId)
        YMLayout.LoadImageFromServer(headimg, url: userHead)
        
        
        TargetDoctorId = data.DoctorId
        let cardView = YMLayout.GetTouchableView(useObject: self, useMethod: "CellTouched:".Sel())//UIView()
        baseContentView.addSubview(cardView)
        cardView.backgroundColor = YMColors.White
        cardView.layer.masksToBounds = true
        cardView.layer.cornerRadius = 20.LayoutVal()
        
        if(msgSenderId == YMVar.MyDoctorId) {
            cardView.align(Align.ToTheLeftMatchingTop, relativeTo: headimg, padding: 30.LayoutVal(), width: 550.LayoutVal(), height: 260.LayoutVal())
        } else {
            cardView.align(Align.ToTheRightMatchingTop, relativeTo: headimg, padding: 30.LayoutVal(), width: 550.LayoutVal(), height: 260.LayoutVal())
        }

        let cardHead = YMLayout.GetSuitableImageView("YiMaiDefaultHead")
        cardView.addSubview(cardHead)
        cardHead.anchorInCorner(Corner.TopLeft, xPad: 20.LayoutVal(), yPad: 20.LayoutVal(), width: cardHead.width, height: cardHead.height)
        
        YMLayout.LoadImageFromServer(cardHead, url: data.HeadimgUrl, fullUrl: nil, makeItRound: true)
        
        let cardName = YMLayout.GetNomalLabel(data.DoctorName, textColor: YMColors.FontBlue, fontSize: 30.LayoutVal())
        let cardJobtitle = YMLayout.GetNomalLabel(data.Jobtitle, textColor: YMColors.FontBlue, fontSize: 30.LayoutVal())
        
        cardView.addSubview(cardName)
        cardView.addSubview(cardJobtitle)
        
        cardName.align(Align.ToTheRightCentered, relativeTo: cardHead, padding: 20.LayoutVal(), width: cardName.width, height: cardName.height)
        cardJobtitle.align(Align.ToTheRightCentered, relativeTo: cardName, padding: 10.LayoutVal(), width: cardJobtitle.width, height: cardJobtitle.height)
        
        let divider = UIView()
        divider.backgroundColor = YMColors.FontGray
        cardView.addSubview(divider)
        divider.anchorToEdge(Edge.Top, padding: 140.LayoutVal(), width: 510.LayoutVal(), height: YMSizes.OnPx)
        
        let cardHospital = YMLayout.GetNomalLabel(data.Hospital, textColor: YMColors.FontLightGray, fontSize: 26.LayoutVal())
        let cardDepartment = YMLayout.GetNomalLabel(data.Department, textColor: YMColors.FontLightGray, fontSize: 26.LayoutVal())
        
        cardView.addSubview(cardHospital)
        cardView.addSubview(cardDepartment)
        cardHospital.align(Align.UnderMatchingLeft, relativeTo: divider, padding: 20.LayoutVal(), width: cardHospital.width, height: cardHospital.height)
        cardDepartment.align(Align.UnderMatchingLeft, relativeTo: cardHospital, padding: 10.LayoutVal(), width: cardDepartment.width, height: cardDepartment.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}






