//
//  Logger.swift
//  Lumberjack
//
//  Created by Mitch Treece on 6/21/23.
//

import Foundation

/// An object that logs messages to the console using
/// various levels, categories, & components.
public class Logger: Equatable {
    
    public static func == (lhs: Logger, rhs: Logger) -> Bool {
        return lhs.id == rhs.id
    }
    
    /// The default logger instance.
    public static var `default`: Logger {
        
        return Lumberjack
            .defaultLogger
        
    }
    
    internal static var `internal`: Logger {
        
        return Lumberjack
            .internalLogger
        
    }
    
    /// Retrieves a logger using a given identifier.
    ///
    /// - Parameters:
    ///   - id: The logger's identifier.
    ///
    /// - Returns: A logger instance, or `nil`.
    public static func with(id: String) -> Logger? {
        
        return Lumberjack
            .logger(id: id)
        
    }
    
    /// The logger's identifier.
    public let id: String
    
    /// The logger's configuration.
    public var configuration: Configuration
    
    /// Initializes a logger using an identifier & configuration.
    ///
    /// - Parameters:
    ///   - id: The logger's identifier.
    ///   - configuration: The logger's configuration.
    public init(id: String = String(UUID().uuidString.prefix(8)),
                configuration: Configuration = Configuration()) {
        
        self.id = id
        self.configuration = configuration
        
    }
    
    /// Logs a message.
    ///
    /// - Parameters:
    ///   - message: The message to log.
    ///   - level: The log-level for the message.
    ///   - symbol: An override symbol to use for the message.
    ///   - category: An override category to use for the message.
    ///   - metadata: Additional data to attach to the message.
    ///   - file: The calling function.
    ///   - function: The calling function.
    ///   - line: The calling line number.
    ///
    /// - Returns: The logged message.
    @discardableResult
    public func log(_ message: String,
                    level: LogLevel,
                    symbol: String? = nil,
                    category: String? = nil,
                    metadata: Message.Metadata? = nil,
                    file: String = #fileID,
                    function: String = #function,
                    line: UInt = #line) -> Message {
        
        // Message
                
        let defaultComponents = Lumberjack.defaultLogger.configuration.components
        let components = Lumberjack.forceDefaultComponents ? defaultComponents : self.configuration.components
        let category = category ?? self.configuration.category

        var _message = Message(
            message,
            loggerId: self.id,
            components: components.components,
            level: level,
            symbol: symbol ?? self.configuration.symbol.asString(for: level),
            category: category,
            metadata: metadata,
            file: file,
            function: function,
            line: line,
            date: Date(),
            dateFormatter: self.configuration.dateFormatter
        )
        
        _message
            .status = .logged
        
        // Hooks
        
        var hooks = self.configuration.hooks
        hooks.append(Lumberjack.printHook)
        
        for hook in hooks {
            
            let result = hook.hook(
                message: _message,
                from: self
            )
            
            _message.append(
                hook: hook.name,
                with: result
            )
            
            switch result {
            case .next: continue
            case .stop:
                
                _message
                    .status = .supressed
                
                Lumberjack
                    .publish(_message)
                
                return _message
                
            }
            
        }
        
        // Done
        
        Lumberjack
            .publish(_message)
        
        return _message
        
    }
    
    /// Proxy-logs a message produced by another logger.
    ///
    /// - Parameters:
    ///   - message: The message to log.
    ///
    /// - Returns: The logged message.
    @discardableResult
    public func proxy(_ message: Message) -> Message {
        
        return log(
            message.body(formatted: false),
            level: message.level,
            symbol: message.symbol,
            category: message.category,
            metadata: message.metadata,
            file: message.file(format: .raw),
            function: message.function(format: .raw),
            line: message.line
        )
        
    }
    
    /// Logs a trace message.
    ///
    /// - Parameters:
    ///   - message: The message to log.
    ///   - symbol: An override symbol to use for the message.
    ///   - category: An override category to use for the message.
    ///   - metadata: Additional data to attach to the message.
    ///   - file: The calling function.
    ///   - function: The calling function.
    ///   - line: The calling line number.
    ///
    /// - Returns: The logged message.
    @discardableResult
    public func trace(_ message: String,
                      symbol: String? = nil,
                      category: String? = nil,
                      metadata: Message.Metadata? = nil,
                      file: String = #fileID,
                      function: String = #function,
                      line: UInt = #line) -> Message {
        
        return log(
            message,
            level: .trace,
            symbol: symbol,
            category: category,
            metadata: metadata,
            file: file,
            function: function,
            line: line
        )
                          
    }
    
