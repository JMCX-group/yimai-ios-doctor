//
//  PageYiMaiActions.swift
//  YiMai
//
//  Created by why on 16/5/20.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PageYiMaiActions: PageJumpActions{
    public func QRButtonTouched(sender : UITapGestureRecognizer) {
        var style = LBXScanViewStyle()
        
        style.centerUpOffset = 44
        
        //扫码框周围4个角的类型设置为在框的上面
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.On
        //扫码框周围4个角绘制线宽度
        style.photoframeLineW = 6
        
        //扫码框周围4个角的宽度
        style.photoframeAngleW = 24
        
        //扫码框周围4个角的高度
        style.photoframeAngleH = 24
        
        //显示矩形框
        style.isNeedShowRetangle = true;
        
        //动画类型：网格形式，模仿支付宝
        style.anmiationStyle = LBXScanViewAnimationStyle.LineMove
        
        //网格图片
//        style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_part_net"]
        
        //码框周围4个角的颜色
        style.colorAngle = YMColors.FontBlue // [UIColor colorWithRed:65./255. green:174./255. blue:57./255. alpha:1.0]
        
        //矩形框颜色
        style.colorRetangleLine = YMColors.FontGray // [UIColor colorWithRed:247/255. green:202./255. blue:15./255. alpha:1.0];
        
        //非矩形框区域颜色
        style.red_notRecoginitonArea = 247.0/255
        style.green_notRecoginitonArea = 202.0/255
        style.blue_notRecoginitonArea = 15.0/255
        style.alpa_notRecoginitonArea = 0.2
        
        let vc = LBXScanViewController()
//        SubLBXScanViewController *vc = [SubLBXScanViewController new];
        vc.scanStyle = style
        
        //开启只识别矩形框内图像功能
        vc.isOpenInterestRect = true
        
        self.NavController?.pushViewController(vc, animated: true)
    }

    public func FriendCellTouched(sender : UITapGestureRecognizer) {
        let cell = sender.view as! YMTouchableView
        PageYiMaiDoctorDetailBodyView.DocId = cell.UserStringData
        DoJump(YMCommonStrings.CS_PAGE_YIMAI_DOCTOR_DETAIL_NAME)
    }
    
    public func YiMaiR1TabTouched(sender: YMButton) {
        let parent = self.Target as! PageYiMaiViewController
        parent.ShowYiMaiR1Page()
    }
    
    public func YiMaiR2TabTouched(sender: YMButton) {
        let parent = self.Target as! PageYiMaiViewController
        parent.ShowYiMaiR2Page()
    }
    
    
    public func DoSearch(editor: YMTextField) {
        let searchKey = editor.text
        if(YMValueValidator.IsEmptyString(searchKey)) {
            return
        } else {
            PageGlobalSearchViewController.InitSearchKey = editor.text!
            DoJump(YMCommonStrings.CS_PAGE_GLOBAL_SEARCH_NAME)
        }
    }
}