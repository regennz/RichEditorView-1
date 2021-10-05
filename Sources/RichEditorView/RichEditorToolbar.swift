//
//  RichEditorToolbar.swift
//
//  Created by Caesar Wirth on 4/2/15.
//  Copyright (c) 2015 Caesar Wirth. All rights reserved.
//
import UIKit

/// RichEditorToolbarDelegate is a protocol for the RichEditorToolbar.
/// Used to receive actions that need extra work to perform (eg. display some UI)
@objc public protocol RichEditorToolbarDelegate: AnyObject {

    /// Called when the Text Color toolbar item is pressed.
    @objc optional func richEditorToolbarChangeTextColor(_ toolbar: RichEditorToolbar)

    /// Called when the Background Color toolbar item is pressed.
    @objc optional func richEditorToolbarChangeBackgroundColor(_ toolbar: RichEditorToolbar)

    /// Called when the Insert Image toolbar item is pressed.
    @objc optional func richEditorToolbarInsertImage(_ toolbar: RichEditorToolbar)

    /// Called when the Insert Video toolbar item is pressed
    @objc optional func richEditorToolbarInsertVideo(_ toolbar: RichEditorToolbar)

    /// Called when the Insert Link toolbar item is pressed.
    @objc optional func richEditorToolbarInsertLink(_ toolbar: RichEditorToolbar)
    
    /// Called when the Insert Table toolbar item is pressed
    @objc optional func richEditorToolbarInsertTable(_ toolbar: RichEditorToolbar)
    
    /// Called when the Text Size toolbar item is pressed.
    @objc optional func richEditorToolbarChangeTextSize(_ toolbar: RichEditorToolbar)
}

/// RichBarButtonItem is a subclass of UIBarButtonItem that takes a callback as opposed to the target-action pattern
@objcMembers open class RichBarButtonItem: UIBarButtonItem {
    private var font: UIFont? = nil
    
    open var actionHandler: (() -> Void)?
    
    open var activeColor: UIColor = .systemBlue
    open var normalColor: UIColor = .black
    
    open var type: String = ""
    
    open var active: Bool = false {
        didSet {
            tintColor = active ? activeColor : normalColor
        }
    }
    
    open override var tintColor: UIColor? {
        didSet {
            if let color = tintColor, let font = font {
                setTitleTextAttributes([
                    NSAttributedString.Key.font : font,
                    NSAttributedString.Key.foregroundColor: color
                ], for: .normal)
            }
        }
    }
    
    public convenience init(type: String, image: UIImage? = nil, activeColor: UIColor = .systemBlue, normalColor: UIColor = .black, handler: (() -> Void)? = nil) {
        self.init(image: image?.withRenderingMode(.alwaysTemplate), style: .plain, target: nil, action: nil)
        target = self
        action = #selector(RichBarButtonItem.buttonWasTapped)
        actionHandler = handler
        self.type = type
        self.activeColor = activeColor
        self.normalColor = normalColor
    }
    
    public convenience init(type: String, title: String = "", font: UIFont? = nil, activeColor: UIColor = .systemBlue, normalColor: UIColor = .black, handler: (() -> Void)? = nil) {
        self.init(title: title, style: .plain, target: nil, action: nil)
        self.font = font
        if let font = font {
            setTitleTextAttributes([
                NSAttributedString.Key.font : font,
                NSAttributedString.Key.foregroundColor: UIColor.black
            ], for: .normal)
        }
        target = self
        action = #selector(RichBarButtonItem.buttonWasTapped)
        actionHandler = handler
        self.type = type
        self.activeColor = activeColor
        self.normalColor = normalColor
    }
    
    @objc func buttonWasTapped() {
        actionHandler?()
    }
}

/// RichEditorToolbar is UIView that contains the toolbar for actions that can be performed on a RichEditorView
@objcMembers open class RichEditorToolbar: UIView {

    /// The delegate to receive events that cannot be automatically completed
    open weak var delegate: RichEditorToolbarDelegate?

    /// A reference to the RichEditorView that it should be performing actions on
    open weak var editor: RichEditorView?

    /// The list of options to be displayed on the toolbar
    open var options: [RichEditorOption] = [] {
        didSet {
            updateToolbar()
        }
    }

    /// The tint color to apply to the toolbar background.
    open var barTintColor: UIColor? {
        get { return backgroundToolbar.barTintColor }
        set { backgroundToolbar.barTintColor = newValue }
    }
    
    /// The color for option active
    open var activeColor: UIColor = .systemBlue
    /// The color for option inactive
    open var normalColor: UIColor = .black
    
    open var items: [UIBarButtonItem]? {
        return toolbar.items
    }
    
    open var font: UIFont? = nil
    open var isFontIcon: Bool = false

    private var toolbarScroll: UIScrollView
    private var toolbar: UIToolbar
    private var backgroundToolbar: UIToolbar
    
    public override init(frame: CGRect) {
        toolbarScroll = UIScrollView()
        toolbar = UIToolbar()
        backgroundToolbar = UIToolbar()
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        toolbarScroll = UIScrollView()
        toolbar = UIToolbar()
        backgroundToolbar = UIToolbar()
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        autoresizingMask = .flexibleWidth
        backgroundColor = .clear

        backgroundToolbar.frame = bounds
        backgroundToolbar.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        toolbar.autoresizingMask = .flexibleWidth
        toolbar.backgroundColor = .clear
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)

        toolbarScroll.frame = bounds
        toolbarScroll.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        toolbarScroll.showsHorizontalScrollIndicator = false
        toolbarScroll.showsVerticalScrollIndicator = false
        toolbarScroll.backgroundColor = .clear

        toolbarScroll.addSubview(toolbar)

        addSubview(backgroundToolbar)
        addSubview(toolbarScroll)
        updateToolbar()
    }
    
    private func updateToolbar() {
        var buttons = [UIBarButtonItem]()
        for option in options {
            let handler = { [weak self] in
                if let strongSelf = self {
                    option.action(strongSelf)
                }
            }
            
            if isFontIcon {
                let button = RichBarButtonItem(type: option.type, title: option.fontIcon, font: font, activeColor: activeColor, normalColor: normalColor, handler: handler)
                buttons.append(button)
            } else {
                if let image = option.image {
                    let button = RichBarButtonItem(type: option.type, image: image, activeColor: activeColor, normalColor: normalColor, handler: handler)
                    buttons.append(button)
                } else {
                    let title = option.title
                    let button = RichBarButtonItem(type: option.type, title: title, activeColor: activeColor, normalColor: normalColor, handler: handler)
                    buttons.append(button)
                }
            }
        }
        toolbar.items = buttons

        let defaultIconWidth: CGFloat = 28
        let barButtonItemMargin: CGFloat = 12
        let width: CGFloat = buttons.reduce(0) {sofar, new in
            if let view = new.value(forKey: "view") as? UIView {
                return sofar + view.frame.size.width + barButtonItemMargin
            } else {
                return sofar + (defaultIconWidth + barButtonItemMargin)
            }
        }
        
        if width < frame.size.width {
            toolbar.frame.size.width = frame.size.width + barButtonItemMargin
        } else {
            toolbar.frame.size.width = width + barButtonItemMargin
        }
        toolbar.frame.size.height = 44
        toolbarScroll.contentSize.width = width
    }
    
}
