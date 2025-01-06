//
//  FontConvertible.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/6/25.
//


import UIKit.UIFont

public struct FontConvertible {
    public let name: String
    public let family: String
    public let path: String

    public typealias Font = UIFont

    public func font(size: CGFloat) -> Font {
        guard let font = UIFont(font: self, size: size) else {
            fatalError("Unable to initialize font '\(name)' (\(family))")
        }
        return font
    }

    public func register() {
        guard let url = url else { return }
        CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    }

    fileprivate var url: URL? {
        return Bundle.main.url(forResource: path, withExtension: nil)
    }
}

public extension FontConvertible.Font {
    convenience init?(font: FontConvertible, size: CGFloat) {
        if !UIFont.fontNames(forFamilyName: font.family).contains(font.name) {
            font.register()
        }

        self.init(name: font.name, size: size)
    }
}
