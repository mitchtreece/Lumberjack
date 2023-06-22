//
//  Components.swift
//  Lumberjack
//
//  Created by Mitch Treece on 6/21/23.
//

import Foundation

public struct Components {
    
    public enum Component {
        
        public enum Spacing {
            
            case none
            case leading(Int)
            case trailing(Int)
            case leadingTrailing(Int)
            
        }
                
        public enum LevelComponent {
            
            case name
            case symbol
            
        }
        
        case level(LevelComponent,
                   spacing: Spacing = .none)
        
        case category(spacing: Spacing = .none)
        case timestamp(spacing: Spacing = .none)
        case module(spacing: Spacing = .none)
        
        case file(extension: Bool = false,
                  spacing: Spacing = .none)
        
        case function(parameters: Bool = false,
                      spacing: Spacing = .none)
        
        case line(spacing: Spacing = .none)
        case message(spacing: Spacing = .none)
        
        case text(String)
        
    }
    
    public let components: [Component]
    
    public init(components: [Component]) {
        self.components = components
    }
    
    public func component(at index: Int) -> Component? {
        
        guard index >= 0,
              index < self.components.count,
              !self.components.isEmpty else { return nil }
        
        return self.components[index]
        
    }
    
    /// ```
    /// {symbol} [{level}] <{category}> {timestamp} {module}.{file}.{func} → {message}
    /// ```
    public static var `default`: Components {
        
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
            .text("."),
            .function(),
            .text("::"),
            .line(spacing: .trailing(1)),
            
            .text("→"),
            .message(spacing: .leading(1))
            
        ])
        
    }
    
    public static var defaultNoTimestamp: Components {
     
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
            .text("."),
            .function(),
            .text("::"),
            .line(spacing: .trailing(1)),
            
            .text("→"),
            .message(spacing: .leading(1))
            
        ])
        
    }
    
    public static var simple: Components {
        
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
            
            .text("→"),
            .message(spacing: .leading(1))
            
        ])
        
    }
    
    public static var raw: Components {
        
        return .init(components: [
            .message()
        ])
        
    }
    
}
