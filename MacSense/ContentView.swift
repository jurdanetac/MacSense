//
//  ContentView.swift
//  MacSense
//
//  Created by Juan on 31/8/26.
//

import SwiftUI
import GameController

struct ContentView: View {
    @State private var controllerManager = GameControllerManager()
    
    var body: some View {
        let controllers = controllerManager.connectedControllers;
        
        VStack {
            if controllers.isEmpty {
                Text("No controllers connected")
                    .foregroundColor(.secondary)
            } else {
                ForEach(controllers, id: \.self) { gc in
                    Text(gc.vendorName!)
                }
            }
        }
        .padding()
        .onAppear {
            controllerManager.startMonitoring();
        }
    }
}

#Preview {
    ContentView()
}
