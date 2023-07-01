//
//  MessageHook.swift
//  Lumberjack
//
//  Created by Mitch Treece on 6/21/23.
//

import Foundation

/// Protocol describing the attributes of a
/// logger message hook.
public protocol MessageHook {
        
    /// The message hook's name.
    /// If not overridden, this defaults to the hook's class name.
    var name: String { get }
    
    /// Hooks a message and returns a continuation result.
    ///
    /// - Parameters:
    ///   - message: The hooked message.
    ///
    /// - Returns: A continuation result that either passes the
    /// message onto additional hooks, _or_ stops the chain and
    /// prevents the message from being logged.
    func hook(_ message: Message) -> MessageHookResult
    
}

public extension MessageHook {
    
    var name: String {
        return "\(type(of: self))"
    }
    
}
