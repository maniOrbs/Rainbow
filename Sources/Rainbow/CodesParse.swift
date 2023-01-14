//
//  File.swift
//  
//
//  Created by 宋璞 on 2023/1/11.
//


typealias ParseResult = (color: ColorType?, backgroundColor: BackgroundColorType?, styles: [Style]?)


struct ConsoleCodesParse {

    enum CodeResult {
        case color(ColorType)
        case backgroundColor(BackgroundColorType)
        case style(Style)
    }
    
    func parse(modeCodes codes: [UInt8]) -> ParseResult {
        var color: ColorType? = nil
        var backgroundColor: BackgroundColorType? = nil
        var styles: [Style]? = nil
        
        var iter = codes.makeIterator()
        while let code = iter.next() {
            if code == ControlCode.setColor {
                if canParseToSetBit8(iter) {
                    _ = iter.next()
                    let colorCode = iter.next()!
                    color = .bit8(colorCode)
                } else if canParseToSetBit24(iter) {
                    _ = iter.next()
                    let r = iter.next()!
                    let g = iter.next()!
                    let b = iter.next()!
                    color = .bit24((r,g,b))
                }
            } else if code == ControlCode.setBackgroundColor {
                if canParseToSetBit8(iter) {
                    _ = iter.next()
                    let colorCode = iter.next()!
                    backgroundColor = .bit8(colorCode)
                } else if canParseToSetBit24(iter) {
                    _ = iter.next()
                    let r = iter.next()!
                    let g = iter.next()!
                    let b = iter.next()!
                    backgroundColor = .bit24((r,g,b))
                }
            } else {
                switch parseOne(code) {
                case .color(let c): color = c
                case .backgroundColor(let bg): backgroundColor = bg
                case .style(let style):
                    if styles == nil {
                        styles = []
                    }
                    styles!.append(style)
                case .none: break
                }
            }
        }
        
        return (color, backgroundColor, styles)
    }
    
    func parseOne(_ code: UInt8) -> CodeResult? {
        if let c = NamedColor(rawValue: code) {
            return .color(.named(c))
        } else if let bg = NamedBackgroundColor(rawValue: code) {
            return .backgroundColor(.named(bg))
        } else if let style = Style(rawValue: code) {
            return .style(style)
        }
        return nil
    }
    
    func canParseToSetBit8(_ iter: IndexingIterator<[UInt8]>) -> Bool {
        var ownedIter = iter
        guard let controlCode = ownedIter.next(), controlCode == ControlCode.set8Bit  else {
            return false
        }
        guard let _ = ownedIter.next() else {
            return false
        }
        return true
    }
    
    
    func canParseToSetBit24(_ iter: IndexingIterator<[UInt8]>) -> Bool {
        var ownedIter = iter
        guard let controlCode = ownedIter.next(), controlCode == ControlCode.set24Bit else {
            return false
        }
        guard let _ = ownedIter.next(), let _ = ownedIter.next(), let _ = ownedIter.next() else {
            return false
        }
        return true
    }
}
