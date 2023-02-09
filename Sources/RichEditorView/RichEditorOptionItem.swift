//
//  RichEditorOptionItem.swift
//
//  Created by Caesar Wirth on 4/2/15.
//  Copyright (c) 2015 Caesar Wirth. All rights reserved.
//
import UIKit

/// A RichEditorOption object is an object that can be displayed in a RichEditorToolbar.
/// This protocol is proviced to allow for custom actions not provided in the RichEditorOptions enum.
public protocol RichEditorOption {

    /// The image to be displayed in the RichEditorToolbar.
    var image: UIImage? { get }

    /// The title of the item.
    /// If `image` is nil, this will be used for display in the RichEditorToolbar.
    var title: String { get }
    
    /// The font icon of the item.
    /// This will be used for display in the RichEditorToolbar as custom option.
    var fontIcon: String { get }
    
    var type : String { get }

    /// The action to be evoked when the action is tapped
    /// - parameter editor: The RichEditorToolbar that the RichEditorOption was being displayed in when tapped.
    ///                     Contains a reference to the `editor` RichEditorView to perform actions on.
    func action(_ editor: RichEditorToolbar)
}

/// RichEditorOptionItem is a concrete implementation of RichEditorOption.
/// It can be used as a configuration object for custom objects to be shown on a RichEditorToolbar.
public struct RichEditorOptionItem: RichEditorOption {

    /// The image that should be shown when displayed in the RichEditorToolbar.
    public var image: UIImage?

    /// If an `itemImage` is not specified, this is used in display
    public var title: String
    
    /// This is used in display as custom option
    public var fontIcon: String
    
    /// Type of option
    public var type: String

    /// The action to be performed when tapped
    public var handler: ((RichEditorToolbar) -> Void)

    public init(type: String, image: UIImage?, title: String, fontIcon: String, action: @escaping ((RichEditorToolbar) -> Void)) {
        self.type = type
        self.image = image
        self.title = title
        self.fontIcon = fontIcon
        self.handler = action
    }
    
    // MARK: RichEditorOption
    
    public func action(_ toolbar: RichEditorToolbar) {
        handler(toolbar)
    }
}

/// RichEditorOptions is an enum of standard editor actions
public enum RichEditorDefaultOption: RichEditorOption {

    case clear
    case undo
    case redo
    case bold
    case italic
    case underline
    case checkbox
    case `subscript`
    case superscript
    case strike
    case textColor
    case textBackgroundColor
    case header(Int)
    case indent
    case outdent
    case orderedList
    case unorderedList
    case alignLeft
    case alignCenter
    case alignRight
    case image
    case video
    case link
    case table
    case fontSize
    case separator
    case done
    case spacer
    
    public static let all: [RichEditorDefaultOption] = [
        //.clear,
        //.undo, .redo,
        .done,
        .bold, .italic, .underline,
        .checkbox, .subscript, .superscript, .strike,
        .textColor, .textBackgroundColor,
        .header(1), .header(2), .header(3), .header(4), .header(5), .header(6),
        .indent, outdent, orderedList, unorderedList,
        .alignLeft, .alignCenter, .alignRight, .image, .video, .link, .table,
        .fontSize
    ]

    // MARK: RichEditorOption
    public var image: UIImage? {
        var name = ""
        switch self {
        case .clear: name = "clear"
        case .undo: name = "undo"
        case .redo: name = "redo"
        case .bold: name = "bold"
        case .italic: name = "italic"
        case .underline: name = "underline"
        case .checkbox: name = "checkbox"
        case .subscript: name = "subscript"
        case .superscript: name = "superscript"
        case .strike: name = "strikethrough"
        case .textColor: name = "text_color"
        case .textBackgroundColor: name = "bg_color"
        case .header(let h): name = "h\(h)"
        case .indent: name = "indent"
        case .outdent: name = "outdent"
        case .orderedList: name = "ordered_list"
        case .unorderedList: name = "unordered_list"
        case .alignLeft: name = "justify_left"
        case .alignCenter: name = "justify_center"
        case .alignRight: name = "justify_right"
        case .image: name = "insert_image"
        case .video: name = "insert_video"
        case .link: name = "insert_link"
        case .table: name = "insert_table"
        case .fontSize: name = "font_size"
        case .separator: name = "separator"
        case .done: name = "done"
        case .spacer: name = ""
        }
        
        return UIImage(named: name, in: .module, compatibleWith: nil)
    }
    
