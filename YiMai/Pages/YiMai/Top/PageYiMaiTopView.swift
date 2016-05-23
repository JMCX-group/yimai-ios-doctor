//
//  PageYiMaiTopView.swift
//  YiMai
//
//  Created by why on 16/5/20.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageYiMaiTopView: NSObject {
    private var ParentView : UIView? = nil
    private var NavController : UINavigationController? = nil
    private var Actions: PageYiMaiActions? = nil
    
    public var QRButton: YMTouchableImageView? = nil
    public var AddFriendButton: YMTouchableImageView? = nil
    public var PageContentTab: UIView? = nil
    
    public var CommPageTab: YMTouchableView? = nil

    private let TopView = UIView()
    
    convenience init(parentView: UIView, navController: UINavigationController, pageActions: PageYiMaiActions){
        self.init()
        self.ParentView = parentView
        self.NavController = navController
        self.Actions = pageActions
        ViewLayout()
    }
    
    private func ViewLayout(){
        DrawQRButton()
    }
    
    private func DrawQRButton() {
        let qrImage = UIImage(named: "TopViewQRButton")
        QRButton = YMLayout.GetTouchableImageView(useObject: self.Actions!, useMethod: "QRButtonTouched:", image: qrImage!)
        
        let topTabItem = UIImage(named: "TopViewQRButton")
        QRButton = YMLayout.GetTouchableImageView(useObject: self.Actions!, useMethod: "QRButtonTouched:", image: topTabItem!)

        let addFriendImage = UIImage(named: "TopViewQRButton")
        QRButton = YMLayout.GetTouchableImageView(useObject: self.Actions!, useMethod: "QRButtonTouched:", image: addFriendImage!)
    }
}