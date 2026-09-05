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
        let controller: GCController? = controllerManager.controller;
        
        VStack {
            if let c = controller {
                Text(c.vendorName!)
            } else {
                Text("No controller connected")
                    .foregroundColor(.secondary)
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
