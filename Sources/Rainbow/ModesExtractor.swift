//
//  File.swift
//  
//
//  Created by 宋璞 on 2023/1/14.
//

class ConsoleEntryParser {
    
    let text: String
    var iter: String.Iterator?
    
    init(text: String) {
        self.text = text
    }
    
    func parse() -> Rainbow.Entry {
        
        func appendSegment(text: String, codes: [UInt8]) {
            let modes = ConsoleCodesParse().parse(modeCodes: codes)
            segments.append(.init(text: text, color: modes.color, backgroundColor: modes.backgroundColor, styles: modes.styles))
            tempCodes = []
        }
        
        
        iter = text.makeIterator()
        var segments = [Rainbow.Segment]()
        var tempCodes = [UInt8]()
        var startingNewSegment = false
        
        while let c = iter!.next() {
            if startingNewSegment, c == ControlCode.OPEN_BRACKET {
                tempCodes = parseCodes()
                startingNewSegment = false
            } else if c == ControlCode.ESC {
                if !tempCodes.isEmpty {
                    appendSegment(text: "", codes: tempCodes)
                }
                startingNewSegment = true
            } else {
                let text = parseText(firstCharacter: c)
                appendSegment(text: text, codes: tempCodes)
                startingNewSegment = true
            }
        }
        return Rainbow.Entry(segments: segments)
    }
    
    func parseCodes() -> [UInt8] {
        var codes = [UInt8]()
        var current: String = ""
        while let c = iter!.next(), c != "m" {
            if c == ";", let code = UInt8(current) {
                codes.append(code)
                current = ""
            } else {
                current.append(c)
            }
        }
        if let code = UInt8(current) {
            codes.append(code)
        }
        return codes
    }
    
    func parseText(firstCharacter: Character) -> String {
        var text = String(firstCharacter)
        while let c = iter!.next(), c != ControlCode.ESC {
            text.append(c)
        }
        return text
    }
}
