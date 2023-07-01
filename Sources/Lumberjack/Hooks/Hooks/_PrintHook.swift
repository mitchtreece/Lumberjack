//
//  _PrintHook.swift
//  Lumberjack
//
//  Created by Mitch Treece on 6/21/23.
//

import Foundation

internal struct _PrintHook: MessageHook {
    
    var name: String {
        return "Print"
    }
    
    func hook(_ message: Message) -> MessageHookResult {
        
        if shouldPrint(message) {
                     
            print(message.body(formatted: true))
            
            return .next
            
        }
        
        return .stop
        
    }
    
    private func shouldPrint(_ message: Message) -> Bool {
        
        switch Lumberjack.verbosity {
        case .none:
            
            return false
            
        case .just(let otherLevel):
            
            return (message.level == otherLevel)
            
        case .upTo(let otherLevel):
            
            return (message.level <= otherLevel)
            
        case .upFrom(let otherLevel):
            
            return (message.level >= otherLevel)
            
        case .full:
            
            return true
            
        }
        
    }
        
}
