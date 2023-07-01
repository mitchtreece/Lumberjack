//
//  LogTarget.swift
//  Lumberjack
//
//  Created by Mitch Treece on 6/21/23.
//

import Foundation

/// Representation of the various log targets.
public enum LogTarget {
    
    /// A default log target.
    case `default`
    
    /// A custom identifier-based log target.
    case id(String)
    
}
