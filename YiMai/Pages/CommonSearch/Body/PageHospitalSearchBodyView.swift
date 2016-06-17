//
//  PageHospitalSearchBodyView.swift
//  YiMai
//
//  Created by why on 16/6/15.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageHospitalSearchBodyView: PageBodyView {
    private var SearchInput: YMTextField? = nil
    private let InputPanel: UIView = UIView()
    
    private var hospitalActions: PageHospitalSearchActions? = nil
    private var SearchResultTable: YMTableView? = nil
    
    public override func ViewLayout() {
        hospitalActions = PageHospitalSearchActions(navController: self.NavController, target: self)
        SearchResultTable = YMTableView(builer: self.DrawHospitalCell, subBuilder: nil, touched: hospitalActions!.HospitalSelected)

        super.ViewLayout()
        DrawPageTop()
        DrawInitList()
    }
    
    public func DrawPageTop() {
        let inputParam = TextFieldCreateParam()
        inputParam.BackgroundColor = YMColors.White
        inputParam.Placholder = "输入医院名称"
        inputParam.FontSize = 26.LayoutVal()
        inputParam.FontColor = YMColors.FontBlue
        
        let InputPanel = UIView()
        
        BodyView.addSubview(InputPanel)
        InputPanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 120.LayoutVal())

        SearchInput = YMLayout.GetTextFieldWithMaxCharCount(inputParam, maxCharCount: 20)
        InputPanel.addSubview(SearchInput!)
        
        SearchInput?.anchorToEdge(Edge.Left, padding: 30.LayoutVal(), width: 570.LayoutVal(), height: 60.LayoutVal())
        SearchInput?.layer.cornerRadius = 6.LayoutVal()
        SearchInput?.layer.masksToBounds
        SearchInput?.SetLeftPadding(66.LayoutVal(), leftPaddingImage: "CommonIconSearchHeader")

        SearchInput?.EditEndCallback = hospitalActions!.StartSearch
        
        let manuallyInputButton = YMButton()
        manuallyInputButton.setTitle("没找到？", forState: UIControlState.Normal)
        manuallyInputButton.setTitleColor(YMColors.FontGray, forState: UIControlState.Normal)
        manuallyInputButton.titleLabel?.font = YMFonts.YMDefaultFont(26.LayoutVal())
        manuallyInputButton.sizeToFit()
        
        InputPanel.addSubview(manuallyInputButton)
        manuallyInputButton.align(Align.ToTheRightCentered,
            relativeTo: SearchInput!,
            padding: 30.LayoutVal(),
            width: manuallyInputButton.width,
            height: manuallyInputButton.height)
    }
    
    private func DrawHospitalCell(cell: YMTableViewCell, data: AnyObject?) {
        let realData = data as! [String: AnyObject]
        
        cell.CellTitleHeight = 81.LayoutVal()
        cell.CellFullHeight = 81.LayoutVal()
        
        cell.CellData = data
        
        let cellInner = UIView(frame: CGRect(x: 0,y: 0,width: YMSizes.PageWidth,height: 81.LayoutVal()))
        let hospitalName = realData[YMCommonStrings.CS_API_PARAM_KEY_HOSPITAL] as! String
        
        let hospitalLabel = UILabel()
        hospitalLabel.text = hospitalName
        hospitalLabel.textColor = YMColors.FontGray
        hospitalLabel.font = YMFonts.YMDefaultFont(28.LayoutVal())
        hospitalLabel.sizeToFit()
        
        cellInner.addSubview(hospitalLabel)
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = YMColors.DividerLineGray
        cellInner.addSubview(bottomLine)
        
        hospitalLabel.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: 700.LayoutVal(), height: hospitalLabel.height)
        bottomLine.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: 1.LayoutVal())
        
        cell.addSubview(cellInner)
    }
    
    private func DrawInitList() {
    }
    
    public func DrawSearchResult() {
        SearchResultTable?.Clear()
    }
}













































