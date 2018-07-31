//
//  Color.swift
//  CompanyList
//
//  Created by Nuri Chun on 7/22/18.
//  Copyright © 2018 tetra. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static let darkBlue = UIColor(red: 9/255, green: 45/255, blue: 64/255, alpha: 1)
    static let lightBlue = UIColor.rgb(r: 218, g: 235, b: 244)
    static let lightRed = UIColor(red: 247/255, green: 66/255, blue: 82/255, alpha: 1)
    static let tealColor = UIColor(red: 48/255, green: 164/255, blue: 182/255, alpha: 1)
    
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: alpha)
    }
}
