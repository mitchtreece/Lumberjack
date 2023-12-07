//
//  Logger+Builder.swift
//  Lumberjack
//
//  Created by Mitch Treece on 6/21/23.
//

import Foundation

public extension Logger /* Builder */ {
    
    /// A transient build-object that represents the various
    /// configurable components of a logger.
    struct Builder {
        
        /// The logger's verbosity mode.
        public var verbosity: LogVerbosity?
        
        /// The logger's symbol.
        public var symbol: LogSymbol?
        
        /// The logger's category.
        public var category: String?
        
        /// The logger's message components.
        public var components: MessageComponentSet?
        
        /// The logger's timestamp format.
        public var timestampFormat: String?
        
        /// the logger's hooks.
        public var hooks: [any MessageHook]?
        
    }
    
    /// Initializes a logger with a building closure.
    ///
    /// - Parameters:
    ///   - id: The logger's identifier.
    ///   - build: The logger-building closure.
    convenience init(id: String = String(UUID().uuidString.prefix(8)),
                     _ build: (inout Builder)->()) {
        
        var builder = Builder()
        
        build(&builder)
        
        self.init(
            id: id,
            builder: builder
        )
        
    }
    
    internal convenience init(id: String,
                              builder: Builder) {
        
        let defaultConfig = Configuration()
        
        var config = Configuration()
        config.verbosity = builder.verbosity ?? defaultConfig.verbosity
        config.symbol = builder.symbol ?? defaultConfig.symbol
        config.category = builder.category ?? defaultConfig.category
        config.components = builder.components ?? defaultConfig.components
        config.timestampFormat = builder.timestampFormat ?? defaultConfig.timestampFormat
        config.hooks = builder.hooks ?? defaultConfig.hooks
        
        self.init(
            id: id,
            configuration: config
        )
        
    }
    
}
