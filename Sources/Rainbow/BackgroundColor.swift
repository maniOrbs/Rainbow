//
//  File.swift
//  
//
//  Created by 宋璞 on 2023/1/11.
//

/// 背景颜色类型
public enum BackgroundColorType: ModeCode {
    case named(BackgroundColor)
    case bit8(UInt8)
    case bit24(RGB)
    
    @available(*, deprecated, message: "For backward compatibility.")
    var namedColor: BackgroundColor? {
        switch self {
        case .named(let color): return color
        default: return nil
        }
    }
    
    public var value: [UInt8] {
        switch self {
        case .named(let color)  : return color.value
        case .bit8(let color)   : return [ControlCode.setBackgroundColor, ControlCode.set8Bit, color]
        case .bit24(let rgb)    : return [ControlCode.setBackgroundColor, ControlCode.set24Bit, rgb.0, rgb.1, rgb.2]
        }
    }
    
    public var toColor: ColorType {
        switch self {
        case .named(let color)  : return .named(color.toColor)
        case .bit8(let color)   : return .bit8(color)
        case .bit24(let rgb)    : return .bit24(rgb)
        }
    }
}

extension BackgroundColorType: Equatable {
    public static func == (lhs: BackgroundColorType, rhs: BackgroundColorType) -> Bool {
        switch (lhs, rhs) {
        case (.named(let color1), .named(let color2))   : return color1 == color2
        case (.bit8(let color1), .bit8(let color2))     : return color1 == color2
        case (.bit24(let color1), .bit24(let color2))   : return color1 == color2
        default: return false
        }
    }
}


public typealias BackgroundColor = NamedBackgroundColor

public enum NamedBackgroundColor: UInt8, ModeCode, CaseIterable {
    case black          = 40
    case red
    case green
    case yellow
    case blue
    case magenta
    case cyan
    case white
    case `default`      = 49
    case lightBlack     = 100
    case lightRed
    case lightGreen
    case lightYellow
    case lightBlue
    case lightMagenta
    case lightCyan
    case lightWhite
    
    
    public var value: [UInt8] { [rawValue] }
    
    public var toColor: NamedColor { NamedColor(rawValue: rawValue - 10)! }
}
