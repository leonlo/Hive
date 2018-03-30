//
//  Misc.swift
//  Hive
//
//  Created by Leon Luo on 11/28/17.
//  Copyright © 2017 leonluo. All rights reserved.
//

import UIKit

public struct Specs {
    public struct Color {
        public let marked = UIColor(hex: 0xbabdbe)
        public let unMarked = UIColor(hex: 0x424242)
        
        public let themePrimaryColor = UIColor(hex: 0x0288d1)
        public let themeDarkColor = UIColor(hex: 0x005b9f)

        
        public let tint = UIColor(hex: 0x455a64)
        public let red = UIColor(hex: 0xea545d)
        public let white = UIColor.white
        public let black = UIColor.black
        public let gray = UIColor.gray
        public let lightGray = UIColor(hex: 0xe0e0e0)
        public let blueGray = UIColor(hex: 0x607d8b)
        public let separator = UIColor(hex: 0xe0e0e0)
        public let almostClear = UIColor(red: 0, green: 0, blue: 0, alpha: 0.002)
    }
    
    public static let color = Color()
    
    public struct FontSize {
        public let tiny: CGFloat = 10
        public let small: CGFloat = 12
        public let regular: CGFloat = 14
        public let large: CGFloat = 16
    }
    
    public static let fontSize = FontSize()

    public struct Font {
        private static let regularName = "Lato-Regular"
        private static let boldName = "Lato-Bold"
        
        public let tiny = UIFont(name: regularName, size: Specs.fontSize.tiny)
        public let small = UIFont(name: regularName, size: Specs.fontSize.small)
        public let regular = UIFont(name: regularName, size: Specs.fontSize.regular)
        public let large = UIFont(name: regularName, size: Specs.fontSize.large)
        public let smallBold = UIFont(name: boldName, size: Specs.fontSize.small)
        public let regularBold = UIFont(name: boldName, size: Specs.fontSize.regular)
        public let largeBold = UIFont(name: boldName, size: Specs.fontSize.large)

    }
    public static let font = Font()

}
