//
//  RichTextEditor.swift
//  ExampleRichEditorView-SwiftUI
//
//  Created by Hung on 29/09/2021.
//

import RichEditorView
import SwiftUI

@available(iOS 13.0, *)
public struct RichTextEditor: View {
    public struct Representable: UIViewRepresentable {
        public final class Coordinator: NSObject, RichEditorDelegate, RichEditorToolbarDelegate {
            private var parent: Representable
            
            public init(_ parent: Representable) {
                self.parent = parent
            }
            
            public func richEditorTookFocus(_ editor: RichEditorView) {
                parent.isEditing = true
            }

            public func richEditorLostFocus(_ editor: RichEditorView) {
                parent.isEditing = false
            }

            public func richEditor(_ editor: RichEditorView, contentDidChange content: String) {
                parent.text = content
            }
            
            public func richEditor(_ editor: RichEditorView, heightDidChange height: Int) {
                parent.height = CGFloat(height)
            }
            
            fileprivate func randomColor() -> UIColor {
                let colors: [UIColor] = [
                    .red,
                    .orange,
                    .yellow,
                    .green,
                    .blue,
                    .purple
                ]
                
                let color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
                return color
            }

            public func richEditorToolbarChangeTextColor(_ toolbar: RichEditorToolbar) {
                let color = randomColor()
                toolbar.editor?.setTextColor(color)
            }
            
            public func richEditorToolbarChangeTextSize(_ toolbar: RichEditorToolbar) {
                toolbar.editor?.setFontSize(40)
            }
        }
        
        @Binding private var text: String
        @Binding private var isEditing: Bool
        @Binding private var height: CGFloat
        
        private let textHorizontalPadding: CGFloat
        private let textVerticalPadding: CGFloat
        private let placeholder: String
        private let font: UIFont
        private let backgroundColor: UIColor
        private let keyboardDismissMode: UIScrollView.KeyboardDismissMode
        private let isScrollingEnabled: Bool
        private let isUserInteractionEnabled: Bool
        private let shouldChange: ShouldChangeHandler?
        
        public init(
            text: Binding<String>,
            isEditing: Binding<Bool>,
            height: Binding<CGFloat>,
            textHorizontalPadding: CGFloat,
            textVerticalPadding: CGFloat,
            placeholder: String,
            font: UIFont,
            backgroundColor: UIColor,
            keyboardDismissMode: UIScrollView.KeyboardDismissMode,
            isScrollingEnabled: Bool,
            isUserInteractionEnabled: Bool,
            shouldChange: ShouldChangeHandler? = nil
        ) {
            _text = text
            _isEditing = isEditing
            _height = height
            
            self.textHorizontalPadding = textHorizontalPadding
            self.textVerticalPadding = textVerticalPadding
            self.placeholder = placeholder
            self.font = font
            self.backgroundColor = backgroundColor
            self.keyboardDismissMode = keyboardDismissMode
            self.isScrollingEnabled = isScrollingEnabled
            self.isUserInteractionEnabled = isUserInteractionEnabled
            self.shouldChange = shouldChange
        }
        
        public func makeCoordinator() -> Coordinator {
            .init(self)
        }
        
        public func makeUIView(context: Context) -> RichEditorView {
            let editor = RichEditorView(frame: .zero)
            editor.delegate = context.coordinator
            
            editor.webView.isOpaque = false
            editor.setFontFamily(font.familyName)
            
            let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
            toolbar.options = RichEditorDefaultOption.all
            toolbar.editor = editor
            toolbar.delegate = context.coordinator

            editor.inputAccessoryView = toolbar
            return editor
        }
        
        public func updateUIView(_ editor: RichEditorView, context _: Context) {
            editor.placeholder = placeholder
            editor.html = text
            editor.webView.backgroundColor = backgroundColor
            editor.backgroundColor = backgroundColor
            editor.keyboardDismissMode = keyboardDismissMode
            editor.isScrollEnabled = isScrollingEnabled
            editor.isUserInteractionEnabled = isUserInteractionEnabled
            
            editor.textContainerInset = .init(
                top: textVerticalPadding,
                left: textHorizontalPadding,
                bottom: textVerticalPadding,
                right: textHorizontalPadding
            )
            
            DispatchQueue.main.async {
                _ = self.isEditing
                    ? editor.becomeFirstResponder()
                    : editor.resignFirstResponder()
            }
        }
    }
    
    public typealias ShouldChangeHandler = (NSRange, String) -> Bool
    
    public static let defaultFont = UIFont.preferredFont(forTextStyle: .body)
    
    @Binding private var text: String
    @Binding private var isEditing: Bool
    @State private var height: CGFloat = 0
    
    private let textHorizontalPadding: CGFloat
    private let textVerticalPadding: CGFloat
    private let placeholder: String
    private let font: UIFont
    private let textColor: UIColor
    private let placeholderColor: Color
    private let backgroundColor: UIColor
    private let keyboardDismissMode: UIScrollView.KeyboardDismissMode
    private let isScrollingEnabled: Bool
    private let isUserInteractionEnabled: Bool
    private let shouldChange: ShouldChangeHandler?
    
    public init(
        text: Binding<String>,
        isEditing: Binding<Bool>,
        textHorizontalPadding: CGFloat = 0,
        textVerticalPadding: CGFloat = 0,
        placeholder: String = "",
        font: UIFont = Self.defaultFont,
        textColor: UIColor = .label,
        placeholderColor: Color = .init(.placeholderText),
        backgroundColor: UIColor = .clear,
        keyboardDismissMode: UIScrollView.KeyboardDismissMode = .none,
        isScrollingEnabled: Bool = true,
        isUserInteractionEnabled: Bool = true,
        shouldChange: ShouldChangeHandler? = nil
    ) {
        _text = text
        _isEditing = isEditing
        
        self.textHorizontalPadding = textHorizontalPadding
        self.textVerticalPadding = textVerticalPadding
        self.placeholder = placeholder
        self.font = font
        self.textColor = textColor
        self.placeholderColor = placeholderColor
        self.backgroundColor = backgroundColor
        self.keyboardDismissMode = keyboardDismissMode
        self.isScrollingEnabled = isScrollingEnabled
        self.isUserInteractionEnabled = isUserInteractionEnabled
        self.shouldChange = shouldChange
    }
    
    private var representable: Representable {
        .init(
            text: $text,
            isEditing: $isEditing,
            height: $height,
            textHorizontalPadding: textHorizontalPadding,
            textVerticalPadding: textVerticalPadding,
            placeholder: placeholder,
            font: font,
            backgroundColor: backgroundColor,
            keyboardDismissMode: keyboardDismissMode,
            isScrollingEnabled: isScrollingEnabled,
            isUserInteractionEnabled: isUserInteractionEnabled,
            shouldChange: shouldChange
        )
    }
    
    public var body: some View {
        representable
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: height)
    }
}
