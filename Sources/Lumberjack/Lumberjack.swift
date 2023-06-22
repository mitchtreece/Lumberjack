//
//  Lumberjack.swift
//  Lumberjack
//
//  Created by Mitch Treece on 6/21/23.
//

import Foundation

public struct Lumberjack {
    
    public static let sharedLogger = Logger()
    
    public static var verbosity: Verbosity = .full
    
    public static var defaultLevel: Level = .debug
    public static var defaultSymbol: Symbol = .default
    public static var defaultComponents: Components = .default
    public static var defaultDateFormatter = DateFormatter(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS")
        
}

@discardableResult
public func log(_ message: String,
                level: Level? = nil,
                symbol: String? = nil,
                category: String? = nil,
                file: String = #fileID,
                function: String = #function,
                line: Int = #line) -> Message? {
    
    return Lumberjack.sharedLogger.log(
        message,
        level: level,
        symbol: symbol,
        category: category,
        file: file,
        function: function,
        line: line
    )
    
}

@discardableResult
public func debug(_ message: String,
                  symbol: String? = nil,
                  category: String? = nil,
                  file: String = #fileID,
                  function: String = #function,
                  line: Int = #line) -> Message? {
    
    return log(
        message,
        level: .debug,
        symbol: symbol,
        category: category,
        file: file,
        function: function,
        line: line
    )
    
}

@discardableResult
public func info(_ message: String,
                 symbol: String? = nil,
                 category: String? = nil,
                 file: String = #fileID,
                 function: String = #function,
                 line: Int = #line) -> Message? {
    
    return log(
        message,
        level: .info,
        symbol: symbol,
        category: category,
        file: file,
        function: function,
        line: line
    )
    
}

@discardableResult
public func notice(_ message: String,
                   symbol: String? = nil,
                   category: String? = nil,
                   file: String = #fileID,
                   function: String = #function,
                   line: Int = #line) -> Message? {
    
    return log(
        message,
        level: .notice,
        symbol: symbol,
        category: category,
        file: file,
        function: function,
        line: line
    )
    
}

@discardableResult
public func warning(_ message: String,
                    symbol: String? = nil,
                    category: String? = nil,
                    file: String = #fileID,
                    function: String = #function,
                    line: Int = #line) -> Message? {
    
    return log(
        message,
        level: .warning,
        symbol: symbol,
        category: category,
        file: file,
        function: function,
        line: line
    )
    
}

@discardableResult
public func error(_ message: String,
                  symbol: String? = nil,
                  category: String? = nil,
                  file: String = #fileID,
                  function: String = #function,
                  line: Int = #line) -> Message? {
    
    return log(
        message,
        level: .error,
        symbol: symbol,
        category: category,
        file: file,
        function: function,
        line: line
    )
    
}
