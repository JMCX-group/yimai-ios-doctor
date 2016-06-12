//
//  PageCommonSearchBodyView.swift
//  YiMai
//
//  Created by why on 16/6/6.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageCommonSearchBodyView: PageBodyView {
    private var ResultList: YMTableView? = nil
    
    override func ViewLayout() {
        super.ViewLayout()
        
        BuildTable()
    }
    
    private func CellBuilder(cell: YMTableViewCell, data: AnyObject?) -> Void {
        let realData = data as! [String: AnyObject]
        let cellInner = UILabel()
        cellInner.backgroundColor = YMColors.FontBlue
        cellInner.font = YMFonts.YMDefaultFont(20.LayoutVal())
        cellInner.text = realData["idx"] as? String
        cellInner.textColor = YMColors.White
        cellInner.sizeToFit()
        
        cell.frame = CGRect(x: 0,y: 0, width: YMSizes.PageWidth, height: 40.LayoutVal())
        cell.CellTitleHeight = 40.LayoutVal()
        cell.CellFullHeight = 40.LayoutVal()
        cell.addSubview(cellInner)
        cell.CellData = data
        
        cellInner.fillSuperview()
        
        if(nil != realData["sub"]) {
            cell.SubCell = realData["sub"]!
            
            let subTable = realData["sub"]! as! YMTableView
            
            cell.CellFullHeight = 40.LayoutVal() + subTable.TableViewPanel.height
            cell.addSubview(subTable.TableViewPanel)
            let subTableView = subTable.TableViewPanel
            subTable.TableViewPanel.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: -40.LayoutVal(), otherSize: subTableView.height)

        }
        
        cell.CellInnerView = cellInner
    }

    private func SubCellBuilder(cell: YMTableViewCell, data: AnyObject?) -> Void {
        let realData = data as! [String: AnyObject]
        let cellInner = UILabel()
        cellInner.backgroundColor = YMColors.White
        cellInner.font = YMFonts.YMDefaultFont(16.LayoutVal())
        cellInner.text = realData["idx"] as? String
        cellInner.textColor = YMColors.FontGray
        cellInner.textAlignment = NSTextAlignment.Center
        cellInner.sizeToFit()
        
        cell.frame = CGRect(x: 0,y: 0, width: YMSizes.PageWidth, height: 40.LayoutVal())
        cell.CellTitleHeight = 40.LayoutVal()
        cell.CellFullHeight = 40.LayoutVal()
        cell.addSubview(cellInner)
        
        cellInner.fillSuperview()
        cell.CellInnerView = cellInner
    }
    
    private func CellTouched(cell: YMTableViewCell) -> Void {
        print("CellTouched")

    }
    
    private func SubCellTouched(cell: YMTableViewCell) -> Void {
        print("SubCellTouched")
    }
    
    private func BuildTable() {
        ResultList?.TableViewPanel.removeFromSuperview()
        ResultList = YMTableView(builer: CellBuilder, touched: CellTouched)
        
        let content = [
            ["a","b","c"],
            ["a","b","c"],
            ["a","b","c"],
            ["a","b","c"],
            ["a","b","c"],
            ["a","b","c"],
            ["a","b","c"],
            ["a","b","c"],
            ["a","b","c"],
            ["a","b","c"],
            ["a","b","c"],
            ["a","b","c"],
            ["a","b","c"],
            ["a","b","c"],
            ["a","b","c"],
            ["a","b","c"],
            ["a","b","c"],
            ["a","b","c"],
            ["a","b","c"],
            []
        ]
        
        var i = 0
        for v in content {
            var subTable:YMTableView? = nil
            var data = [String: AnyObject]()

            if(0 != v.count){
                subTable = YMTableView(builer: SubCellBuilder, touched: SubCellTouched)
                
                for sv in v {

                    var subData = [String: AnyObject]()
                    subData["data"] = sv
                    subData["idx"] = "index: \(sv)"
                    subTable!.AppendCell(subData)
                }
                
                data["sub"] = subTable!
                
                subTable?.DrawTableView()
            }
            
            data["data"] = v
            data["idx"] = "index: \(i++)"

            ResultList?.AppendCell(data)
        }
        
        ResultList?.DrawTableView()
        
        BodyView.addSubview(ResultList!.TableViewPanel)
        ResultList?.TableViewPanel.fillSuperview()
    }
}








