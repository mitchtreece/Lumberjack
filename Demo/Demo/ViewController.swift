//
//  ViewController.swift
//  Demo
//
//  Created by Mitch Treece on 6/21/23.
//

import UIKit
import Lumberjack

class ViewController: UIViewController {
    
    private var logger: Logger!

    override func viewDidLoad() {
        
        super.viewDidLoad()
                
        self.logger = Logger(
            symbol: .just("📱"),
            category: "ViewController",
            components: .defaultNoTimestamp
        )
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(sharedLog)
        ))
        
        self.view.addGestureRecognizer(UILongPressGestureRecognizer(
            target: self,
            action: #selector(instanceLog)
        ))
        
    }
    
    @objc private func sharedLog() {
        
        log(
            "Hello, shared logger!",
            level: .allCases.randomElement()!
        )
        
    }
    
    @objc private func instanceLog() {
            
        self.logger.log(
            "Hello, instance logger!",
            level: .allCases.randomElement()!
        )
        
    }

}
