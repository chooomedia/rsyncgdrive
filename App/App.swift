//
//  App.swift
//  MySyncApp
//
//  Created: App Entry Point
//

import SwiftUI

@main
struct MySyncApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.automatic)
        .defaultSize(width: 800, height: 600)
        
        Settings {
            SettingsView(viewModel: SyncViewModel())
        }
    }
}

