//
//  File.swift
//  
//
//  Created by 宋璞 on 2023/1/14.
//


import Foundation


private func getEnvValue(_ key: String) -> String? {
    return ProcessInfo.processInfo.environment[key]
}

/// 输出目标
public enum OutputTarget {
    case unknown
    case console
    
    static var current: OutputTarget = {
        let termType = getEnvValue("TERM")
        if let t = termType, t.lowercased() != "dumb" && isatty(fileno(stdout)) != 0 {
            return .console
        }
        return .unknown
    }()
}
