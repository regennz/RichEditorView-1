//
//  Color+Extensions.swift
//
//  Created by Caesar Wirth on 10/9/16.
//  Edited by Hung on 04/10/2021.
//
//
import UIKit

extension UIColor {
    /// Hexadecimal representation of the UIColor.
    /// For example, UIColor.black becomes "#000000".
    var hex: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: nil)

        let r = Int(255.0 * red)
        let g = Int(255.0 * green)
        let b = Int(255.0 * blue)

        let str = String(format: "#%02x%02x%02x", r, g, b)
        return str
    }
}

extension String {
    /// UIColor of the hex string
    /// For example, "#000000" becomes UIColor.black.
    var color: UIColor {
        let r, g, b, a: CGFloat

        if self.hasPrefix("#") {
            let start = self.index(self.startIndex, offsetBy: 1)
            let hexColor = String(self[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    return UIColor.init(red: r, green: g, blue: b, alpha: a)
                }
            }
        }

        return UIColor(white: 1.0, alpha: 0.0)
    }
}
