//
//  File.swift
//  
//
//  Created by 宋璞 on 2023/1/14.
//


extension String {
    
    /// 适配 颜色 名称
    public func applyingColor(_ color: NamedColor) -> String {
        return applyingColor(.named(color))
    }
    
    /// 适配 颜色 类型
    public func applyingColor(_ color: ColorType) -> String {
        return applyingCodes(color)
    }
    
    /// 移除 颜色
    public func removingColor() -> String {
        return removing(\.color)
    }
    
    /// 适配 背景颜色 名称
    public func applyingBackgroundColor(_ color: NamedBackgroundColor) -> String {
        return applyingBackgroundColor(.named(color))
    }
    
    /// 适配 背景颜色 类型
    public func applyingBackgroundColor(_ color: BackgroundColorType) -> String {
        return applyingCodes(color)
    }
    
    /// 移除 背景颜色
    public func removingBackgroundColor() -> String {
        return removing(\.backgroundColor)
    }
    
    /// 适配 style
    public func applyingStyle(_ style: Style) -> String {
        return applyingCodes(style)
    }
    
    /// 移除 style
    public func removingStyle(_ style: Style) -> String {
        return removing(\.styles, value: style)
    }
    
    /// 移除所有 style
    public func removingAllStyles() -> String {
        return removing(\.styles)
    }
    
    /// 适配 字符串的 模式
    public func applyingCodes(_ codes: ModeCode...) -> String {
        guard Rainbow.enabled else {
            return self
        }
        
        var entry = ConsoleEntryParser(text: self).parse()
        
        let input = ConsoleCodesParse().parse(modeCodes: codes.flatMap { $0.value} )
        if entry.segments.count == 1 {
            entry.segments[0].update(with: input, overwriteColor: true)
        } else {
            entry.segments = entry.segments.map {
                var s = $0
                s.update(with: input, overwriteColor: false)
                return s
            }
        }
        
        if codes.isEmpty {
            return self
        } else {
            return Rainbow.generateString(for: entry)
        }
    }
    
    public func removing<T>(_ keyPath: WritableKeyPath<Rainbow.Segment, T?>) -> String {
        guard Rainbow.enabled else {
            return self
        }
        
        var entry = ConsoleEntryParser(text: self).parse()
        entry.segments = entry.segments.map {
            var s = $0
            s[keyPath: keyPath] = nil
            return s
        }
        return Rainbow.generateString(for: entry)
    }
    
    public func removing<E>(
        _ keyPath: WritableKeyPath<Rainbow.Segment, Array<E>?>, value: E
    ) -> String where E: Equatable {
        guard Rainbow.enabled else {
            return self
        }
        
        var entry = ConsoleEntryParser(text: self).parse()
        entry.segments = entry.segments.map {
            var s = $0
            if let v = s[keyPath: keyPath] {
                s[keyPath: keyPath] = v.filter { value != $0 }
            }
            return s
        }
        return Rainbow.generateString(for: entry)
    }
}

// MARK: - 文字颜色
extension String {
    public var black: String { return applyingColor(.black) }
    public var red: String { return applyingColor(.red) }
    public var green: String { return applyingColor(.green) }
    public var yellow: String { return applyingColor(.yellow) }
    public var blue: String { return applyingColor(.blue) }
    public var magenta: String { return applyingColor(.magenta) }
    public var cyan: String { return applyingColor(.cyan) }
    public var white: String { return applyingColor(.white) }
    
    public var lightBlack: String { return applyingColor(.lightBlack) }
    public var lightRed: String { return applyingColor(.lightRed) }
    public var lightGreen: String { return applyingColor(.lightGreen) }
    public var lightYellow: String { return applyingColor(.lightYellow) }
    public var lightBlue: String { return applyingColor(.lightBlue) }
    public var lightMagenta: String { return applyingColor(.lightMagenta) }
    public var lightCyan: String { return applyingColor(.lightCyan) }
    public var lightWhite: String { return applyingColor(.lightWhite) }
    
    /// <#Description#>
    public func bit8(_ color: UInt8) -> String { return applyingColor(.bit8(color)) }
    public func bit24(_ color: RGB) -> String { return applyingColor(.bit24(color)) }
    public func bit24(_ red: UInt8, _ green: UInt8, _ blue: UInt8) -> String { return bit24((red, green, blue)) }
    
    /// String with a Hex color applied to the background. The exact color which will be used is determined by the `target`.
    ///
    /// - Parameters:
    ///   - color: The Hex formatted color string. Hex-3 and Hex-6 are supported, with or without a leading sharp
    ///            character. For example, "#333", "#FF00FF", "a3a3a3" are valid, while "0xffffff", "#abcd", "kk00aa"
    ///            are not.
    ///   - target: The conversion target of this color. If `target` is `.bit8Approximated`, an approximated 8-bit
    ///             color to the Hex color will be used; If `.bit24`, a 24-bit color is used without approximation.
    ///             However, keep in mind that the support of 24-bit depends on the terminal and it is not widely used.
    ///             Default is `.bit8Approximated`.
    /// - Returns: The formatted string if the `color` represents a valid color. Otherwise, `self`.
    public func hex(_ color: String, to target: HexColorTarget = .bit8Approximated) -> String {
        guard let converter = ColorApproximation(color: color) else { return self }
        return applyingColor(converter.convert(to: target))
    }
    
