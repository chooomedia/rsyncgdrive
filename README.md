# MySyncApp - Google Drive Sync Status (Multi-Platform)

Eine moderne Multi-Platform-App zur Anzeige des Google Drive Synchronisationsstatus mit rsync oder rclone.

**Supported Platforms**: macOS ✅ | iOS 🚧 | watchOS 📋 | Android 🔮 | Windows 🔮

## Features

### Aktuell (macOS MVP)
- 🎨 **SwiftUI-basierte macOS-App** mit modernem Apple Design
- 📱 **WidgetKit Extension** für macOS Widget-Bereich
- ⚙️ **Konfigurierbare Sync-Methoden** (rsync oder rclone)
- 🔄 **Echtzeit-Status-Anzeige** mit Progress-Indikatoren
- 📝 **Protokollierung** von Sync-Ereignissen
- 🧪 **CLI-Tool** zum Testen der Sync-Funktionalität
- ✅ **Unit Tests** für alle Komponenten
- 🔄 **CI/CD** mit GitHub Actions

### Geplant
- 📱 **iOS App** mit Widget Extension
- ⌚ **watchOS App** mit Complications
- 🤖 **Android App** (Kotlin/Flutter)
- 🪟 **Windows App** (Swift/C#)

## Projektstruktur

### Swift Package Manager (SPM) - Für Cursor-Entwicklung

```
MySyncApp/
├── Package.swift              # SPM Package Definition
├── Sources/
│   ├── Shared/               # Shared Library (Core-Logik)
│   │   ├── Models/           # SyncState, SyncConfig, SyncStatus
│   │   ├── Services/         # SyncManager, StorageManager
│   │   └── Utilities/       # Extensions, Helpers
│   └── CLI/                  # CLI Executable
│       └── main.swift
├── Tests/
│   ├── SharedTests/          # Tests für Shared Library
│   │   ├── Fixtures/        # Test-Daten
│   │   └── Mocks/           # Mock-Objekte
│   └── CLITests/             # Tests für CLI
└── App/ & Widget/            # Für Xcode (optional)
```

### Xcode-Projektstruktur (für App/Widget)

```
MySyncApp/
├── App/                      # macOS App Target
│   ├── ViewModels/           # MVVM ViewModels
│   ├── Views/                # SwiftUI Views
│   └── App.swift
├── Widget/                   # WidgetKit Extension
│   ├── TimelineProvider/
│   ├── Views/
│   └── Widget.swift
└── Shared/                    # Gemeinsame Logik
```

## Voraussetzungen

- macOS 13.0+ (Ventura oder höher)
- Swift 5.7+ (oder neuer)
- Xcode Command Line Tools: `xcode-select --install`
- rsync oder rclone installiert (für tatsächliche Sync-Operationen)

**Hinweis**: Für Tests wird vollständiges Xcode benötigt (siehe Testing-Sektion)

## Installation & Setup

### Option 1: Cursor-Entwicklung (SPM) - Empfohlen für Core-Logik

**Vorteile**: Schnell, Editor-unabhängig, perfekt für Shared Library Entwicklung

```bash
# 1. Projekt bauen
make build

# 2. CLI testen
make run-cli

# 3. Code entwickeln in Sources/Shared/
```

**Verfügbare Befehle**:
```bash
make build          # Baut alle SPM-Targets
make cli            # Baut nur CLI
make test           # Führt Tests aus (benötigt Xcode)
make run-cli        # Baut und führt CLI aus
make check-xctest   # Prüft XCTest-Verfügbarkeit
make clean          # Bereinigt Build-Verzeichnisse
```

### Option 2: Xcode-Entwicklung (für App/Widget)

**Für macOS App und Widget Extension:**

1. **Xcode-Projekt erstellen**:
   - Öffne Xcode → "File" → "New" → "Project"
   - Wähle "macOS" → "App"
   - Product Name: `MySyncApp`
   - Interface: SwiftUI

2. **Widget Extension hinzufügen**:
   - "+" → "Widget Extension"
   - Product Name: `SyncWidget`

3. **App Group konfigurieren** (für Widget-Kommunikation):
   - Beide Targets (App + Widget) → "Signing & Capabilities"
   - "+ Capability" → "App Groups"
   - Erstelle: `group.com.mysyncapp.shared`
   - Aktiviere in beiden Targets

4. **Dateien hinzufügen**:
   - Shared-Dateien zu allen Targets
   - App-Dateien nur zu App Target
   - Widget-Dateien nur zu Widget Target

### Build & Run

**Mit Swift Package Manager** (Cursor/CLI):
```bash
make build      # Baut alle Targets
make run-cli    # CLI ausführen
make test       # Tests ausführen (benötigt Xcode)
```

**Mit Xcode** (für App/Widget):
```bash
open Package.swift  # Öffnet in Xcode
# Oder: make xcode
```

## Verwendung

### App

1. Öffne die App
2. Gehe zu "Einstellungen"
3. Konfiguriere:
   - Sync-Methode (rsync oder rclone)
   - Quell- und Ziel-Pfade
   - Optional: Auto-Sync aktivieren
4. Speichere die Einstellungen
5. Klicke auf "Synchronisieren" um manuell zu syncen

### Widget

1. Rechtsklick auf den Desktop oder Widget-Bereich
2. Wähle "Widget bearbeiten"
3. Füge "Google Drive Sync Status" hinzu
4. Wähle die gewünschte Größe (Small, Medium, Large)

### CLI

```bash
# CLI-Tool ausführen
./build/DerivedData/Build/Products/Release/SyncCLI

# Oder direkt mit Swift
swift CLI/main.swift
```

## Entwicklung

### Entwicklungsworkflow

**Mit Cursor (SPM)**:
1. Code entwickeln in `Sources/Shared/`
2. Tests schreiben in `Tests/SharedTests/`
3. Build prüfen: `make build`
4. CLI testen: `make run-cli`
5. Tests ausführen: `make test` (wenn Xcode verfügbar)

**Mit Xcode**:
1. Öffne `Package.swift` in Xcode
2. Entwickle App/Widget in entsprechenden Ordnern
3. Tests mit `Cmd+U` ausführen

### Sync-Befehle implementieren

Die Sync-Befehle sind aktuell als Platzhalter implementiert. Um rsync/rclone zu integrieren:

1. Öffne `Sources/Shared/Services/SyncManager.swift`
2. Implementiere `runRsync()` und `runRclone()` Methoden
3. Verwende `Process` oder eine Bibliothek wie `ShellOut` für CLI-Aufrufe

**Beispiel-Struktur**:
```swift
private func runRsync(source: String, destination: String) async throws -> Bool {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/rsync")
    process.arguments = ["-av", "--delete", source, destination]
    
    // Output-Parsing für Progress-Updates
    // ...
    
    try process.run()
    process.waitUntilExit()
    return process.terminationStatus == 0
}
```

### Code-Standards

Das Projekt folgt professionellen Entwicklungsstandards:

- ✅ **MVVM Architecture** - Saubere Trennung von View und Logic
- ✅ **TDD-ready** - Test-Driven Development unterstützt
- ✅ **Swift Concurrency** - async/await für non-blocking Operations
- ✅ **SOLID Principles** - Clean Code Standards
- ✅ **Apple Design Guidelines** - Native UI/UX für alle Apple Platforms
- ✅ **Protocol-Oriented Design** - Platform-Abstraktionen durch Protocols

**Siehe**: `.cursor/rules/.cursorrules` für vollständige Code-Standards

### UI/UX Best Practices (Apple Platforms)

- ✅ **System Colors** - `.systemBlue`, `.systemGreen` für Dark Mode Support
- ✅ **SF Symbols** - Konsistente System-Icons
- ✅ **Dynamic Type** - Unterstützung aller Text-Größen
- ✅ **Accessibility** - VoiceOver, Dynamic Type, WCAG AA Kontrast
- ✅ **Adaptive Layout** - Funktioniert auf allen Gerätegrößen
- ✅ **8pt Grid** - Konsistente Abstände

**Siehe**: `.cursor/rules/apple-platforms.mdc` für vollständige Design-Guidelines

### Nächste Features

- ⏳ **rsync/rclone Integration** - Echte Sync-Befehle implementieren
- ⏳ **Auto-Sync Service** - Background-Timer für automatische Syncs
- ⏳ **Progress-Tracking** - Detaillierte Progress-Updates
- ⏳ **Error-Recovery** - Retry-Logik bei Fehlern
- ⏳ **Notifications** - Benachrichtigungen bei Sync-Abschluss

## Testing

### Test-Infrastruktur

Das Projekt verwendet **XCTest** für Unit Tests mit professionellen Standards:

- ✅ **Test-Fixtures** (`Tests/SharedTests/Fixtures/`) - Wiederverwendbare Test-Daten
- ✅ **Mock-Klassen** (`Tests/SharedTests/Mocks/`) - Isolierte Tests
- ✅ **AAA-Pattern** - Arrange-Act-Assert Struktur
- ✅ **TDD-ready** - Test-Driven Development unterstützt

### Tests ausführen

```bash
# Alle Tests
make test

# Mit Details
make test-verbose

# Spezifischer Test
make test-filter FILTER=SyncManagerTests

# Mit Code Coverage
make test-coverage

# XCTest-Verfügbarkeit prüfen
make check-xctest
```

### XCTest Setup

**Problem**: XCTest benötigt vollständiges Xcode (nicht nur Command Line Tools)

**Lösung**:
```bash
# 1. Xcode installieren (App Store)
# 2. Developer Directory setzen
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

# 3. Prüfen
make check-xctest

# 4. Tests ausführen
make test
```

**Alternative**: Code kann ohne Tests entwickelt werden, Tests später in Xcode ausführen.

### Test-Beispiele

```swift
// Einfacher Test mit AAA-Pattern
func testSyncStatusInitialization() {
    // Arrange
    let status = SyncStatus()
    
    // Act & Assert
    XCTAssertEqual(status.state, .idle)
}

// Test mit Fixtures
func testSyncConfig_isValid_withValidPaths_shouldReturnTrue() throws {
    let testDir = try TestFixtures.createTempDirectory(name: "test")
    defer { TestFixtures.cleanupTempDirectory(testDir) }
    
    let config = TestFixtures.validSyncConfig(sourcePath: testDir.path)
    XCTAssertTrue(config.isValid())
}
```

**Siehe**: `.cursor/rules/testing-standards.mdc` für vollständige Testing-Standards

## Architektur

### MVVM Pattern

- **Models**: `SyncState`, `SyncConfig`, `SyncStatus` (Platform-unabhängig)
- **Views**: SwiftUI Views (`ContentView`, `SettingsView`, etc.) - Platform-spezifisch
- **ViewModels**: `SyncViewModel` verwaltet State und Logik - Platform-spezifisch

### Layer-Struktur

```
Platform-Specific UI (SwiftUI)
        ↓
ViewModels (MVVM)
        ↓
Shared Services (SyncManager, StorageManager)
        ↓
Shared Models (SyncState, SyncConfig, SyncStatus)
```

### Shared Storage

- App und Widget teilen Daten über **App Group Storage** (`group.com.mysyncapp.shared`)
- `StorageManager` verwaltet persistente Speicherung
- JSON-basierte Serialisierung für Status und Config
- Verfügbar für alle Apple Platforms (macOS, iOS, watchOS)

### Concurrency

- `SyncManager` verwendet Swift Concurrency (async/await)
- Non-blocking UI während Sync-Operationen
- Task-Cancellation für Abbruch-Funktionalität
- Background Tasks für Auto-Sync (iOS/watchOS)

**Siehe**: `.cursor/rules/multi-platform.mdc` für detaillierte Architektur-Dokumentation

## Lizenz

Dieses Projekt ist ein MVP/Beispiel-Projekt für Entwicklungszwecke.

## Troubleshooting

### Build-Probleme

```bash
# Clean Build
make clean
swift build

# Mit Verbose-Output
swift build -v
```

### Test-Probleme

```bash
# Prüfe XCTest-Verfügbarkeit
make check-xctest

# Falls nicht verfügbar: Xcode installieren
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

### App Group Probleme (Xcode)

- **Container URL ist nil**: Prüfe ob App Group in beiden Targets aktiviert ist
- **Widget zeigt alten Status**: Widget-Timeline aktualisiert alle 15 Minuten
- **App Group nicht verfügbar**: Für Distribution im Apple Developer Portal erstellen

## Bekannte Einschränkungen

- Sync-Befehle sind aktuell simuliert (TODO: Implementierung)
- Auto-Sync muss noch implementiert werden
- Logging-UI zeigt aktuell nur Platzhalter
- Keine Authentifizierung für Google Drive (verwendet lokale Pfade)
- Tests benötigen vollständiges Xcode (nicht nur Command Line Tools)

## Roadmap

### Phase 1: macOS MVP (Aktuell) ✅

- [x] Projektstruktur erstellt
- [x] Shared Library (Models, Services)
- [x] macOS App mit SwiftUI
- [x] Widget Extension
- [x] CLI Tool
- [x] Unit Tests (Infrastruktur)
- [x] CI/CD Setup
- [ ] rsync/rclone Integration
- [ ] UI/UX Polish (Apple Design Guidelines)
- [ ] Vollständige Test-Suite

### Phase 2: iOS MVP 🚧

- [ ] iOS Target in Xcode erstellen
- [ ] iOS Views entwickeln
- [ ] iOS Widget Extension
- [ ] Background Tasks für Auto-Sync
- [ ] File Access Permissions

### Phase 3: watchOS MVP 📋

- [ ] watchOS Target erstellen
- [ ] Watch App + Complications
- [ ] Shared App Group mit iOS
- [ ] Background Refresh

### Phase 4: Android Research 🔮

- [ ] Technology Evaluation (Kotlin Multiplatform vs Flutter)
- [ ] Architecture Planning
- [ ] UI Framework Entscheidung

### Phase 5: Windows Research 🔮

- [ ] Technology Evaluation (Swift für Windows vs C#/.NET)
- [ ] Architecture Planning
- [ ] UI Framework Entscheidung

**Siehe**: `.cursor/rules/multi-platform.mdc` für detaillierte Roadmap-Strategie

## Erster Test - Quick Start

### Schritt 1: Projekt bauen

```bash
# Alle Targets bauen
make build

# Erwartetes Ergebnis: "Build complete!"
```

### Schritt 2: CLI testen

```bash
# CLI bauen und ausführen
make run-cli

# Erwartetes Verhalten:
# - Zeigt aktuelle Konfiguration
# - Zeigt aktuellen Status
# - Option zum Starten der Sync
```

### Schritt 3: Xcode öffnen (für App/Widget)

```bash
# Öffne Package.swift in Xcode
open Package.swift
```

### Schritt 4: App Group konfigurieren (Xcode)

**Wichtig**: App und Widget müssen die gleiche App Group verwenden!

1. Beide Targets (App + Widget) → **"Signing & Capabilities"**
2. **"+ Capability"** → **"App Groups"**
3. Erstelle: `group.com.mysyncapp.shared`
4. Aktiviere in beiden Targets ✅

### Schritt 5: App bauen und starten

1. In Xcode: Wähle **"My Mac"** als Destination
2. Drücke **Cmd+B** (Build)
3. Prüfe auf Fehler
4. Drücke **Cmd+R** (Run)
5. App sollte starten

### Schritt 6: Erster Test in der App

1. ✅ **App startet** - Keine Crashes
2. ✅ **UI wird angezeigt** - Navigation funktioniert
3. ✅ **Einstellungen öffnen** - Gehe zu "Einstellungen"
4. ✅ **Konfiguration setzen**:
   - Sync-Methode: rsync
   - Source-Pfad: `/tmp/test_source` (oder existierender Pfad)
   - Destination-Pfad: `/tmp/test_dest`
5. ✅ **Speichern** - Klicke "Speichern"
6. ✅ **Sync starten** - Gehe zu "Status" → "Synchronisieren"
7. ✅ **Status prüfen** - Status sollte auf "syncing" → "success" wechseln

### Schritt 7: Widget testen

1. Baue **SyncWidget** Scheme in Xcode (Cmd+B)
2. Rechtsklick auf Desktop → **"Widget bearbeiten"**
3. Füge **"Google Drive Sync Status"** hinzu
4. Widget sollte Status anzeigen

**Siehe**: `BUILD_AND_TEST.md` für detaillierte Schritt-für-Schritt Anleitung

## Weitere Ressourcen

### Dokumentation
- **README.md** - Diese Datei (Hauptdokumentation mit allen wichtigen Infos)

### Rules & Standards
- **Code-Standards**: `.cursor/rules/.cursorrules`
- **Testing-Standards**: `.cursor/rules/testing-standards.mdc`
- **Markdown-Standards**: `.cursor/rules/rules.mdc`
- **CI/CD Standards**: `.cursor/rules/ci-cd.mdc`
- **Multi-Platform**: `.cursor/rules/multi-platform.mdc`
- **Apple Platforms**: `.cursor/rules/apple-platforms.mdc`

### Tools
- **Makefile**: `make help` für alle verfügbaren Befehle
- **GitHub Actions**: `.github/workflows/` für CI/CD