    /// Logs a debug message.
    ///
    /// - Parameters:
    ///   - message: The message to log.
    ///   - symbol: An override symbol to use for the message.
    ///   - category: An override category to use for the message.
    ///   - metadata: Additional data to attach to the message.
    ///   - file: The calling function.
    ///   - function: The calling function.
    ///   - line: The calling line number.
    ///
    /// - Returns: The logged message.
    @discardableResult
    public func debug(_ message: String,
                      symbol: String? = nil,
                      category: String? = nil,
                      metadata: Message.Metadata? = nil,
                      file: String = #fileID,
                      function: String = #function,
                      line: UInt = #line) -> Message {
        
        return log(
            message,
            level: .debug,
            symbol: symbol,
            category: category,
            metadata: metadata,
            file: file,
            function: function,
            line: line
        )
                          
    }
    
    /// Logs an info message.
    ///
    /// - Parameters:
    ///   - message: The message to log.
    ///   - symbol: An override symbol to use for the message.
    ///   - category: An override category to use for the message.
    ///   - metadata: Additional data to attach to the message.
    ///   - file: The calling function.
    ///   - function: The calling function.
    ///   - line: The calling line number.
    ///
    /// - Returns: The logged message.
    @discardableResult
    public func info(_ message: String,
                     symbol: String? = nil,
                     category: String? = nil,
                     metadata: Message.Metadata? = nil,
                     file: String = #fileID,
                     function: String = #function,
                     line: UInt = #line) -> Message {
        
        return log(
            message,
            level: .info,
            symbol: symbol,
            category: category,
            metadata: metadata,
            file: file,
            function: function,
            line: line
        )
                          
    }
    
    /// Logs a notice message.
    ///
    /// - Parameters:
    ///   - message: The message to log.
    ///   - symbol: An override symbol to use for the message.
    ///   - category: An override category to use for the message.
    ///   - metadata: Additional data to attach to the message.
    ///   - file: The calling function.
    ///   - function: The calling function.
    ///   - line: The calling line number.
    ///
    /// - Returns: The logged message.
    @discardableResult
    public func notice(_ message: String,
                       symbol: String? = nil,
                       category: String? = nil,
                       metadata: Message.Metadata? = nil,
                       file: String = #fileID,
                       function: String = #function,
                       line: UInt = #line) -> Message {
        
        return log(
            message,
            level: .notice,
            symbol: symbol,
            category: category,
            metadata: metadata,
            file: file,
            function: function,
            line: line
        )
                          
    }
    
    /// Logs a warning message.
    ///
    /// - Parameters:
    ///   - message: The message to log.
    ///   - symbol: An override symbol to use for the message.
    ///   - category: An override category to use for the message.
    ///   - metadata: Additional data to attach to the message.
    ///   - file: The calling function.
    ///   - function: The calling function.
    ///   - line: The calling line number.
    ///
    /// - Returns: The logged message.
    @discardableResult
    public func warning(_ message: String,
                        symbol: String? = nil,
                        category: String? = nil,
                        metadata: Message.Metadata? = nil,
                        file: String = #fileID,
                        function: String = #function,
                        line: UInt = #line) -> Message {
        
        return log(
            message,
            level: .warning,
            symbol: symbol,
            category: category,
            metadata: metadata,
            file: file,
            function: function,
            line: line
        )
                          
    }
    
    /// Logs an error message.
    ///
    /// - Parameters:
    ///   - message: The message to log.
    ///   - symbol: An override symbol to use for the message.
    ///   - category: An override category to use for the message.
    ///   - metadata: Additional data to attach to the message.
    ///   - file: The calling function.
    ///   - function: The calling function.
    ///   - line: The calling line number.
    ///
    /// - Returns: The logged message.
    @discardableResult
    public func error(_ message: String,
                      symbol: String? = nil,
                      category: String? = nil,
                      metadata: Message.Metadata? = nil,
                      file: String = #fileID,
                      function: String = #function,
                      line: UInt = #line) -> Message {
        
        return log(
            message,
            level: .error,
            symbol: symbol,
            category: category,
            metadata: metadata,
            file: file,
            function: function,
            line: line
        )
                          
    }
    
    /// Logs a fatal message & stops execution.
    ///
    /// - Parameters:
    ///   - message: The message to log.
    ///   - symbol: An override symbol to use for the message.
    ///   - category: An override category to use for the message.
    ///   - metadata: Additional data to attach to the message.
    ///   - file: The calling function.
    ///   - function: The calling function.
    ///   - line: The calling line number.
    public func fatal(_ message: String,
                      symbol: String? = nil,
                      category: String? = nil,
                      metadata: Message.Metadata? = nil,
                      file: String = #fileID,
                      function: String = #function,
                      line: UInt = #line,
                      abort: Bool = true) {
        
        log(
            message,
            level: .fatal,
            symbol: symbol,
            category: category,
            metadata: metadata,
            file: file,
            function: function,
            line: line
        )
        
        fatalError(message)
        
    }
    
}
