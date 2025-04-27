//
//  MotionRecognizer.swift
//  SmartHomeApp
//
//  Created by Nguyen Van Thanh on 27/4/25.
//

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
        
        // Use the current scene to add shake detection.
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            // Ensure we are only interacting with the first window in the scene.
            if let window = scene.windows.first {
                // Adding the motion recognizer to the window
                window.addGestureRecognizer(UITapGestureRecognizer(target: motionRecognizer, action: #selector(motionRecognizer.handleShake)))
            }
        }
    }

    @objc func handleShake() {
        motionEnded(.motionShake, with: nil)
    }
}
