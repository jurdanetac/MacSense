//
//  GameControllerManager.swift
//  MacSense
//
//  Created by Juan on 4/9/26.
//

import GameController

@Observable
class GameControllerManager {
    // Notification observers for controller connection events.
    private var observers: [NSObjectProtocol] = []
    
    init() {
        GCController.shouldMonitorBackgroundEvents = true
    }
    
    var controller: GCController?
    
    func startMonitoring() {
        // The framework posts a connection notification when a controller connects.
        let connectObserver = NotificationCenter.default.addObserver(
            forName: .GCControllerDidConnect,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let controller = notification.object as? GCController else { return }
            self?.handleControllerConnected(controller)
        }
        
        // The framework posts a disconnection notification when a controller disconnects.
        let disconnectObserver = NotificationCenter.default.addObserver(
            forName: .GCControllerDidDisconnect,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let controller = notification.object as? GCController else { return }
            self?.handleControllerDisconnected(controller)
        }
        
        observers = [connectObserver, disconnectObserver]
    }
    
    func stopMonitoring() {
        observers.forEach { NotificationCenter.default.removeObserver($0) }
        observers.removeAll()
    }
    
    func simulateLeftClick() {
        let currentLocation = CGEvent(source: nil)?.location ?? .zero
        
        // Create down and up events for a left-click at the current cursor position
        let downEvent = CGEvent(mouseEventSource: nil, mouseType: .leftMouseDown, mouseCursorPosition: currentLocation, mouseButton: .left)
        let upEvent = CGEvent(mouseEventSource: nil, mouseType: .leftMouseUp, mouseCursorPosition: currentLocation, mouseButton: .left)
        
        downEvent?.post(tap: .cghidEventTap)
        upEvent?.post(tap: .cghidEventTap)
        
        print("CGEvent posted for right-click at: \(currentLocation)")
    }
    
    private func handleControllerConnected(_ controller: GCController) {
        self.controller = controller
        
        let gamepad = controller.extendedGamepad!
        
        gamepad.buttonA.pressedChangedHandler = {(_,_,pressed) in
            if pressed {
                self.simulateLeftClick()
            }
        }
    }
    
    // if let dualSense = controller.extendedGamepad as? GCDualSenseGamepad {
    // Track primary finger coordinates
    //            dualSense.touchpadPrimary.valueChangedHandler = { (dpad, xValue, yValue) in
    //                print("Primary Touch - X: \(xValue), Y: \(yValue)")
    //            }
    
    // Handle touchpad physical click
    //            dualSense.touchpadButton.pressedChangedHandler = { (button, value, pressed) in
    //                if pressed {
    //                    print("Touchpad clicked down!")
    //                }
    //            }
    //        } else {
    //            print("Controller is not a DualSense")
    //        }}
    
    private func handleControllerDisconnected(_ controller: GCController) {
        self.controller = nil
    }
}
