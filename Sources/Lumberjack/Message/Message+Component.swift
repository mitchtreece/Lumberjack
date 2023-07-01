//
//  Message+Component.swift
//  Lumberjack
//
//  Created by Mitch Treece on 6/21/23.
//

import Foundation

public extension Message /* Component */ {
    
    /// Representation of the various types
    /// of message components.
    enum Component {
        
        /// Representation of the various types
        /// of message component spacings.
        public enum Spacing {
            
            /// An empty (zero) spacing.
            case none
            
            /// A leading spacing.
            case leading(Int)
            
            /// A trailing spacing.
            case trailing(Int)
            
            /// A leading & trailing spacing.
            case leadingTrailing(Int)
            
        }
              
        /// Representation of the various types
        /// of log-level message components.
        public enum LevelComponent {
            
            /// A name component.
            case name
            
            /// A symbol component.
            case symbol
            
        }
        
        /// A level component.
        ///
        /// - Parameters:
        ///   - type: The level component type.
        ///   - spacing: The component's spacing type.
        case level(_ type: LevelComponent,
                   spacing: Spacing = .none)
        
        /// A category component.
        ///
        /// - Parameters:
        ///   - spacing: The component's spacing type.
        case category(spacing: Spacing = .none)
        
        /// A timestamp component.
        ///
        /// - Parameters:
        ///   - spacing: The component's spacing type.
        case timestamp(spacing: Spacing = .none)
        
        /// A module component.
        ///
        /// - Parameters:
        ///   - spacing: The component's spacing type.
        case module(spacing: Spacing = .none)
        
        /// A file component.
        ///
        /// - Parameters:
        ///   - extension: Flag indicating if the file's extension should be included.
        ///   - spacing: The component's spacing type.
        case file(extension: Bool = false,
                  spacing: Spacing = .none)
        
        /// A function component.
        ///
        /// - Parameters:
        ///   - parameters: Flag indicating if the function's parameters should be included.
        ///   - spacing: The component's spacing type.
        case function(parameters: Bool = false,
                      spacing: Spacing = .none)
        
        /// A line-number component.
        ///
        /// - Parameters:
        ///   - spacing: The component's spacing type.
        case line(spacing: Spacing = .none)
        
        /// A message component.
        ///
        /// - Parameters:
        ///   - spacing: The component's spacing type.
        case message(spacing: Spacing = .none)
        
        /// A raw text component.
        case text(String,
                  spacing: Spacing = .none)
        
    }
    
}
