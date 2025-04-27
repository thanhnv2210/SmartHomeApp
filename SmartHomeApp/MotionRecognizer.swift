//
//  MotionRecognizer.swift
//  SmartHomeApp
//
//  Created by Nguyen Van Thanh on 27/4/25.
//

import Foundation
import UIKit

class MotionRecognizer: UIResponder {
    var shakeHandler: (() -> Void)?

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            shakeHandler?()
        }
    }

    static func startShakeDetection(with handler: @escaping () -> Void) {
        let motionRecognizer = MotionRecognizer()
        motionRecognizer.shakeHandler = handler
        
        // Add to the current window's main view to detect shakes
        if let window = UIApplication.shared.windows.first {
            window.addGestureRecognizer(UITapGestureRecognizer(target: motionRecognizer, action: #selector(motionRecognizer.handleShake)))
        }
    }

    // A placeholder to trigger shake detection
    @objc func handleShake() {
        motionEnded(.motionShake, with: nil)
    }
}
