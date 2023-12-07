//
//  Message.swift
//  Lumberjack
//
//  Created by Mitch Treece on 6/21/23.
//

import Foundation

/// An object representing a message.
public struct Message {
    
    /// Type representing a collection of metadata
    /// associated with a message.
    typealias Metadata = [String: CustomStringConvertible]
    
    /// Representation of the various message 
    /// file format types.
    public enum FileFormat {
        
        /// A raw (unformatted) file format.
        case raw
        
        /// A file format with an extension.
        case withExtension
        
        /// A file format without an extension.
        case withoutExtenion
        
    }
    
    /// Representation of the various message
    /// function format types.
    public enum FunctionFormat {
        
        /// A raw (unformatted) function format.
        case raw
        
        /// A function format with parameters.
        case withParameters
        
        /// A function format without parameters.
        case withoutParameters
        
    }
    
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
    
    /// The message's identifier.
    public let id: String = UUID().uuidString
    
    /// The message's source logger identifier.
    public let loggerId: String
    
    /// The message's components.
    public let components: [Component]
    
    /// The message's level.
    public let level: LogLevel
    
    /// The message's symbol.
    public let symbol: String
    
    /// The message's category.
    public let category: String?
    
    /// The message's line number.
    public let line: UInt
    
    /// The message's date.
    public let date: Date
    
    /// The message's module.
    public var module: String {
        
        return self.file
            .components(separatedBy: "/")
            .first ?? "???"
        
    }
    
    /// The message's date as a formatted string.
    public var dateString: String {
        
        return self.dateFormatter
            .string(from: self.date)
        
    }
    
    /// The message's status.
    public internal(set) var status: Status = .pending
    
    /// Flag indicating if the message was logged to the console.
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
    private let file: String
    private let function: String
    private let dateFormatter: DateFormatter
    private var hooks = [HookEntry]()
    
    internal init(_ body: String,
                  loggerId: String,
                  components: [Component],
                  level: LogLevel,
                  symbol: String,
                  category: String?,
                  file: String,
                  function: String,
                  line: UInt,
                  date: Date,
                  dateFormatter: DateFormatter) {
        
        self.body = body
        self.loggerId = loggerId
        self.components = components
        self.level = level
        
        self.symbol = symbol
        self.category = category
        
        self.file = file
        self.function = function
        self.line = line
        
        self.date = date
        self.dateFormatter = dateFormatter
        
    }
    
    /// The message's file.
    ///
    /// - Parameters:
    ///   - format: The desired file format.
    ///
    /// - Returns: A file string with a given format.
    public func file(format: FileFormat) -> String {
        
        let fileWithExtension = self.file
            .components(separatedBy: "/")
            .last ?? "???"
        
        switch format {
        case .raw: return 
            
            self.file
            
        case .withExtension:

            return fileWithExtension
            
        case .withoutExtenion:
            
            return fileWithExtension
                .components(separatedBy: ".")
                .first ?? "???"
            
        }
        
    }
    
    /// The message's function.
    ///
    /// - Parameters:
    ///   - format: The desired function format.
    ///
    /// - Returns: A function string with a given format.
    public func function(format: FunctionFormat) -> String {
        
        switch format {
        case .raw,
             .withParameters:
            
            return self.function
            
        case .withoutParameters:
            
            return self.function
                .components(separatedBy: "(")
                .first ?? "???"
            
        }
        
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
                    to: file(format: ext ? .withExtension : .withoutExtenion)
                )
                
            case .function(let parameters, let spacing):
                
                formattedMessage += apply(
                    spacing: spacing,
                    to: function(format: parameters ? .withParameters : .withoutParameters)
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
