//
//  Lumberjack.swift
//  Lumberjack
//
//  Created by Mitch Treece on 6/21/23.
//

import Foundation
import Combine

fileprivate struct LoggerKey {
    
    static let `default`: String = "_default"
    static let `internal`: String = "_lumberjack"
    
    static let reservedKeys: [String] = [
        Self.default,
        Self.internal
    ]
    
}

/// Lightweight Swift logging library 🪵🪓
public struct Lumberjack {
    
    /// The global logging verbosity mode.
    /// If this is set, all loggers will use this
    /// verbosity, instead of the one's set in their
    /// configurations.
    public static var verbosityOverride: LogVerbosity?
    
    /// Flag indicating if all loggers should be forced to use
    /// default components.
    public static var forceDefaultComponents: Bool = false
    
    /// The default logging message delimiter.
    ///
    /// This is the symbol (or string) that separates info
    /// components from the actual message. i.e. "➡️" or "➜".
    ///
    /// When using a custom component setup, this delimiter
    /// is ignored.
    public static var defaultMessageDelimiter: String = "➡️"
    
    /// The default logger instance.
    ///
    /// This can be customized by accessing & adjusting
    /// properties on the logger's configuration object.
    public static var defaultLogger: Logger {
        return logger(id: LoggerKey.default)!
    }
        
    /// A publisher that sends only logged messages.
    public static var loggedMessagePublisher: AnyPublisher<Message, Never> {
        
        return self.message
            .filter { $0.isLogged }
            .eraseToAnyPublisher()
        
    }
    
    /// A publisher that sends _any_ (logged _or_ supressed) messages.
    public static var anyMessagePublisher: AnyPublisher<Message, Never> {
        
        return self.message
            .eraseToAnyPublisher()
        
    }
    
    private static var registry: [Logger] = [
        
        Logger(id: LoggerKey.default),
        
        Logger(id: LoggerKey.internal, configuration: .init(
            symbol: .just("🪓"),
            category: "Lumberjack",
            components: .simple
        ))
        
    ]
    
    internal static var internalLogger: Logger {
        return logger(id: LoggerKey.internal)!
    }
    
    private static var message = PassthroughSubject<Message, Never>()
    
    internal static let printHook = _PrintHook()
    
    /// Registers a logger.
    ///
    /// - Parameters:
    ///   - logger: The logger to register.
    public static func register(_ logger: Logger) {
        
        let loggerId = logger.id
        
        guard !LoggerKey.reservedKeys.contains(loggerId) else {
            
            self.internalLogger.warning(
                "reserved identifier \"\(loggerId)\" cannot be used to register a custom logger"
            )
            
            return
            
        }
        
        if let idx = self.registry.firstIndex(of: logger) {
            
            self.registry
                .remove(at: idx)
            
            self.registry.insert(
                logger,
                at: idx
            )
            
        }
        else {
            
            self.registry
                .append(logger)
            
        }
        
    }

    /// Builds and registers a logger using a given identifier.
    ///
    /// - Parameters:
    ///   - id: The logger's identifier.
    ///   - build: The logger-building closure.
    ///
    /// - Returns: A new logger instance.
    @discardableResult
    public static func buildAndRegister(loggerWithId id: String,
                                        build: (inout Logger.Builder)->()) -> Logger {
                
        guard !LoggerKey.reservedKeys.contains(id) else {
            
            self.internalLogger.warning(
                "reserved identifier \"\(id)\" cannot be used to register a custom logger"
            )
            
            return .default
            
        }
        
        return _buildAndRegister(
            loggerWithId: id,
            build: build
        )
        
    }
    
    /// Unregisters a logger with a specific identifier.
    ///
    /// - Parameters:
    ///   - id: The logger's identifier.
    public static func unregister(loggerWithId id: String) {
        
        guard let idx = self.registry
            .firstIndex(where: { $0.id == id }) else { return }
        
        self.registry
            .remove(at: idx)
        
    }
    
