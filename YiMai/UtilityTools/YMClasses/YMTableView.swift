//
//  YMTableView.swift
//  YiMai
//
//  Created by ios-dev on 16/6/11.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public typealias YMTableViewCellTouched = ((YMTableViewCell) -> Void)
public typealias YMTableViewCellBuilder = ((YMTableViewCell, AnyObject?) -> Void)
public typealias YMTableViewSubCellBuilder = ((YMTableViewCell, AnyObject?) -> Void)

public class YMTableViewCell: YMTouchableView {
    private var Prev: YMTableViewCell? = nil
    private var Next: YMTableViewCell? = nil
    private var ParentCell: YMTableViewCell? = nil
    private var ParentTableView: YMTableView!

    private var CellData: AnyObject? = nil
    private var CellInnerView: UIView? = nil
}

public class YMTableViewDelegate: NSObject {
    public func CellTouched(sender: UIGestureRecognizer) {
        let cell = sender.view! as! YMTableViewCell
        let tableView = cell.ParentTableView
        
        if(nil != tableView.CellTouched) {
            tableView.CellTouched!(cell)
        }
    }
}

public class YMTableView: NSObject {
    private var CellList: YMTableViewCell = YMTableViewCell()
    private var CellBuilder: YMTableViewCellBuilder?
    private var SubCellBuilder: YMTableViewSubCellBuilder?
    private var TableViewPanel: UIScrollView = UIScrollView()
    private let Actions = YMTableViewDelegate()
    
    public var CellTouched: YMTableViewCellTouched? = nil

    private static func GetTableCell(useObject actionTarget: AnyObject, useMethod actionFunc: Selector, userStringData: String = "") -> YMTableViewCell {
        let newView = YMTableViewCell()
        
        newView.UserStringData = userStringData
        let tapGR = UITapGestureRecognizer(target: actionTarget, action: actionFunc)
        
        newView.userInteractionEnabled = true
        newView.addGestureRecognizer(tapGR)
        newView.backgroundColor = YMColors.White
        
        return newView
    }
    init(cellBuilder: YMTableViewCellBuilder,
         subCellBuilder: YMTableViewSubCellBuilder,
         cellTouched: YMTableViewCellTouched? = nil) {
        self.CellBuilder = cellBuilder
        self.SubCellBuilder = subCellBuilder
        self.CellTouched = cellTouched
    }
    
    public func CreateCell(data: AnyObject?) {
        let cellView = YMTableView.GetTableCell(useObject: Actions, useMethod: "CellTouched:".Sel())
        self.CellBuilder!(cellView, data)
    }
    
    public func CreateSubCell(data: AnyObject?) {
        let cellView = YMTableView.GetTableCell(useObject: Actions, useMethod: "CellTouched:".Sel())
        self.SubCellBuilder!(cellView, data)
    }
}



















