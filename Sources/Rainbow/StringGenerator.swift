//
//  File.swift
//  
//
//  Created by 宋璞 on 2023/1/14.
//


protocol StringGenerator {
    func generate(for entry: Rainbow.Entry) -> String
}


struct ConsoleStringGenerator: StringGenerator {
    
    func generate(for entry: Rainbow.Entry) -> String {
        let strings: [String] = entry.segments.map {
            var codes: [UInt8] = []
            if let color = $0.color {
                codes += color.value
            }
            if let backgroundColor = $0.backgroundColor {
                codes += backgroundColor.value
            }
            if let styles = $0.styles {
                codes += styles.flatMap { $0.value }
            }
            
            if codes.isEmpty || $0.text.isEmpty {
                return $0.text
            } else {
                return "\(ControlCode.CSI)\(codes.map{String($0)}.joined(separator: ";"))m\($0.text)\(ControlCode.CSI)0m"
            }
        }
        
        return strings.joined()
    }
}
