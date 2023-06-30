//
//  LogSymbol.swift
//  Lumberjack
//
//  Created by Mitch Treece on 6/21/23.
//

import Foundation

/// A closure that's provided a log level, and returns a symbol string.
public typealias LogSymbolProvider = (LogLevel)->String

/// Representation of the various log symbol types.
public enum LogSymbol {
    
    /// A static symbol type.
    case just(String)
    
    /// A dynamic (provider) symbol type.
    case provider(LogSymbolProvider)
    
    /// The default symbol type.
    public static var `default`: Self {
        return .provider { $0.symbol }
    }
    
    /// Retrieves the symbol's string representation for a given log level.
    ///
    /// - Parameters:
    ///   - level: The log level.
    ///
    /// - Returns: A symbol string.
    public func asString(for level: LogLevel) -> String {
        
        switch self {
        case .just(let str):
            
            return str
            
        case .provider(let provider):
            
            return provider(level)
            
        }
        
    }
    
}
