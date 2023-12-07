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
    
    func hook(message: Message,
              from logger: Logger) -> MessageHookResult {
        
        if shouldPrint(message, from: logger) {
                     
            // TODO: Migrate to OSLog, or let the user decide
            // between a logging system: print _or_ OSLog
            
            print(message.body(formatted: true))
            
            return .next
            
        }
        
        return .stop
        
    }
    
    private func shouldPrint(_ message: Message,
                             from logger: Logger) -> Bool {
        
        let verbosity = (Lumberjack.verbosityOverride != nil) ?
            Lumberjack.verbosityOverride! :
            logger.configuration.verbosity
        
        switch verbosity {
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
