//
//  File.swift
//  
//
//  Created by Mitch Treece on 6/29/23.
//

import Foundation

/// A set of logger message components.
public struct MessageComponentSet {
    
    /// The component set.
    public let components: [Message.Component]
    
    /// Initializes a component set with message components.
    ///
    /// - Parameters:
    ///   - components: The set of message components.
    public init(components: [Message.Component]) {
        self.components = components
    }
    
    /// Retrieves a component at a given index.
    ///
    /// - Parameters:
    ///   - index: The component's index.
    ///
    /// - Returns: A message component, or `nil` if not found.
    public func component(at index: Int) -> Message.Component? {
        
        guard index >= 0,
              index < self.components.count,
              !self.components.isEmpty else { return nil }
        
        return self.components[index]
        
    }
    
    /// A default set of message components.
    ///
    /// ```
    /// {symbol} [{level}] <{category}> {timestamp} {module}.{file}::{line} ➡️ {message}
    /// ```
    public static var `default`: Self {
        
        return .init(components: [
            
            .level(
                .symbol,
                spacing: .trailing(1)
            ),
            
            .level(
                .name,
                spacing: .trailing(1)
            ),
            
            .category(spacing: .trailing(1)),
            
            .timestamp(spacing: .trailing(1)),
            
            .module(),
            .text("."),
            .file(),
            .text("::"),
            .line(spacing: .trailing(1)),
            
            .text(Lumberjack.defaultMessageDelimiter),
            .message(spacing: .leading(1))
            
        ])
        
    }
    
    /// A default set of message components without a timestamp.
    ///
    /// ```
    /// {symbol} [{level}] <{category}> {module}.{file}::{line} ➡️ {message}
    /// ```
    public static var defaultNoTimestamp: Self {
     
        return .init(components: [
            
            .level(
                .symbol,
                spacing: .trailing(1)
            ),
            
            .level(
                .name,
                spacing: .trailing(1)
            ),
            
            .category(spacing: .trailing(1)),
                        
            .module(),
            .text("."),
            .file(),
            .text("::"),
            .line(spacing: .trailing(1)),
            
            .text(Lumberjack.defaultMessageDelimiter),
            .message(spacing: .leading(1))
            
        ])
        
    }
    
    /// A simple set of message components.
    ///
    /// ```
    /// {symbol} [{level}] <{category}> ➡️ {message}
    /// ```
    public static var simple: Self {
        
        return .init(components: [
            
            .level(
                .symbol,
                spacing: .trailing(1)
            ),
            
            .level(
                .name,
                spacing: .trailing(1)
            ),
            
            .category(spacing: .trailing(1)),
            
            .text(Lumberjack.defaultMessageDelimiter),
            .message(spacing: .leading(1))
            
        ])
        
    }
    
    /// A raw set of message components.
    ///
    /// ```
    /// {message}
    /// ```
    public static var raw: Self {
        
        return .init(components: [
            .message()
        ])
        
    }
    
}
