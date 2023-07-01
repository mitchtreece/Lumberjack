//
//  LogLevel.swift
//  Lumberjack
//
//  Created by Mitch Treece on 6/21/23.
//

import Foundation

/// Representation of the various log levels.
public enum LogLevel: Int, Identifiable, Comparable, CaseIterable {
    
    public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    /// A debug log level.
    case debug    = 0
    
    /// An info log level.
    case info     = 1
    
    /// A notice log level.
    case notice   = 2
    
    /// A warning log level.
    case warning  = 3
    
    /// An error log level.
    case error    = 4
    
    /// A fatal log level.
    case fatal    = 5
    
    /// The log level's identifier.
    public var id: Int {
        return self.rawValue
    }
    
    internal var name: String {
        
        switch self {
        case .debug:    return "debug"
        case .info:     return "info"
        case .notice:   return "notice"
        case .warning:  return "warning"
        case .error:    return "error"
        case .fatal:    return "fatal"
        }
        
    }
    
    internal var symbol: String {

        switch self {
        case .debug:   return "⚪️"
        case .info:    return "🟣"
        case .notice:  return "🟡"
        case .warning: return "🟠"
        case .error:   return "🔴"
        case .fatal:   return "⛔️"
        }
        
    }
    
    internal var systemImageName: String {
        
        switch self {
        case .debug:   return "0.circle"
        case .info:    return "1.circle"
        case .notice:  return "2.circle"
        case .warning: return "3.circle"
        case .error:   return "4.circle"
        case .fatal:   return "5.circle"
        }
        
    }
    
}
