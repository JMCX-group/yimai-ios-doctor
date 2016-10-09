//
//  PageAllCollegeListBodyView.swift
//  YiMai
//
//  Created by old-king on 16/10/6.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

class PageAllCollegeListBodyView: PageBodyView {
    static var SelectedCollege: [String: AnyObject]? = nil
    
    var CollegeActions: PageAllCollegeListActions!
    
    var CollegeData = [[String: AnyObject]]()
    
    var SearchInput: YMTextField!
    var SearchPanel = UIView()
    
    override func ViewLayout() {
        super.ViewLayout()
        CollegeActions = PageAllCollegeListActions(navController: self.NavController!, target: self)
        DrawSearchPanel()
    }
    
    func DrawSearchPanel() {
        let inputParam = TextFieldCreateParam()
        inputParam.BackgroundColor = YMColors.White
        inputParam.Placholder = "毕业院校关键字"
        inputParam.FontSize = 26.LayoutVal()
        inputParam.FontColor = YMColors.FontBlue
        
        SearchInput = YMLayout.GetTextFieldWithMaxCharCount(inputParam, maxCharCount: 20)
        BodyView.addSubview(SearchPanel)
        SearchPanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 120.LayoutVal())
        
        SearchPanel.addSubview(SearchInput)
        SearchInput.anchorInCenter(width: 670.LayoutVal(), height: 60.LayoutVal())
        
        SearchInput.layer.cornerRadius = 6.LayoutVal()
        SearchInput.layer.masksToBounds = true
        SearchInput.SetLeftPadding(66.LayoutVal(), leftPaddingImage: "CommonIconSearchHeader")
        
        SearchInput.EditEndCallback = CollegeActions.StartSearch
    }
    
    func DrawCell(data: [String: AnyObject], prev: UIView) -> YMTouchableView {
        let cell = YMLayout.GetTouchableView(useObject: CollegeActions, useMethod: "CollegeSelect:".Sel())
        BodyView.addSubview(cell)
        cell.align(Align.UnderMatchingLeft,
                   relativeTo: prev,
                   padding: 0, width: YMSizes.PageWidth, height: 80.LayoutVal())
        
        cell.UserObjectData = data
        
        let name = "\(data["name"]!)"
        let nameLabel = YMLayout.GetNomalLabel(name, textColor: YMColors.FontGray, fontSize: 28.LayoutVal())
        let searchKey = SearchInput.text!
        if(!YMValueValidator.IsEmptyString(searchKey)) {
            let highlight = ActiveType.Custom(pattern: searchKey)
            nameLabel.enabledTypes = [highlight]
            nameLabel.customColor[highlight] = YMColors.FontBlue
            nameLabel.text = name
        }
        
        cell.addSubview(nameLabel)
        nameLabel.anchorToEdge(Edge.Left, padding: 40.LayoutVal(),
                               width: nameLabel.width, height: nameLabel.height)
        
        let border = UIView()
        cell.addSubview(border)
        border.backgroundColor = YMColors.CommonBottomGray
        border.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: YMSizes.OnPx)
        return cell
    }
    
    func LoadData(data: [[String: AnyObject]]) {
        YMLayout.ClearView(view: BodyView)
        BodyView.addSubview(SearchPanel)
        SearchPanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 120.LayoutVal())
        
        var prev: UIView = SearchPanel
        for v in data {
            prev = DrawCell(v, prev: prev)
        }
        
        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: prev)
        FullPageLoading.Hide()
    }
    
    func Clear() {
        YMLayout.ClearView(view: BodyView)
        FullPageLoading.Hide()
        SearchInput.text = ""
    }
}
























