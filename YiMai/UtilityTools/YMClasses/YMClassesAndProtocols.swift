//
//  YMProtocols.swift
//  YiMai
//
//  Created by why on 16/4/16.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class StoryboardThatExist {
    public static let StoryboardMap: [String:Bool] = [
        YMCommonStrings.CS_PAGE_INDEX_NAME:true,
        YMCommonStrings.CS_PAGE_PERSONAL_NAME:true,
        YMCommonStrings.CS_PAGE_LOGIN_NAME:true,
        YMCommonStrings.CS_PAGE_COMMON_SEARCH_NAME:true,
        YMCommonStrings.CS_PAGE_REGISTER_NAME:true,
        YMCommonStrings.CS_PAGE_REGISTER_PERSONAL_INFO_NAME:true,
        YMCommonStrings.CS_PAGE_REGISTER_INPUT_HOSPITAL_NAME:true,
        YMCommonStrings.CS_PAGE_FACE_2_FACE_INFO_INPUT_NAME:true,
        YMCommonStrings.CS_PAGE_FACE_2_FACE_QR_NAME:true,
        YMCommonStrings.CS_PAGE_MASSAGE_LIST_NAME:true,
        YMCommonStrings.CS_PAGE_MY_ADMISSIONS_LIST_NAME:true,
        YMCommonStrings.CS_PAGE_YIMAI_NAME:true,
        YMCommonStrings.CS_PAGE_YIMAI_ADD_FRIENDS_NAME:true,
        YMCommonStrings.CS_PAGE_YIMAI_ADD_CONTCATS_FRIENDS_NAME:true,
        YMCommonStrings.CS_PAGE_YIMAI_MANUAL_ADD_FRIEND_NAME:true,
        YMCommonStrings.CS_PAGE_YIMAI_SAME_AREAS_NAME:true,
        YMCommonStrings.CS_PAGE_YIMAI_SAME_SCHOOL_NAME:true,
        YMCommonStrings.CS_PAGE_YIMAI_SAME_HOSPITAL_NAME:true,
        YMCommonStrings.CS_PAGE_APPOINTMENT_NAME:true,
        YMCommonStrings.CS_PAGE_APPOINTMENT_PATIENT_BASIC_INFO_NAME: true,
        YMCommonStrings.CS_PAGE_APPOINTMENT_PATIENT_CONDITION_NAME: true,
        YMCommonStrings.CS_PAGE_APPOINTMENT_SELECT_DOCTOR_NAME: true,
        YMCommonStrings.CS_PAGE_APPOINTMENT_SELECT_TIME_NAME: true,
        YMCommonStrings.CS_PAGE_APPOINTMENT_UPDATE_NAME: true,
        YMCommonStrings.CS_PAGE_PERSONAL_SETTING_NAME: true,
        YMCommonStrings.CS_PAGE_ACCOUNT_SETTING_NAME: true,
        YMCommonStrings.CS_PAGE_PERSONAL_PASSWORD_RESET_NAME: true,
        YMCommonStrings.CS_PAGE_PERSONAL_ID_NUM_INPUT_NAME: true,
        YMCommonStrings.CS_PAGE_PERSONAL_DETAIL_NAME: true,
        YMCommonStrings.CS_PAGE_PERSONAL_DETAIL_EDIT_NAME: true,
        YMCommonStrings.CS_PAGE_PERSONAL_INTRO_EDIT_NAME: true,
        YMCommonStrings.CS_PAGE_PERSONAL_NAME_EDIT_NAME: true,
        YMCommonStrings.CS_PAGE_PERSONAL_DOCTOR_AUTH_NAME: true,
        YMCommonStrings.CS_PAGE_APPOINTMENT_RECORD_NAME: true,
        YMCommonStrings.CS_PAGE_APPOINTMENT_DETAIL_NAME: true,
        YMCommonStrings.CS_PAGE_FORGET_PASSWORD_NAME: true,
        YMCommonStrings.CS_PAGE_ABOUT_YIMAI_NAME: true,
        YMCommonStrings.CS_PAGE_YIMAI_LAWYER_INFO: true,
        YMCommonStrings.CS_PAGE_YIMAI_INTRO_NAME: true,
        YMCommonStrings.CS_PAGE_YIMAI_CONTACT_NAME: true,
        YMCommonStrings.CS_PAGE_PERSONAL_PRIVATE_SETTING_NAME: true,
        YMCommonStrings.CS_PAGE_YIMAI_DOCTOR_DETAIL_NAME: true,
        YMCommonStrings.CS_PAGE_NEW_FRIEND_NAME: true,
        YMCommonStrings.CS_PAGE_GLOBAL_SEARCH_NAME: true,
        YMCommonStrings.CS_PAGE_MY_ADMISSIONS_SETTING_NAME: true,
        YMCommonStrings.CS_PAEG_ADMISSION_TIME_SETTING_NAME: true,
        YMCommonStrings.CS_PAEG_ADMISSION_CHARGE_SETTING_NAME: true,
        YMCommonStrings.CS_PAGE_APPOINTMENT_ACCEPT_NAME: true,
        YMCommonStrings.CS_PAGE_APPOINTMENT_ACCEPT_DETAIL_NAME: true,
        YMCommonStrings.CS_PAGE_APPOINTMENT_PROCESSING_NAME: true,
        YMCommonStrings.CS_PAGE_ADD_FRIEND_QR_CARD: true,
        YMCommonStrings.CS_PAGE_MY_INFO_CARD: true,
        YMCommonStrings.CS_PAGE_REAUIRE_PAPER_CARD: true,
        YMCommonStrings.CS_PAGE_COMMON_TEXT_INPUT: true,
        YMCommonStrings.CS_PAGE_PAPER_CARD_PREVIEW: true,
        YMCommonStrings.CS_PAGE_APPOINTMENT_TRANSFER: true,
        YMCommonStrings.CS_PAGE_PATIENT_LIST: true,
        YMCommonStrings.CS_PAGE_ALL_COLLEGE_LIST: true,
        YMCommonStrings.CS_PAGE_INPUT_MY_FEATURES: true,
        YMCommonStrings.CS_PAGE_SYS_BROADCAST: true,
        YMCommonStrings.CS_PAGE_SHOW_WEB_PAGE: true,
        YMCommonStrings.CS_PAGE_AUTH_PROCESSING: true,
        YMCommonStrings.CS_PAGE_MY_WALLET_NAME: true,
        YMCommonStrings.CS_PAGE_MY_WALLET_RECORD: true,
        YMCommonStrings.CS_PAGE_GET_APPOINMENT_MSG_LIST: true,
        YMCommonStrings.CS_PAGE_AUTH_COMPLETE: true,
        YMCommonStrings.CS_PAGE_BLACKLIST_NAME: true,
        YMCommonStrings.CS_PAGE_PERSONAL_CHANGE_PHONE_NAME: true,
        YMCommonStrings.CS_PAGE_ACCEPET_COMMON_TEXT: true,
        YMCommonStrings.CS_PAGE_COMMON_TEXT_AREA: true,
        YMCommonStrings.CS_PAGE_BANK_CARD_LIST_NAME: true,
        YMCommonStrings.CS_PAGE_ADD_BANKCARD_NAME: true,
        YMCommonStrings.CS_PAGE_GET_ADMISSSION_MSG_LIST: true
    ]
}

