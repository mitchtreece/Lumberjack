//
//  MessageHookResult.swift
//  Lumberjack
//
//  Created by Mitch Treece on 6/21/23.
//

import Foundation

/// Representation of the various message hook
/// continuation result types.
public enum MessageHookResult {
    
    /// A continuation result type that
    /// passes the message to downstream hooks.
    case next
    
    /// A continuation result type that stops
    /// the chain, and prevents the message
    /// from being logged.
    case stop
    
}