    /// Retrieves a logger with a specific identifier.
    ///
    /// - Parameters:
    ///   - id: The logger's identifier.
    ///
    /// - Returns: A logger instance, or `nil`.
    public static func logger(id: String) -> Logger? {
        
        return self.registry
            .first(where: { $0.id == id })
                
    }
    
    // MARK: Private
    
    internal static func publish(_ message: Message) {
        
        self.message
            .send(message)
        
    }
    
    @discardableResult
    private static func _buildAndRegister(loggerWithId id: String,
                                          build: (inout Logger.Builder)->()) -> Logger {
        
        var builder = Logger.Builder()
        build(&builder)
        
        let logger = Logger(
            id: id,
            builder: builder
        )
        
        self.registry
            .append(logger)
        
        return logger
        
    }
    
}

/// Logs a message.
///
/// - Parameters:
///   - message: The message to log.
///   - target: The target to send the message to.
///   - level: The log-level for the message.
///   - symbol: An override symbol to use for the message.
///   - category: An override category to use for the message.
///   - file: The calling function.
///   - function: The calling function.
///   - line: The calling line number.
///
/// - Returns: The logged message, or `nil` if the target is invalid.
@discardableResult
public func LOG(_ message: String,
                target: LogTarget = .default,
                level: LogLevel,
                symbol: String? = nil,
                category: String? = nil,
                file: String = #fileID,
                function: String = #function,
                line: UInt = #line) -> Message? {
    
    var logger: Logger?
    
    switch target {
    case .default:
        
        logger = Lumberjack
            .defaultLogger
        
    case .id(let id):
        
        logger = Lumberjack
            .logger(id: id)
        
    }
    
    return logger?.log(
        message,
        level: level,
        symbol: symbol,
        category: category,
        file: file,
        function: function,
        line: line
    )
    
}

/// Proxy-logs a message produced by another logger.
///
/// - Parameters:
///   - message: The message to log.
///   - target: The target to send the message to.
///
/// - Returns: The logged message, or `nil` if the target is invalid.
@discardableResult
public func PROXY(_ message: Message,
                  target: LogTarget = .default) -> Message? {
    
    var logger: Logger?
    
    switch target {
    case .default:
        
        logger = Lumberjack
            .defaultLogger
        
    case .id(let id):
        
        logger = Lumberjack
            .logger(id: id)
        
    }
    
    return logger?
        .proxy(message)
    
}

/// Logs a trace message.
///
/// - Parameters:
///   - message: The message to log.
///   - target: The target to send the message to.
///   - symbol: An override symbol to use for the message.
///   - category: An override category to use for the message.
///   - file: The calling function.
///   - function: The calling function.
///   - line: The calling line number.
///
/// - Returns: The logged message, or `nil` if the target is invalid.
@discardableResult
public func TRACE(_ message: String,
                  target: LogTarget = .default,
                  symbol: String? = nil,
                  category: String? = nil,
                  file: String = #fileID,
                  function: String = #function,
                  line: UInt = #line) -> Message? {
    
    return LOG(
        message,
        target: target,
        level: .trace,
        symbol: symbol,
        category: category,
        file: file,
        function: function,
        line: line
    )
    
}

/// Logs a debug message.
///
/// - Parameters:
///   - message: The message to log.
///   - target: The target to send the message to.
///   - symbol: An override symbol to use for the message.
///   - category: An override category to use for the message.
///   - file: The calling function.
///   - function: The calling function.
///   - line: The calling line number.
///
/// - Returns: The logged message, or `nil` if the target is invalid.
@discardableResult
public func DEBUG(_ message: String,
                  target: LogTarget = .default,
                  symbol: String? = nil,
                  category: String? = nil,
                  file: String = #fileID,
                  function: String = #function,
                  line: UInt = #line) -> Message? {
    
    return LOG(
        message,
        target: target,
        level: .debug,
        symbol: symbol,
        category: category,
        file: file,
        function: function,
        line: line
    )
    
}

