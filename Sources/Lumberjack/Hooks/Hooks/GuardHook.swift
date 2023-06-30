//
//  GuardHook.swift
//  Lumberjack
//
//  Created by Mitch Treece on 6/21/23.
//

import Foundation

public struct GuardHook: MessageHook {
    
    public typealias Condition = (Message)->Bool
    
    private let condition: Condition
    
    public init(_ condition: @escaping Condition) {
        self.condition = condition
    }
    
    public func hook(_ message: Message) -> MessageHookResult {
        return self.condition(message) ? .next : .stop
    }
    
}
