//
//  ViewController.swift
//  Demo
//
//  Created by Mitch Treece on 6/21/23.
//

import UIKit
import Combine
import Lumberjack

class ViewController: UIViewController {
    
    @IBOutlet private weak var messageLabel: UILabel!
    
    private var logger: Logger!
    
    private var bag = [AnyCancellable]()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "🪓 Lumberjack"
        
        self.messageLabel.text = nil
        
        self.logger = Logger(configuration: .init(
            symbol: .just("😎"),
            category: "Instance",
            components: .defaultNoTimestamp
        ))
                
        Lumberjack
            .anyMessagePublisher
            .sink { [weak self] message in
                
                let status = message.status.rawValue.capitalized
                let msg = message.body(formatted: false)
                
                self?.messageLabel
                    .text = "\(status) Message:\n\"\(msg)\""
                
            }
            .store(in: &self.bag)
        
    }
    
    @IBAction private func defaultLog(_ sender: UIButton) {
        
        LOG(
            "Default logger says: \(Int.random(in: 1...10))",
            level: .allCases.randomElement()!
        )
                
    }
    
    @IBAction private func customLog(_ sender: UIButton) {
                
        LOG(
            "Custom logger says: \(Int.random(in: 1...10))",
            target: .id("custom"),
            level: .allCases.randomElement()!
        )
        
    }
    
    @IBAction private func instanceLog(_ sender: UIButton) {
        
        self.logger.log(
            "Instance logger says: \(Int.random(in: 1...10))",
            level: .allCases.randomElement()!
        )
        
    }

}
