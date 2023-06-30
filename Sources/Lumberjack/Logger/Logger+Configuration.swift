//
//  Logger+Configuration.swift
//  Lumberjack
//
//  Created by Mitch Treece on 6/21/23.
//

import Foundation

public extension Logger /* Configuration */ {
    
    struct Configuration {
        
        public var symbol: LogSymbol
        public var category: String?
        public var components: MessageComponentSet

        public var timestampFormat: String {
            didSet {
                updateDateFormatter()
            }
        }
        
        public var hooks = [any MessageHook]()
        
        internal let dateFormatter = DateFormatter()
        
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
