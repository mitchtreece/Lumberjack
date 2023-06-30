//
//  Message.swift
//  Lumberjack
//
//  Created by Mitch Treece on 6/21/23.
//

import Foundation

/// An object representing a logged message.
public struct Message {
    
    /// Representation of the various message statuses.
    public enum Status: String {
        
        /// A pending message status.
        case pending
        
        /// A logged message status.
        case logged
        
        /// A supressed message status.
        case supressed
        
        /// The message status display name.
        public var name: String {
            return self.rawValue.capitalized
        }
        
    }
    
    private struct HookEntry {
        
        let name: String
        let result: MessageHookResult
        
    }
    
    /// The message's parent logger identifier.
    public let loggerId: String
    
    /// The message's components.
    public let components: [Component]
    
    /// The message's level.
    public let level: LogLevel
    
    /// The message's symbol.
    public let symbol: String
    
    /// The message's category.
    public let category: String?
    
    /// The message's module.
    public let module: String

    /// The message's line number.
    public let line: UInt
    
    /// The message's date.
    public let date: Date
    
    /// The message's date as a formatted string.
    public var dateString: String {
        
        return self.dateFormatter
            .string(from: self.date)
        
    }
    
    public internal(set) var status: Status = .pending
    
    public var isLogged: Bool {
        return (self.status == .logged)
    }
    
    /// The message's route through the log stack.
    public var route: String {
        
        var route: String = "\(self.level.name.capitalized)(logger: \(self.loggerId))"
        var status: String = self.status.name
        
        for entry in self.hooks {
            
            route += " ➜ \(entry.name)"
            
            switch entry.result {
            case .next:
                
                status = "Logged"
                
            case .stop:
                
                status = "Stopped"
                
            }
                        
        }
        
        return "\(route) ➜ \(status)"
        
    }
            
    private let body: String
    private let fileWithExtension: String
    private let functionWithParameters: String
    private let dateFormatter: DateFormatter
    private var hooks = [HookEntry]()

    internal init(_ body: String,
                  loggerId: String,
                  components: [Component],
                  level: LogLevel,
                  symbol: String,
                  category: String?,
                  module: String,
                  fileWithExtension: String,
                  functionWithParameters: String,
                  line: UInt,
                  date: Date,
                  dateFormatter: DateFormatter) {
        
        self.body = body
        self.loggerId = loggerId
        self.components = components
        self.level = level
        
        self.symbol = symbol
        self.category = category
        
        self.module = module
        self.fileWithExtension = fileWithExtension
        self.functionWithParameters = functionWithParameters
        self.line = line
        
        self.date = date
        self.dateFormatter = dateFormatter
        
    }
    
    /// The message's file.
    ///
    /// - Parameters:
    ///   - ext: Flag indicating if the file's extension should be included.
    ///
    /// - Returns: A file string with or without an extension.
    public func file(ext: Bool) -> String {
        
        guard ext else {
            
            return self.fileWithExtension
                .components(separatedBy: ".")
                .first ?? "???"
            
        }
        
        return self.fileWithExtension
        
    }
    
    /// The message's function.
    ///
    /// - Parameters:
    ///   - parameters: Flag indicating if the function's parameters should be included.
    ///
    /// - Returns: A function string with or without parameters.
    public func function(parameters: Bool) -> String {
        
        guard parameters else {
            
            return self.functionWithParameters
                .components(separatedBy: "(")
                .first ?? "???"
            
        }
        
        return self.functionWithParameters
        
    }
        
    /// The message's body.
    ///
    /// - Parameters:
    ///   - formatted: Flag indicating if the body should be returned
    ///     fully-formatted, or raw.
    ///
    /// - Returns: A raw or formatted body string.
    public func body(formatted: Bool) -> String {
        
        guard formatted else { return self.body }
        
        var formattedMessage = ""
        
        for component in self.components {
            
            switch component {
            case .level(let levelComponent, let spacing):
                
                var levelString = ""
                
                switch levelComponent {
                case .name:
                    
                    levelString += "[\(self.level.name.uppercased())]"
                    
                case .symbol:
                    
                    levelString += self.symbol
                    
                }
                
                formattedMessage += apply(
                    spacing: spacing,
                    to: levelString
                )
                

            case .category(let spacing):
                
                guard let category else { break }

                formattedMessage += apply(
                    spacing: spacing,
                    to: "<\(category)>"
                )
                
            case .timestamp(let spacing):

                formattedMessage += apply(
                    spacing: spacing,
                    to: self.dateString
                )
                
            case .module(let spacing):

                formattedMessage += apply(
                    spacing: spacing,
                    to: self.module
                )
                
            case .file(let ext, let spacing):

                formattedMessage += apply(
                    spacing: spacing,
                    to: file(ext: ext)
                )
                
            case .function(let parameters, let spacing):
                
                formattedMessage += apply(
                    spacing: spacing,
                    to: function(parameters: parameters)
                )
                
            case .line(let spacing):

                formattedMessage += apply(
                    spacing: spacing,
                    to: "\(self.line)"
                )

            case .message(let spacing):

                formattedMessage += apply(
                    spacing: spacing,
                    to: self.body
                )

            case .text(let string, let spacing):

                formattedMessage += apply(
                    spacing: spacing,
                    to: string
                )
                
            }
            
        }
        
        return formattedMessage
        
    }
    
    // MARK: Internal & Private
    
    internal mutating func append(hook: String,
                                  with result: MessageHookResult) {
        
        self.hooks.append(.init(
            name: hook,
            result: result
        ))
        
    }
    
    private func apply(spacing: Component.Spacing,
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
