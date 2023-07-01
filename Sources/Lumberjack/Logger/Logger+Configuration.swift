//
//  Logger+Configuration.swift
//  Lumberjack
//
//  Created by Mitch Treece on 6/21/23.
//

import Foundation

public extension Logger /* Configuration */ {
    
    /// An object that represents the various
    /// configurable components of a logger.
    struct Configuration {
        
        /// The logger's symbol.
        public var symbol: LogSymbol
        
        /// The logger's category.
        public var category: String?
        
        /// The logger's message components.
        public var components: MessageComponentSet

        /// The logger's timestamp format.
        public var timestampFormat: String {
            didSet {
                updateDateFormatter()
            }
        }
        
        /// The logger's hooks.
        public var hooks = [any MessageHook]()
        
        internal let dateFormatter = DateFormatter()
        
        /// Initializes a logger configuration.
        ///
        /// - Parameters:
        ///   - symbol: The logger's symbol.
        ///   - category: The logger's category.
        ///   - components: The logger's message components.
        ///   - timestampFormat: The logger's timestamp format.
        ///   - hooks: The logger's hooks.
        public init(symbol: LogSymbol = .default,
                    category: String? = nil,
                    components: MessageComponentSet = .default,
                    timestampFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSS",
                    hooks: [any MessageHook] = []) {
            
            self.symbol = symbol
            self.category = category
            self.components = components
            self.timestampFormat = timestampFormat
            self.hooks = hooks
            
            updateDateFormatter()
            
        }
        
        private func updateDateFormatter() {
            
            self.dateFormatter
                .dateFormat = self.timestampFormat
            
        }
        
    }
    
}
