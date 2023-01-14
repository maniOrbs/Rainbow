//
//  File.swift
//  
//
//  Created by 宋璞 on 2023/1/11.
//

enum ControlCode {
    static let ESC: Character = "\u{001B}"
    static let OPEN_BRACKET: Character = "["
    static let CSI = "\(ESC)\(OPEN_BRACKET)"
    
    static let setColor: UInt8 = 38
    static let setBackgroundColor: UInt8 = 48
    
    static let set8Bit: UInt8 = 5
    static let set24Bit: UInt8 = 2
}
