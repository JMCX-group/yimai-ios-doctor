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
        
    }
    
    public func YiMaiR1TabTouched(sender: YMButton) {
        let parent = self.Target as! PageYiMaiViewController
        parent.ShowYiMaiR1Page()
    }
    
    public func YiMaiR2TabTouched(sender: YMButton) {
        let parent = self.Target as! PageYiMaiViewController
        parent.ShowYiMaiR2Page()
    }
}