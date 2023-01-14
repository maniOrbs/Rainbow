//
//  File.swift
//  
//
//  Created by 宋璞 on 2023/1/11.
//

public typealias RGB = (UInt8, UInt8, UInt8)

public enum ColorType: ModeCode {
    case named(Color)
    case bit8(UInt8)
    case bit24(RGB)
    
    @available(*, deprecated, message: "For backward compatibility.")
    var namedColor: Color? {
        switch self {
        case .named(let color): return color
        default: return nil
        }
    }
    
    public var value: [UInt8] {
        switch self {
        case .named(let color)  : return color.value
        case .bit8(let color)   : return [ControlCode.setColor, ControlCode.set8Bit, color]
        case .bit24(let rgb)    : return [ControlCode.setColor, ControlCode.set24Bit, rgb.0, rgb.1, rgb.2]
        }
    }
    
    public var toBackgroundColor: BackgroundColorType {
        switch self {
        case .named(let color)  : return .named(color.toBackgroundColor)
        case .bit8(let color)   : return .bit8(color)
        case .bit24(let rgb)    : return .bit24(rgb)
        }
    }
}

extension ColorType: Equatable {
    public static func == (lhs: ColorType, rhs: ColorType) -> Bool {
        switch (lhs, rhs) {
        case (.named(let color1), .named(let color2))   : return color1 == color2
        case (.bit8(let color1), .bit8(let color2))     : return color1 == color2
        case (.bit24(let color1), bit24(let color2))    : return color1 == color2
        default: return false
        }
    }
    
    
}

public typealias Color = NamedColor

public enum NamedColor: UInt8, ModeCode, CaseIterable {
    case black          = 30
    case red
    case green
    case yellow
    case blue
    case magenta
    case cyan
    case white
    case `default`      = 39
    case lightBlack     = 90
    case lightRed
    case lightGreen
    case lightYellow
    case lightBlue
    case lightMagenta
    case lightCyan
    case lightWhite
    
    
    public var value: [UInt8] {
        return [rawValue]
    }
    
    public var toBackgroundColor: NamedBackgroundColor {
        return NamedBackgroundColor(rawValue: rawValue + 10)!
    }
    
    
}
