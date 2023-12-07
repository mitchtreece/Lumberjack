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
    
    /// A trace log level.
    case trace    = 1
    
    /// An info log level.
    case info     = 2
    
    /// A notice log level.
    case notice   = 3
    
    /// A warning log level.
    case warning  = 4
    
    /// An error log level.
    case error    = 5
    
    /// A fatal log level.
    case fatal    = 6
    
    /// The log level's identifier.
    public var id: Int {
        return self.rawValue
    }
    
    internal var name: String {
        
        switch self {
        case .debug:    return "debug"
        case .trace:    return "trace"
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
        case .trace:   return "🟤"
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
        case .trace:   return "1.circle"
        case .info:    return "2.circle"
        case .notice:  return "3.circle"
        case .warning: return "4.circle"
        case .error:   return "5.circle"
        case .fatal:   return "6.circle"
        }
        
    }
    
}
