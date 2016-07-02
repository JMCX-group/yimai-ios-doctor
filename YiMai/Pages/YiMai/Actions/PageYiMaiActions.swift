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