    public var title: String {
        switch self {
        case .clear: return NSLocalizedString("Clear", comment: "")
        case .undo: return NSLocalizedString("Undo", comment: "")
        case .redo: return NSLocalizedString("Redo", comment: "")
        case .bold: return NSLocalizedString("Bold", comment: "")
        case .italic: return NSLocalizedString("Italic", comment: "")
        case .underline: return NSLocalizedString("Underline", comment: "")
        case .checkbox: return NSLocalizedString("Checkbox", comment: "")
        case .subscript: return NSLocalizedString("Sub", comment: "")
        case .superscript: return NSLocalizedString("Super", comment: "")
        case .strike: return NSLocalizedString("Strike", comment: "")
        case .textColor: return NSLocalizedString("Color", comment: "")
        case .textBackgroundColor: return NSLocalizedString("BG Color", comment: "")
        case .header(let h): return NSLocalizedString("H\(h)", comment: "")
        case .indent: return NSLocalizedString("Indent", comment: "")
        case .outdent: return NSLocalizedString("Outdent", comment: "")
        case .orderedList: return NSLocalizedString("Ordered List", comment: "")
        case .unorderedList: return NSLocalizedString("Unordered List", comment: "")
        case .alignLeft: return NSLocalizedString("Left", comment: "")
        case .alignCenter: return NSLocalizedString("Center", comment: "")
        case .alignRight: return NSLocalizedString("Right", comment: "")
        case .image: return NSLocalizedString("Image", comment: "")
        case .video: return NSLocalizedString("Video", comment: "")
        case .link: return NSLocalizedString("Link", comment: "")
        case .table: return NSLocalizedString("Table", comment: "")
        case .fontSize: return NSLocalizedString("Size", comment: "")
        case .separator: return NSLocalizedString("|", comment: "")
        case .done: return NSLocalizedString("Done", comment: "")
        case .spacer: return NSLocalizedString(" ", comment: "")

        }
    }
    
    public var fontIcon: String {
        switch self {
        case .clear: return "􀆙"
        case .undo: return "􀱍"
        case .redo: return "􀱓"
        case .bold: return "􀅓"
        case .italic: return "􀅔"
        case .underline: return "􀅕"
        case .checkbox: return "􀃲"
        case .subscript: return "􀓡"
        case .superscript: return "􀓢"
        case .strike: return "􀅖"
        case .textColor: return "􀎗"
        case .textBackgroundColor: return "􀎑"
        case .header(let h): return "H\(h)"
        case .indent: return "􀋵"
        case .outdent: return "􀋶"
        case .orderedList: return "􀋴"
        case .unorderedList: return "􀢽"
        case .alignLeft: return "􀌀"
        case .alignCenter: return "􀌁"
        case .alignRight: return "􀌂"
        case .image: return "􀏅"
        case .video: return "􀍉"
        case .link: return "􀉣"
        case .table: return "􀏣"
        case .fontSize: return "􀅐"
        case .separator: return "|"
        case .done: return "􀓖"
        case .spacer: return " "
        }
    }
    
    public var type: String {
        switch self {
        case .clear: return "clear"
        case .undo: return "undo"
        case .redo: return "redo"
        case .bold: return "bold"
        case .italic: return "italic"
        case .underline: return "underline"
        case .checkbox: return "checkbox"
        case .subscript: return "subscript"
        case .superscript: return "superscript"
        case .strike: return "strikethrough"
        case .textColor: return "text_color"
        case .textBackgroundColor: return "bg_color"
        case .header(let h): return "h\(h)"
        case .indent: return "indent"
        case .outdent: return "outdent"
        case .orderedList: return "ordered_list"
        case .unorderedList: return "unordered_list"
        case .alignLeft: return "justify_left"
        case .alignCenter: return "justify_center"
        case .alignRight: return "justify_right"
        case .image: return "insert_image"
        case .video: return "insert_video"
        case .link: return "insert_link"
        case .table: return "insert_table"
        case .fontSize: return "font_size"
        case .separator: return "separator"
        case .done: return "done"
        case .spacer: return "spacer"
        }
    }
    
    public func action(_ toolbar: RichEditorToolbar) {
        switch self {
        case .clear: toolbar.editor?.removeFormat()
        case .undo: toolbar.editor?.undo()
        case .redo: toolbar.editor?.redo()
        case .bold: toolbar.editor?.bold()
        case .italic: toolbar.editor?.italic()
        case .underline: toolbar.editor?.underline()
        case .checkbox: toolbar.editor?.checkbox()
        case .subscript: toolbar.editor?.subscriptText()
        case .superscript: toolbar.editor?.superscript()
        case .strike: toolbar.editor?.strikethrough()
        case .textColor: toolbar.delegate?.richEditorToolbarChangeTextColor?(toolbar)
        case .textBackgroundColor: toolbar.delegate?.richEditorToolbarChangeBackgroundColor?(toolbar)
        case .header(let h): toolbar.editor?.header(h)
        case .indent: toolbar.editor?.indent()
        case .outdent: toolbar.editor?.outdent()
        case .orderedList: toolbar.editor?.orderedList()
        case .unorderedList: toolbar.editor?.unorderedList()
        case .alignLeft: toolbar.editor?.alignLeft()
        case .alignCenter: toolbar.editor?.alignCenter()
        case .alignRight: toolbar.editor?.alignRight()
        case .image: toolbar.delegate?.richEditorToolbarInsertImage?(toolbar)
        case .video: toolbar.delegate?.richEditorToolbarInsertVideo?(toolbar)
        case .link: toolbar.delegate?.richEditorToolbarInsertLink?(toolbar)
        case .table: toolbar.delegate?.richEditorToolbarInsertTable?(toolbar)
        case .fontSize: toolbar.delegate?.richEditorToolbarChangeTextSize?(toolbar)
        case .separator: break
        case .done: toolbar.editor?.endEditing(true)
        case .spacer: break
        }
    }
}