public class NoBackByGesturePage {
    public static let PageMap: [String:Bool] = [
        YMCommonStrings.CS_PAGE_LOGIN_NAME: true,
        YMCommonStrings.CS_PAGE_REGISTER_PERSONAL_INFO_NAME: true,
        YMCommonStrings.CS_PAGE_INDEX_NAME:true,
        YMCommonStrings.CS_PAGE_PERSONAL_NAME:true,
        YMCommonStrings.CS_PAGE_YIMAI_NAME:true
    ]
}

public protocol PageJumpActionsProtocol {
//    var ControllersDict : Dictionary<String, UIViewController> {get set}
    var NavController : UINavigationController? {get set}
    func PageJumpTo(sender:YMButton)
    func PageJumpToByViewSender(sender : UITapGestureRecognizer)
    func PageJumpToByImageViewSender(sender : UITapGestureRecognizer)
}

public class PageJumpActions: NSObject, PageJumpActionsProtocol{
    public static var ControllersDict : Dictionary<String, UIViewController>? = nil// Dictionary<String, UIViewController>()
    public var NavController : UINavigationController? = nil
    public var JumpWidthAnimate = true
    public var Target: AnyObject? = nil
    
    public static let PageJumToSel: Selector = "PageJumpTo:".Sel()
    public static let PageJumpToByViewSenderSel: Selector = "PageJumpToByViewSender:".Sel()
    public static let PageJumpToByImageViewSenderSel: Selector = "PageJumpToByImageViewSender:".Sel()
    public static let DoNothingSel = "DoNothingActions:".Sel()
    
    convenience init(navController: UINavigationController?) {
        self.init()
        self.NavController = navController
        
        ExtInit()
    }
    
    convenience init(navController: UINavigationController?, target: AnyObject) {
        self.init()
        self.NavController = navController
        self.Target = target
        
        ExtInit()
    }
    
    func ExtInit() {}
    
    public func DoNothingActions(param: AnyObject) {}
    
    public func DoJump(targetPageName: String, ignoreExists: Bool = false, userData: Any? = nil) {
        var targetPage: UIViewController? = nil
        
        if(nil == PageJumpActions.ControllersDict) {
            PageJumpActions.ControllersDict = Dictionary<String, UIViewController>()
        }
        
        if(nil != PageJumpActions.ControllersDict?.indexForKey(targetPageName)){
            if(ignoreExists) {
                targetPage = YMLayout.GetStoryboardControllerByName(targetPageName)!
            } else {
                targetPage = PageJumpActions.ControllersDict![targetPageName]!
            }
        } else {
            targetPage = YMLayout.GetStoryboardControllerByName(targetPageName)!
            PageJumpActions.ControllersDict?[targetPageName] = targetPage
        }
        
        let tempPage = targetPage as? PageViewController
        tempPage?.UserData = userData
        
        YMCurrentPage.CurrentPage = targetPageName
        
        var push = true
        for ctrl in self.NavController!.viewControllers {
            if(targetPage == ctrl) {
                push = false
                break
            }
        }

        if(push) {
            self.NavController!.pushViewController(targetPage!, animated: JumpWidthAnimate)
        } else {
            self.NavController!.popToViewController(targetPage!, animated: JumpWidthAnimate)
        }
    }

