//
//  MenuItemViewCustomizable.swift
//  PagingMenuController
//
//  Created by Zoe on 3/6/17.
//  Copyright © 2017 TokkiTech. All rights reserved.
//


import Foundation
import UIKit

public protocol MenuItemViewCustomizable {
    var horizontalMargin: CGFloat { get }
    var displayMode: MenuItemDisplayMode { get }
}

public extension MenuItemViewCustomizable {
    var horizontalMargin: CGFloat {
        return 20
    }
    var displayMode: MenuItemDisplayMode {
        let title = MenuItemText()
        return .text(title: title)
    }
}

public enum MenuItemDisplayMode {
    case text(title: MenuItemText)
    case multilineText(title: MenuItemText, description: MenuItemText)
    case image(image: UIImage, selectedImage: UIImage?)
    case custom(view: UIView)
}

public struct MenuItemText {
    let text: String
    let color: UIColor
    let selectedColor: UIColor
    let font: UIFont
    let selectedFont: UIFont
    //font: UIFont = UIFont(name: "Helvetica-Light", size: 18)!,
   // selectedFont: UIFont(name: "Helvetica-Light", size: 16)!
    public init(text: String = "Menu",
                color: UIColor = UIColor.white,
                selectedColor: UIColor = UIColor.white,
                font: UIFont = UIFont(name: "Helvetica-Light", size: 18)!,
                selectedFont: UIFont = UIFont(name: "Helvetica-Light", size: 16)!) {
        self.text = text
        self.color = color
        self.selectedColor = selectedColor
        self.font = font
        self.selectedFont = selectedFont
    }
}
