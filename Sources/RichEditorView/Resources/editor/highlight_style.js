/**
 * Copyright (C) 2021 Hung
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
"use strict";

var HS = {};

HS.editorStyle = window.getComputedStyle(RE.editor);

HS.defaultColor = 'rgb(0, 0, 0)';
HS.defaultAColor = 'rgba(0, 0, 0, 0)';
HS.defaultFontSize = HS.editorStyle.fontSize;

HS.getSelectedStyles = function () {
    let userStyle = {
        lv: 0,
        format: {
            isBold: false,
            isItalic: false,
            isUnderline: false,
            isStrikethrough: false,
            isSubscript: false,
            isSuperscript: false,
            isJustifyLeft: false,
            isJustifyCenter: false,
            isJustifyRight: false,
            isHeading1: false,
            isHeading2: false,
            isHeading3: false,
            isHeading4: false,
            isHeading5: false,
            isHeading6: false,
            isOrderedList: false,
            isUnorderedList: false,
            isLink: false,
        },
        textInfo: {
            isColorChange: false,
            textColor: null,
            firstColor: null,
            isBgColorChange: false,
            backgroundColor: null,
            firstBgColor: null,
            isSizeChange: false,
            fontSize: null,
            firstSize: null
        }
    }
    let node = HS.getSelectedNode();
    HS.getStyleOfNode(node, userStyle, true);
    return userStyle;
}

HS.getStyleOfNode = function (element, userStyle, isSingle) {
    let style = window.getComputedStyle(element);
    if (style) {
        let format = userStyle.format;
        HS.getTextFormat(userStyle, format, style, element);

        let info = userStyle.textInfo;
        if (element.id === 'editor') {
            HS.getTextInfo(userStyle, info, style, isSingle);
            return;
        }
        while (element.id !== 'editor') {
            HS.getTextInfo(userStyle, info, style, isSingle);

            element = element.parentElement;
            style = window.getComputedStyle(element);
        }
        userStyle.lv += 1;
    }
}

HS.getTextFormat = function (userStyle, format, style, element) {
    format.isBold = userStyle.lv > 0 && !format.isBold ? format.isBold : ['700', 'bold'].includes(style.fontWeight) && !['H1', 'H2', 'H3', 'H4', 'H5', 'H6'].includes(element.tagName);
    format.isItalic = userStyle.lv > 0 && !format.isItalic ? format.isItalic : style.fontStyle === 'italic';
    format.isUnderline = userStyle.lv > 0 && !format.isUnderline ? format.isUnderline : style.textDecorationLine === 'underline';
    format.isStrikethrough = userStyle.lv > 0 && !format.isStrikethrough ? format.isStrikethrough : style.textDecorationLine === 'line-through';
    format.isSubscript = userStyle.lv > 0 && !format.isSubscript ? format.isSubscript : element.tagName === 'SUB';
    format.isSuperscript = userStyle.lv > 0 && !format.isSuperscript ? format.isSuperscript : element.tagName === 'SUP';
    format.isJustifyLeft = userStyle.lv > 0 && !format.isJustifyLeft ? format.isJustifyLeft : (style.textAlign === 'start' || style.textAlign === 'left');
    format.isJustifyCenter = userStyle.lv > 0 && !format.isJustifyCenter ? format.isJustifyCenter : style.textAlign === 'center';
    format.isJustifyRight = userStyle.lv > 0 && !format.isJustifyRight ? format.isJustifyRight : (style.textAlign === 'end' || style.textAlign === 'right');
    format.isHeading1 = userStyle.lv > 0 && !format.isHeading1 ? format.isHeading1 : element.tagName === 'H1';
    format.isHeading2 = userStyle.lv > 0 && !format.isHeading2 ? format.isHeading2 : element.tagName === 'H2';
    format.isHeading3 = format.lv > 0 && !format.isHeading3 ? format.isHeading3 : element.tagName === 'H3';
    format.isHeading4 = userStyle.lv > 0 && !format.isHeading4 ? format.isHeading4 : element.tagName === 'H4';
    format.isHeading5 = userStyle.lv > 0 && !format.isHeading5 ? format.isHeading5 : element.tagName === 'H5';
    format.isHeading6 = userStyle.lv > 0 && !format.isHeading6 ? format.isHeading6 : element.tagName === 'H6';
    format.isOrderedList = userStyle.lv > 0 && !format.isOrderedList ? format.isOrderedList : element.parentElement.tagName === 'OL';
    format.isUnorderedList = userStyle.lv > 0 && !format.isUnorderedList ? format.isUnorderedList : element.parentElement.tagName === 'UL';
    format.isLink = userStyle.lv > 0 && !format.isLink ? format.isLink : element.href !== undefined;
}

HS.getTextInfo = function (userStyle, info, style, isSingle) {
    if (userStyle.lv === 0 && info.textColor === null) {
        info.textColor = HS.rgba2hex(style.color);
        info.isColorChange = ![HS.editorStyle.color, HS.defaultColor, HS.defaultAColor].includes(style.color);
        info.firstColor = info.textColor;
    } else if (!info.isColorChange) {
        info.isColorChange = ![HS.editorStyle.color, HS.defaultColor, HS.defaultAColor].includes(style.color);
        if (!info.isColorChange || isSingle) {
            info.textColor = HS.rgba2hex(style.color);
        }
    } else if (userStyle.lv > 0 && info.isColorChange) {
        info.textColor = info.firstColor;
    }

    if (userStyle.lv === 0 && info.backgroundColor === null) {
        info.backgroundColor = HS.rgba2hex(style.backgroundColor);
        info.isBgColorChange = ![HS.editorStyle.backgroundColor, HS.defaultColor, HS.defaultAColor].includes(style.backgroundColor);
        info.firstBgColor = info.backgroundColor;
    } else if (!info.isBgColorChange) {
        info.isBgColorChange = ![HS.editorStyle.backgroundColor, HS.defaultColor, HS.defaultAColor].includes(style.backgroundColor);
        if (!info.isBgColorChange || isSingle) {
            info.backgroundColor = HS.rgba2hex(style.backgroundColor);
        }
    } else if (userStyle.lv > 0 && info.isBgColorChange) {
        info.backgroundColor = info.firstBgColor;
    }

    if (userStyle.lv === 0 && info.fontSize === null) {
        info.fontSize = style.fontSize;
        info.isSizeChange = style.fontSize !== HS.defaultFontSize;
        info.firstSize = info.fontSize;
    } else if (!info.isSizeChange) {
        info.isSizeChange = style.fontSize !== HS.defaultFontSize;
        if (!info.isSizeChange || isSingle) {
            info.fontSize = style.fontSize;
        }
    } else if (userStyle.lv > 0 && info.isSizeChange) {
        info.fontSize = info.firstSize;
    }
}

HS.getSelectedNode = function () {
    var parent = null,
        sel;

    if (window.getSelection) {
        sel = window.getSelection()
        if (sel.rangeCount) {
            parent = sel.getRangeAt(0).commonAncestorContainer
            if (parent.nodeType != 1) {
                parent = parent.parentNode
            }
        }
    } else if ((sel = document.selection) && sel.type != "Control") {
        parent = sel.createRange().parentElement()
    }

    return parent
}

HS.rgba2hex = function (orig) {
    var a,
        rgb = orig.replace(/\s/g, '').match(/^rgba?\((\d+),(\d+),(\d+),?([^,\s)]+)?/i),
        alpha = (rgb && rgb[4] || "").trim(),
        hex = rgb ?
            (rgb[1] | 1 << 8).toString(16).slice(1) +
            (rgb[2] | 1 << 8).toString(16).slice(1) +
            (rgb[3] | 1 << 8).toString(16).slice(1) : orig;
    if (alpha !== "") {
        a = alpha;
    } else {
        a = 8;
    }

    a = Math.round(a * 100) / 100;
    alpha = Math.round(a * 255);
    var hexAlpha = (alpha + 0x10000).toString(16).substr(-2).toUpperCase();
    hex = hex + hexAlpha;

    return "#" + hex;
}
