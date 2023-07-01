//
//  GuardHook.swift
//  Lumberjack
//
//  Created by Mitch Treece on 6/21/23.
//

import Foundation

/// A message hook that continues _or_ stops the chain
/// based on a condition.
public struct GuardHook: MessageHook {
    
    /// The condition closure.
    public typealias Condition = (Message)->Bool
    
    private let condition: Condition
    
    /// Initializes the hook with a condition.
    ///
    /// - Parameter:
    ///   - condition: The condition.
    public init(_ condition: @escaping Condition) {
        self.condition = condition
    }
    
    public func hook(_ message: Message) -> MessageHookResult {
        return self.condition(message) ? .next : .stop
    }
    
}
