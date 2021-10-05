//
//  File.swift
//
//
//  Created by Hung on 04/10/2021.
//

import Foundation
import UIKit

public class TextAttribute: NSObject, Codable {
    public var format = TextAttributeFormat()
    public var textInfo = TextAttributeTextInfo()
    
    enum CodingKeys: String, CodingKey {
        case format = "format"
        case textInfo = "textInfo"
    }
    
    public override var description: String {
        return """
        TextAttribute {
            format: \(format.description),
            textInfo: \(textInfo.description)
        }
        """
    }
}

public struct TextAttributeFormat: Codable {
    public var hasBold = false
    public var hasItalic = false
    public var hasUnderline = false
    public var hasStrikethrough = false
    public var hasSubscript = false
    public var hasSuperscript = false
    public var hasJustifyLeft = false
    public var hasJustifyCenter = false
    public var hasJustifyRight = false
    public var hasHeading1 = false
    public var hasHeading2 = false
    public var hasHeading3 = false
    public var hasHeading4 = false
    public var hasHeading5 = false
    public var hasHeading6 = false
    public var hasOrderedList = false
    public var hasUnorderedList = false
    public var hasLink = false
    
    enum CodingKeys: String, CodingKey {
        case hasBold = "isBold"
        case hasItalic = "isItalic"
        case hasUnderline = "isUnderline"
        case hasStrikethrough = "isStrikethrough"
        case hasSubscript = "isSubscript"
        case hasSuperscript = "isSuperscript"
        case hasJustifyLeft = "isJustifyLeft"
        case hasJustifyCenter = "isJustifyCenter"
        case hasJustifyRight = "isJustifyRight"
        case hasHeading1 = "isHeading1"
        case hasHeading2 = "isHeading2"
        case hasHeading3 = "isHeading3"
        case hasHeading4 = "isHeading4"
        case hasHeading5 = "isHeading5"
        case hasHeading6 = "isHeading6"
        case hasOrderedList = "isOrderedList"
        case hasUnorderedList = "isUnorderedList"
        case hasLink = "isLink"
    }
    
    public var description: String {
        return """
        TextAttributeFormat {
                hasBold: \(hasBold),
                hasItalic: \(hasItalic),
                hasUnderline: \(hasUnderline),
                hasStrikethrough: \(hasStrikethrough),
                hasSubscript: \(hasSubscript),
                hasSuperscript: \(hasSuperscript),
                hasJustifyLeft: \(hasJustifyLeft),
                hasJustifyCenter: \(hasJustifyCenter),
                hasJustifyRight: \(hasJustifyRight),
                hasHeading1: \(hasHeading1),
                hasHeading2: \(hasHeading2),
                hasHeading3: \(hasHeading3),
                hasHeading4: \(hasHeading4),
                hasHeading5: \(hasHeading5),
                hasHeading6: \(hasHeading6),
                hasOrderedList: \(hasOrderedList),
                hasUnorderedList: \(hasUnorderedList),
                hasLink: \(hasLink)
            }
        """
    }
}

public struct TextAttributeTextInfo: Codable {
    private var textColor: String = ""
    private var textBackgroundColor: String = ""
    
    public var size: Int = 0
    
    public var color: UIColor {
        return textColor.color
    }
    
    public var backgroundColor: UIColor {
        return textBackgroundColor.color
    }
    
    enum CodingKeys: String, CodingKey {
        case textColor = "textColor"
        case textBackgroundColor = "backgroundColor"
        case size = "fontSize"
    }
    
    init(textHexColor: String = "",
         textBackgroundHexColor: String = "",
         size: Int = 0)
    {
        textColor = textHexColor
        textBackgroundColor = textBackgroundHexColor
        self.size = size
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        textColor = try container.decode(String.self, forKey: .textColor)
        
        textBackgroundColor = try container.decode(String.self, forKey: .textBackgroundColor)
        
        var value = try container.decode(String.self, forKey: .size)
        value = value.replacingOccurrences(of: "px", with: "")
        if let size = Int(value) {
            self.size = size
        }
    }
    
    public var description: String {
        return """
        TextAttributeTextInfo {
                textColor: \(textColor),
                textBackgroundColor: \(textBackgroundColor),
                size: \(size)
            }
        """
    }
}
