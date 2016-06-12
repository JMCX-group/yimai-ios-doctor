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

public class YMTableViewCell: UIView {
    private var Prev: YMTableViewCell? = nil
    private var Next: YMTableViewCell? = nil
    private var ParentTableView: YMTableView!

    public var CellData: AnyObject? = nil
    public var CellInnerView: UIView? = nil
    
    public var SubCell: AnyObject? = nil

    public var Expanded: Bool = false
    
    public var CellTitleHeight: CGFloat = 0
    public var CellFullHeight: CGFloat = 0
}

public class YMTableViewDelegate: NSObject {
    public func CellTouched(sender: UIGestureRecognizer) {
        let cell = sender.view as! YMTableViewCell
        let table = cell.ParentTableView!
        
        table.CellTouched?(cell)
        table.CellExpandStateToggle(cell)
    }
}

public class YMTableView: NSObject {
    let CellList = YMTableViewCell()

    let CellActions = YMTableViewDelegate()
    
    public var CellBuilder: YMTableViewCellBuilder? = nil
    public var CellTouched: YMTableViewCellTouched? = nil
    
    public var TableViewPanel = UIScrollView()
    
    var LastCell: YMTableViewCell? = nil
    let ExpandAnimateLock = NSObject()
    
    init(builer: YMTableViewCellBuilder, touched: YMTableViewCellTouched?) {
        self.CellBuilder = builer
        self.CellTouched = touched
        
        LastCell = CellList
    }
    
    private func GetTouchableView() -> YMTableViewCell {
        let newView = YMTableViewCell()

        let tapGR = UITapGestureRecognizer(target: CellActions, action: "CellTouched:".Sel())
        
        newView.userInteractionEnabled = true
        newView.addGestureRecognizer(tapGR)
        
        return newView
    }
    
    public func AppendCell(data: AnyObject) ->  YMTableView {
        let cell = GetTouchableView()
        self.CellBuilder!(cell, data)
        
        cell.ParentTableView = self
        cell.Prev = LastCell

        LastCell?.Next = cell
        LastCell = cell
        
        return self
    }
    
    public func DrawTableView() ->  YMTableView {
        var cellPointer = CellList.Next
        if(nil != cellPointer) {
            TableViewPanel.addSubview(cellPointer!)
            cellPointer?.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 0, otherSize: (cellPointer?.height)!)
            
            var nextPointer = cellPointer?.Next
            while(nil != nextPointer) {
                TableViewPanel.addSubview(nextPointer!)
                nextPointer?.alignAndFillWidth(align: Align.UnderMatchingLeft, relativeTo: cellPointer!, padding: 0, height: (nextPointer?.height)!)
                
                cellPointer = nextPointer
                nextPointer = nextPointer?.Next
            }
        }
        
        TableViewPanel.contentSize = CGSizeMake(
            LastCell!.width,
            LastCell!.frame.origin.y + LastCell!.height
        )
        return self
    }
    
    public func CellExpandStateToggle(cell: YMTableViewCell) {
        objc_sync_enter(self.ExpandAnimateLock)

        if(nil != cell.SubCell){
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.2)
            if(cell.Expanded) {
                CellCollapse(cell)
                cell.Expanded = false
            } else {
                CellExpand(cell)
                cell.Expanded = true
            }
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseOut)
            UIView.commitAnimations()
        }
        
        objc_sync_exit(self.ExpandAnimateLock)
    }
    
    private func CellCollapse(cell: YMTableViewCell) {
        var cellOffSet: CGFloat = CGFloat.NaN
        var cellPointer = self.CellList.Next

        while(nil != cellPointer) {
            if(CGFloat.NaN != cellOffSet){
                cellPointer!.frame = cell.frame.offsetBy(dx: 0, dy: cellOffSet)
            }
            
            if(cellPointer!.Expanded) {
                cellOffSet = cellPointer!.CellTitleHeight - cellPointer!.CellFullHeight
                let rect = CGRect(origin: cellPointer!.frame.origin, size: CGSize(width: cellPointer!.width, height: cellPointer!.CellTitleHeight))
                cellPointer!.frame = rect
            }
            
            cellPointer = cellPointer?.Next
        }
    }
    
    private func CellExpand(cell: YMTableViewCell) {
        var cellOffSet: CGFloat = CGFloat.NaN
        var cellPointer = self.CellList.Next
        
        while(nil != cellPointer) {
            if(CGFloat.NaN != cellOffSet){
                cellPointer!.frame = cell.frame.offsetBy(dx: 0, dy: cellOffSet)
            }
            
            if(cellPointer!.Expanded) {
                if(CGFloat.NaN == cellOffSet) {cellOffSet = 0}
                cellOffSet = cellOffSet + cellPointer!.CellTitleHeight - cellPointer!.CellFullHeight
                let rect = CGRect(origin: cellPointer!.frame.origin, size: CGSize(width: cellPointer!.width, height: cellPointer!.CellTitleHeight))
                cellPointer!.frame = rect
            }

            if(cell == cellPointer) {
                if(CGFloat.NaN == cellOffSet) {cellOffSet = 0}
                cellOffSet =  cellOffSet + cellPointer!.CellFullHeight - cellPointer!.CellTitleHeight
                let rect = CGRect(origin: cellPointer!.frame.origin, size: CGSize(width: cellPointer!.width, height: cellPointer!.CellFullHeight))
                cellPointer!.frame = rect
            }
            
            cellPointer = cellPointer?.Next
        }
    }
}



















