//
//  File.swift
//  
//
//  Created by Mitch Treece on 12/7/23.
//

import Foundation

/// Representation of the various logger verbosity modes.
public enum LogVerbosity {
    
    /// An empty (none) verbosity mode.
    case none
    
    /// A verbosity mode over a single log level.
    case just(LogLevel)
    
    /// A verbosity mode up-to (and including) a log level.
    ///
    /// ```
    /// .upTo(.notice) == [.trace, .debug, .info, .notice]
    /// ```
    case upTo(LogLevel)
    
    /// A verbosity mode up-from (and including) a log level.
    /// ```
    /// .upFrom(.warning) == [.warning, .error]
    /// ```
    case upFrom(LogLevel)
    
    /// A full verbosity mode.
    case full
    
}
