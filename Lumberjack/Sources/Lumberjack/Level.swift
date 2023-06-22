//
//  Level.swift
//  Lumberjack
//
//  Created by Mitch Treece on 6/21/23.
//

import Foundation

public enum Level: Int, Comparable, CaseIterable {
    
    public static func < (lhs: Level, rhs: Level) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    case debug    = 0
    case info     = 1
    case notice   = 2
    case warning  = 3
    case error    = 4
    
    internal var name: String {
        
        switch self {
        case .debug:    return "debug"
        case .info:     return "info"
        case .notice:   return "notice"
        case .warning:  return "warning"
        case .error:    return "error"
        }
        
    }
    
    internal var symbol: String {

        switch self {
        case .debug:   return "⚪️"
        case .info:    return "🟣"
        case .notice:  return "🟡"
        case .warning: return "🟠"
        case .error:   return "🔴"
        }
        
    }
    
}
