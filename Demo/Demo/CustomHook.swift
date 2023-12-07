//
//  CustomHook.swift
//  Demo
//
//  Created by Mitch Treece on 6/29/23.
//

import Lumberjack

struct CustomHook: MessageHook {
    
    func hook(message: Message,
              from logger: Logger) -> MessageHookResult {
                
        if ((0...10).randomElement() ?? 0) == 10 {
            print("🎲 [LUCKY] Custom hook says: \"you feelin lucky punk?\" 🤠")
        }
        
        return .next
        
    }
    
}