    /// String with a Hex color applied to the background. The exact color which will be used is determined by the `target`.
    ///
    /// - Parameters:
    ///   - color: The color value in Hex format. Usually it is a hex number like `0xFF0000`. Alpha channel is not
    ///            supported, so any value out the range `0x000000 ... 0xFFFFFF` is invalid.
    ///   - target: The conversion target of this color. If `target` is `.bit8Approximated`, an approximated 8-bit
    ///             color to the Hex color will be used; If `.bit24`, a 24-bit color is used without approximation.
    ///             However, keep in mind that the support of 24-bit depends on the terminal and it is not widely used.
    ///             Default is `.bit8Approximated`.
    /// - Returns: The formatted string if the `color` represents a valid color. Otherwise, `self`.
    public func hex(_ color: UInt32, to target: HexColorTarget = .bit8Approximated) -> String {
        guard let converter = ColorApproximation(color: color) else { return self }
        return applyingColor(converter.convert(to: target))
    }
    
}

// MARK: - 背景颜色
extension String {
    public var onBlack: String { return applyingBackgroundColor(.black) }
    public var onRed: String { return applyingBackgroundColor(.red) }
    public var onGreen: String { return applyingBackgroundColor(.green) }
    public var onYellow: String { return applyingBackgroundColor(.yellow) }
    public var onBlue: String { return applyingBackgroundColor(.blue) }
    public var onMagenta: String { return applyingBackgroundColor(.magenta) }
    public var onCyan: String { return applyingBackgroundColor(.cyan) }
    public var onWhite: String { return applyingBackgroundColor(.white) }
    
    public var onLightBlack: String { return applyingBackgroundColor(.lightBlack) }
    public var onLightRed: String { return applyingBackgroundColor(.lightRed) }
    public var onLightGreen: String { return applyingBackgroundColor(.lightGreen) }
    public var onLightYellow: String { return applyingBackgroundColor(.lightYellow) }
    public var onLightBlue: String { return applyingBackgroundColor(.lightBlue) }
    public var onLightMagenta: String { return applyingBackgroundColor(.lightMagenta) }
    public var onLightCyan: String { return applyingBackgroundColor(.lightCyan) }
    public var onLightWhite: String { return applyingBackgroundColor(.lightWhite) }
    
    public func onBit8(_ color: UInt8) -> String { return applyingBackgroundColor(.bit8(color)) }
    public func onBit24(_ color: RGB) -> String { return applyingBackgroundColor(.bit24(color)) }
    public func onBit24(_ red: UInt8, _ green: UInt8, _ blue: UInt8) -> String { return onBit24((red, green, blue)) }
    
    /// String with a Hex color applied to the background. The exact color which will be used is determined by the `target`.
    ///
    /// - Parameters:
    ///   - color: The Hex formatted color string. Hex-3 and Hex-6 are supported, with or without a leading sharp
    ///            character. For example, "#333", "#FF00FF", "a3a3a3" are valid, while "0xffffff", "#abcd", "kk00aa"
    ///            are not.
    ///   - target: The conversion target of this color. If `target` is `.bit8Approximated`, an approximated 8-bit
    ///             color to the Hex color will be used; If `.bit24`, a 24-bit color is used without approximation.
    ///             However, keep in mind that the support of 24-bit depends on the terminal and it is not widely used.
    ///             Default is `.bit8Approximated`.
    /// - Returns: The formatted string if the `color` represents a valid color. Otherwise, `self`.
    public func onHex(_ color: String, to target: HexColorTarget = .bit8Approximated) -> String {
        guard let converter = ColorApproximation(color: color) else { return self }
        return applyingBackgroundColor(converter.convert(to: target))
    }
    
    /// String with a Hex color applied to the background. The exact color which will be used is determined by the `target`.
    ///
    /// - Parameters:
    ///   - color: The color value in Hex format. Usually it is a hex number like `0xFF0000`. Alpha channel is not
    ///            supported, so any value out the range `0x000000 ... 0xFFFFFF` is invalid.
    ///   - target: The conversion target of this color. If `target` is `.bit8Approximated`, an approximated 8-bit
    ///             color to the Hex color will be used; If `.bit24`, a 24-bit color is used without approximation.
    ///             However, keep in mind that the support of 24-bit depends on the terminal and it is not widely used.
    ///             Default is `.bit8Approximated`.
    /// - Returns: The formatted string if the `color` represents a valid color. Otherwise, `self`.
    public func onHex(_ color: UInt32, to target: HexColorTarget = .bit8Approximated) -> String {
        guard let converter = ColorApproximation(color: color) else { return self }
        return applyingBackgroundColor(converter.convert(to: target))
    }
}

// MARK: - 风格 Style

extension String {
    var bold        : String { return applyingStyle(.bold) }
    var dim         : String { return applyingStyle(.dim) }
    var italic      : String { return applyingStyle(.italic) }
    var underline   : String { return applyingStyle(.underline) }
    var blink       : String { return applyingStyle(.blink) }
    var swap        : String { return applyingStyle(.swap) }
}

// MARK: - Clear
extension String {
    public var clearColor: String { return removingColor() }
    public var clearBackgroundColor: String { return removingBackgroundColor() }
    public var clearStyles: String { return removingAllStyles() }
}

extension String {
    public var raw: String {
        return Rainbow.extractEntry(for: self).plainText
    }
}