    public func PageJumpTo(sender:YMButton) {
        if(nil == self.NavController){return}
        let targetPageName = sender.UserStringData
        if((StoryboardThatExist.StoryboardMap[targetPageName]) != nil){
            DoJump(targetPageName)
        }
    }
    
    public func PageJumpToByViewSender(sender : UITapGestureRecognizer) {
        if(nil == self.NavController){return}
        
        let targetView = sender.view!
        
        if(targetView.isKindOfClass(YMTouchableView)){
            let touchableView = targetView as! YMTouchableView
            let targetPageName = touchableView.UserStringData
            if((StoryboardThatExist.StoryboardMap[targetPageName]) != nil){
                DoJump(targetPageName)
            } else {
                print("page \(targetPageName) not exist")
            }
        }
    }
    
    public func PageJumpToByImageViewSender(sender : UITapGestureRecognizer) {
        if(nil == self.NavController){return}
        
        let targetView = sender.view!
        
        if(targetView.isKindOfClass(YMTouchableImageView)){
            let touchableView = targetView as! YMTouchableImageView
            let targetPageName = touchableView.UserStringData
            if((StoryboardThatExist.StoryboardMap[targetPageName]) != nil){
                DoJump(targetPageName)
            } else {
                print("page \(targetPageName) not exist")
            }
        }
    }
}

public class PageViewController: UIViewController, UIGestureRecognizerDelegate{
    internal var PageLayoutFlag = false
    internal var TopView : PageCommonTopView? = nil
    internal var BottomView : PageCommonBottomView? = nil
    internal var NavController: UINavigationController? = nil
    internal var SelfView: UIView? = nil
    public var LoadingView: YMPageLoadingView? = nil
    
    var UserData: Any? = nil

    internal func GestureRecognizerEnable() -> Bool {return true}

    override public func prefersStatusBarHidden() -> Bool {return false}
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.interactivePopGestureRecognizer?.enabled = self.GestureRecognizerEnable()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

        self.PageLayout()
        // Do any additional setup after loading the view.
    }
    
    override public func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        //Do some release operation
        self.PageDisapeared()
    }
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        //Do some refresh operations
        self.PageRefresh()
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Do some pre-refresh operations
        self.PagePreRefresh()
    }
    
    public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if(gestureRecognizer.isKindOfClass(UIScreenEdgePanGestureRecognizer)) {
            if(nil == NoBackByGesturePage.PageMap[YMCurrentPage.CurrentPage]) {
                return true
            } else {
                return false
            }
        }

        return true
    }
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer.isKindOfClass(UIScreenEdgePanGestureRecognizer)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func PageLayout() {
        NavController = self.navigationController
        SelfView = self.view
    }
    
    internal func PageDisapeared() {}
    internal func PageRefresh() {
        if(!PageLayoutFlag){PageLayoutFlag = true}
    }
    internal func PagePreRefresh() {}
}

class YMBodyTableView: UITableView {
    var BodyViewContentSize = CGSize.zero
}

public class PageBodyView: NSObject, UIScrollViewDelegate {
    internal var ParentView: UIView? = nil
    internal var NavController: UINavigationController? = nil
    internal var Actions: AnyObject? = nil
    var FullPageLoading: YMPageLoadingView!
//    var BodyView: YMBodyTableView = YMBodyTableView()
    var BodyView: UIScrollView = UIScrollView()
    
    convenience init(parentView: UIView, navController: UINavigationController, pageActions: AnyObject? = nil) {
        self.init()
        self.ParentView = parentView
        self.NavController = navController
        self.Actions = pageActions
        
        FullPageLoading = YMPageLoadingView(parentView: parentView)
        BodyView.alwaysBounceVertical = true
        
//        BodyView.delegate = self
//        BodyView.dataSource = self
        
//        BodyView.separatorStyle = UITableViewCellSeparatorStyle.None

        BodyView.delegate = self
        self.ViewLayout()
    }
    
    internal func ViewLayout(){
        YMLayout.BodyLayoutWithTop(ParentView!, bodyView: BodyView)
        BodyView.backgroundColor = YMColors.BackgroundGray
    }
    
    func BodyViewEndDragging() {
//        BodyView.contentSize = BodyView.BodyViewContentSize
//        print(self.BodyView.contentOffset)
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
//    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        BodyView.contentSize = BodyView.BodyViewContentSize
        
//        let cell = UITableViewCell()
//        cell.backgroundColor = YMColors.None
//        return cell
//    }
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        BodyViewEndDragging()
    }
    
    deinit {
        print("PageBodyView deinit")
    }
}















