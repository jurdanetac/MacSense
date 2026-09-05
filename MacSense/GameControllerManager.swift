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
    
    // The connected controllers, if any.
    var connectedControllers: [GCController] = []

    func startMonitoring() {
        // Get the controllers that were connected before the app launched.
        connectedControllers = GCController.controllers()
        
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
    
    private func handleControllerConnected(_ controller: GCController) {
        connectedControllers.append(controller)
    }
    
    private func handleControllerDisconnected(_ controller: GCController) {
        connectedControllers.removeAll { $0 == controller }
    }
}
