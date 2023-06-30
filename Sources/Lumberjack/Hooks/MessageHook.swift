//
//  MessageHook.swift
//  Lumberjack
//
//  Created by Mitch Treece on 6/21/23.
//

import Foundation

public protocol MessageHook {
        
    var name: String { get }
    
    func hook(_ message: Message) -> MessageHookResult
    
}

public extension MessageHook {
    
    var name: String {
        return "\(type(of: self))"
    }
    
}
