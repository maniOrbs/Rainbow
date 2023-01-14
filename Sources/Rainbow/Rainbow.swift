import Foundation

/// 协议
public protocol ModeCode {
    var value: [UInt8] { get }
}

/// Rainbow
public enum Rainbow {
    
    /// 分割
    public struct Segment {
        public var text: String
        public var color: ColorType?
        public var backgroundColor: BackgroundColorType?
        public var styles: [Style]?
        
        public init(text: String, color: ColorType? = nil, backgroundColor: BackgroundColorType? = nil, styles: [Style]? = nil) {
            self.text = text
            self.color = color
            self.backgroundColor = backgroundColor
            self.styles = styles
        }
        
        /// 简洁？？
        public var isPlain: Bool {
            return color == nil && backgroundColor == nil && (styles == nil || styles!.isEmpty || styles == [.default])
        }
        
        /// 更新
        mutating func update(with input: ParseResult, overwriteColor: Bool) {
            if isPlain {
                styles = nil
            }
            
            if let color = input.color, (self.color == nil || overwriteColor) {
                self.color = color
            }
            if let backgroundColor = input.backgroundColor, (self.backgroundColor == nil || overwriteColor) {
                self.backgroundColor = backgroundColor
            }
            
            var styles = self.styles ?? []
            if let s = input.styles {
                styles += s
            }
            self.styles = styles
        }
    }
    
    public struct Entry {
        
        public var segments: [Segment]
        
        public init(segments: [Segment]) {
            self.segments = segments
        }
        
        public var plainText: String {
            return segments.reduce("") { $0 + $1.text }
        }
        
        public var isPlain: Bool {
            return segments.allSatisfy { $0.isPlain }
        }
    }
    
    public static var outputTarget = OutputTarget.current
    
    public static var enabled = ProcessInfo.processInfo.environment["NO_COLOR"] == nil
    
    public static func extractEntry(for string: String) -> Entry {
        return ConsoleEntryParser(text: string).parse()
    }
    
    @available(* , deprecated, message: "Use the `Entry` version `extractEntry(for:)` instead")
    public static func extractModes(for string: String) -> (color: Color?, backgroundColor: BackgroundColor?, styles: [Style]?, text: String) {
        let entry = ConsoleEntryParser(text: string).parse()
        if let segment = entry.segments.first {
            return (segment.color?.namedColor, segment.backgroundColor?.namedColor, segment.styles, segment.text)
        } else {
            return (nil, nil, nil, "")
        }
    }
    
    public static func generateString(for entry: Entry) -> String {
        guard enabled else {
            return entry.plainText
        }
        
        switch outputTarget {
        case .unknown:
            return entry.plainText
        case .console:
            return ConsoleStringGenerator().generate(for: entry)
        }
    }
}
