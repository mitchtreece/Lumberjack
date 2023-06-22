//
//  Logger.swift
//  Lumberjack
//
//  Created by Mitch Treece on 6/21/23.
//

import Foundation

public struct Logger {
    
    public var verbosity: Verbosity?
    public var symbol: Symbol?
    public var category: String?
    public var components: Components?
    public var dateFormatter: DateFormatter?

    public init(verbosity: Verbosity? = nil,
                symbol: Symbol? = nil,
                category: String? = nil,
                components: Components? = nil,
                dateFormatter: DateFormatter? = nil) {
        
        self.verbosity = verbosity
        self.symbol = symbol
        self.category = category
        self.components = components
        self.dateFormatter = dateFormatter

    }
    
    @discardableResult
    public func log(_ message: String,
                    level: Level? = nil,
                    symbol: String? = nil,
                    category: String? = nil,
                    file: String = #fileID,
                    function: String = #function,
                    line: Int = #line) -> Message? {
                
        let _level = level ?? Lumberjack.defaultLevel
        
        guard shouldLog(_level) else { return nil }
                
        // Message
        
        let _category = category ?? self.category
        let _components = self.components ?? Lumberjack.defaultComponents
        
        var formattedMessage = ""
        
        for c in _components.components {
            
            switch c {
            case .level(let lc, let s):
                
                var string: String

                switch lc {
                case .name:

                    string = "[\(_level.name.uppercased())]"

                case .symbol:
                    
                    if let symbol {
                        string = symbol
                    }
                    else {
                        
                        let style = self.symbol ?? Lumberjack.defaultSymbol

                        switch style {
                        case .just(let s):
                            
                            string = s
                            
                        case .provider(let p):
                            
                            string = p(_level)
                            
                        }
                        
                    }
                    
                }
                
                formattedMessage += apply(
                    spacing: s,
                    to: string
                )

            case .category(let s):
                
                if let category = _category {
                    
                    formattedMessage += apply(
                        spacing: s,
                        to: "<\(category)>"
                    )
                    
                }

            case .timestamp(let s):
                
                let formatter = self.dateFormatter ?? Lumberjack.defaultDateFormatter
                
                let string = formatter
                    .string(from: Date())
                
                formattedMessage += apply(
                    spacing: s,
                    to: string
                )
                
            case .module(let s):
                
                guard let module = file
                    .components(separatedBy: "/")
                    .first else { break }

                formattedMessage += apply(
                    spacing: s,
                    to: module
                )

            case .file(let ext, let s):

                guard let fileNoModule = file
                    .components(separatedBy: "/")
                    .last else { break }
                
                guard !ext else {
                    
                    formattedMessage += apply(
                        spacing: s,
                        to: fileNoModule
                    )
                    
                    break
                    
                }
                
                guard let fileNoExtension = fileNoModule
                    .components(separatedBy: ".")
                    .first else { break }
                
                formattedMessage += apply(
                    spacing: s,
                    to: fileNoExtension
                )
                
            case .function(let params, let s):

                guard !params else {
                    
                    formattedMessage += apply(
                        spacing: s,
                        to: function
                    )
                    
                    break
                    
                }
                
                guard let functionNoParams = function
                    .components(separatedBy: "(")
                    .first else { break }
                
                formattedMessage += apply(
                    spacing: s,
                    to: functionNoParams
                )
                
            case .line(let s):
                
                formattedMessage += apply(
                    spacing: s,
                    to: "\(line)"
                )

            case .message(let s):
                
                formattedMessage += apply(
                    spacing: s,
                    to: message
                )

            case .text(let string):

                formattedMessage += string
                
            }
            
        }
        
        // Done
        
        print(formattedMessage)
        
        return Message(
            level: _level,
            category: _category,
            message: message,
            file: file,
            function: function
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
    
    // MARK: Private
    
    private func shouldLog(_ level: Level) -> Bool {
        
        let verbosity = self.verbosity ?? Lumberjack.verbosity
        
        switch verbosity {
        case .none:
            
            return false
            
        case .just(let otherLevel):
            
            return (level == otherLevel)
            
        case .upTo(let otherLevel):
            
            return (level <= otherLevel)
            
        case .full:
            
            return true
            
        }
        
    }
    
    private func apply(spacing: Components.Component.Spacing,
                       to string: String) -> String {
        
        switch spacing {
        case .none:
            
            return string
            
        case .leading(let count):
            
            var _string = ""
            
            for _ in 0..<count {
                _string += " "
            }
            
            _string += string
            
            return _string
            
        case .trailing(let count):
            
            var _string = string
            
            for _ in 0..<count {
                _string += " "
            }
            
            return _string
            
        case .leadingTrailing(let count):
            
            var _string = string
            
            _string = apply(
                spacing: .leading(count),
                to: _string
            )
            
            _string = apply(
                spacing: .trailing(count),
                to: _string
            )
            
            return _string
            
        }
        
    }
    
}