/// Logs an info message.
///
/// - Parameters:
///   - message: The message to log.
///   - target: The target to send the message to.
///   - symbol: An override symbol to use for the message.
///   - category: An override category to use for the message.
///   - file: The calling function.
///   - function: The calling function.
///   - line: The calling line number.
///
/// - Returns: The logged message, or `nil` if the target is invalid.
@discardableResult
public func INFO(_ message: String,
                 target: LogTarget = .default,
                 symbol: String? = nil,
                 category: String? = nil,
                 file: String = #fileID,
                 function: String = #function,
                 line: UInt = #line) -> Message? {
    
    return LOG(
        message,
        target: target,
        level: .info,
        symbol: symbol,
        category: category,
        file: file,
        function: function,
        line: line
    )
    
}

/// Logs a notice message.
///
/// - Parameters:
///   - message: The message to log.
///   - target: The target to send the message to.
///   - symbol: An override symbol to use for the message.
///   - category: An override category to use for the message.
///   - file: The calling function.
///   - function: The calling function.
///   - line: The calling line number.
///
/// - Returns: The logged message, or `nil` if the target is invalid.
@discardableResult
public func NOTICE(_ message: String,
                   target: LogTarget = .default,
                   symbol: String? = nil,
                   category: String? = nil,
                   file: String = #fileID,
                   function: String = #function,
                   line: UInt = #line) -> Message? {
    
    return LOG(
        message,
        target: target,
        level: .notice,
        symbol: symbol,
        category: category,
        file: file,
        function: function,
        line: line
    )
    
}

/// Logs a warning message.
///
/// - Parameters:
///   - message: The message to log.
///   - target: The target to send the message to.
///   - symbol: An override symbol to use for the message.
///   - category: An override category to use for the message.
///   - file: The calling function.
///   - function: The calling function.
///   - line: The calling line number.
///
/// - Returns: The logged message, or `nil` if the target is invalid.
@discardableResult
public func WARN(_ message: String,
                 target: LogTarget = .default,
                 symbol: String? = nil,
                 category: String? = nil,
                 file: String = #fileID,
                 function: String = #function,
                 line: UInt = #line) -> Message? {
    
    return LOG(
        message,
        target: target,
        level: .warning,
        symbol: symbol,
        category: category,
        file: file,
        function: function,
        line: line
    )
    
}

/// Logs an error message.
///
/// - Parameters:
///   - message: The message to log.
///   - target: The target to send the message to.
///   - symbol: An override symbol to use for the message.
///   - category: An override category to use for the message.
///   - file: The calling function.
///   - function: The calling function.
///   - line: The calling line number.
///
/// - Returns: The logged message, or `nil` if the target is invalid.
@discardableResult
public func ERROR(_ message: String,
                  target: LogTarget = .default,
                  symbol: String? = nil,
                  category: String? = nil,
                  file: String = #fileID,
                  function: String = #function,
                  line: UInt = #line) -> Message? {
    
    return LOG(
        message,
        target: target,
        level: .error,
        symbol: symbol,
        category: category,
        file: file,
        function: function,
        line: line
    )
    
}

/// Logs a fatal message & stops execution.
///
/// - Parameters:
///   - message: The message to log.
///   - target: The target to send the message to.
///   - symbol: An override symbol to use for the message.
///   - category: An override category to use for the message.
///   - file: The calling function.
///   - function: The calling function.
///   - line: The calling line number.
public func FATAL(_ message: String,
                  target: LogTarget = .default,
                  symbol: String? = nil,
                  category: String? = nil,
                  file: String = #fileID,
                  function: String = #function,
                  line: UInt = #line,
                  abort: Bool = true) {
    
    LOG(
        message,
        target: target,
        level: .fatal,
        symbol: symbol,
        category: category,
        file: file,
        function: function,
        line: line
    )
    
    fatalError(message)
    
}
