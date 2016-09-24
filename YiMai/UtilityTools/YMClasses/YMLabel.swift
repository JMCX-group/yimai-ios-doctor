//
//  YMLabel.swift
//  YiMai
//
//  Created by superxing on 16/8/25.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class YMLabel: ActiveLabel {
    public var UserStringData: String = ""
    public var UserObjectData: AnyObject? = nil
    
    public func SetTouchable(withObject actionObject: AnyObject, useMethod actionMethod: Selector) {
        self.userInteractionEnabled = true
        
        let gr = UITapGestureRecognizer(target: actionObject, action: actionMethod)
        self.addGestureRecognizer(gr)
    }
}