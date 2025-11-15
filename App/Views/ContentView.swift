//
//  ContentView.swift
//  MySyncApp
//
//  Created: App Views
//

import SwiftUI

/// Hauptansicht der App
public struct ContentView: View {
    @StateObject private var viewModel = SyncViewModel()
    @State private var selectedView: AppView = .status
    
    public init() {}
    
    enum AppView: String, CaseIterable {
        case status = "status"
        case settings = "settings"
        case logs = "logs"
    }
    
    public var body: some View {
        NavigationSplitView {
            List(AppView.allCases, id: \.self, selection: $selectedView) { view in
                NavigationLink(value: view) {
                    Label(view.displayName, systemImage: view.iconName)
                }
            }
            .navigationTitle("MySyncApp")
        } detail: {
            Group {
                switch selectedView {
                case .status:
                    MainStatusView(viewModel: viewModel)
                case .settings:
                    SettingsView(viewModel: viewModel)
                case .logs:
                    LogsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(minWidth: 600, minHeight: 400)
    }
}

extension ContentView.AppView {
    var displayName: String {
        switch self {
        case .status:
            return "Status"
        case .settings:
            return "Einstellungen"
        case .logs:
            return "Protokolle"
        }
    }
    
    var iconName: String {
        switch self {
        case .status:
            return "circle.fill"
        case .settings:
            return "gearshape"
        case .logs:
            return "doc.text"
        }
    }
}

/// Hauptstatus-Ansicht
struct MainStatusView: View {
    @ObservedObject var viewModel: SyncViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            // Status Icon
            StatusIconView(state: viewModel.syncStatus.state, size: 60)
            
            // Status Text
            Text(statusText)
                .font(.title2)
                .foregroundColor(.secondary)
            
            // Last Sync Info
            if let lastSync = viewModel.syncStatus.lastSyncDate {
                Text("Letzte Synchronisation: \(lastSync.formattedForDisplay())")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Progress Ring (wenn syncing)
            if viewModel.syncStatus.state == .syncing,
               let progress = viewModel.syncStatus.progress {
                ProgressView(value: progress)
                    .progressViewStyle(.circular)
                    .frame(width: 60, height: 60)
            }
            
            // Error Message
            if let errorMessage = viewModel.syncStatus.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
            }
            
            // Sync Button
            HStack(spacing: 20) {
                if viewModel.isSyncing {
                    Button("Abbrechen") {
                        viewModel.stopSync()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                } else {
                    Button("Synchronisieren") {
                        viewModel.startSync()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!viewModel.syncConfig.isValid())
                }
                
                Button("Aktualisieren") {
                    viewModel.refreshStatus()
                }
                .buttonStyle(.bordered)
            }
            .padding(.top, 20)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var statusText: String {
        switch viewModel.syncStatus.state {
        case .idle:
            return "Bereit"
        case .syncing:
            return "Synchronisiere..."
        case .success:
            return "Erfolgreich synchronisiert"
        case .error:
            return "Fehler aufgetreten"
        }
    }
}

/// Einstellungsansicht
struct SettingsView: View {
    @ObservedObject var viewModel: SyncViewModel
    
    var body: some View {
        Form {
            Section("Synchronisations-Methode") {
                Picker("Methode", selection: $viewModel.syncConfig.syncMethod) {
                    ForEach(SyncMethod.allCases, id: \.self) { method in
                        Text(method.displayName).tag(method)
                    }
                }
            }
            
            Section("Pfade") {
                TextField("Quell-Pfad", text: $viewModel.syncConfig.sourcePath)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Ziel-Pfad", text: $viewModel.syncConfig.destinationPath)
                    .textFieldStyle(.roundedBorder)
            }
            
            Section("Auto-Sync") {
                Toggle("Auto-Sync aktivieren", isOn: $viewModel.syncConfig.autoSyncEnabled)
                
                if viewModel.syncConfig.autoSyncEnabled {
                    Stepper(
                        "Intervall: \(viewModel.syncConfig.autoSyncIntervalMinutes) Minuten",
                        value: $viewModel.syncConfig.autoSyncIntervalMinutes,
                        in: 1...1440
                    )
                }
            }
            
            Section {
                Button("Speichern") {
                    viewModel.saveConfig()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .formStyle(.grouped)
        .padding()
    }
}

/// Protokoll-Ansicht (Placeholder)
struct LogsView: View {
    var body: some View {
        VStack {
            Text("Protokolle")
                .font(.title)
            Text("Hier werden Sync-Protokolle angezeigt")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
}

