# Build & Test - Schritt für Schritt

## 🚀 Schnellstart

### Schritt 1: Projekt bauen

```bash
# Alle Targets bauen
make build

# Oder direkt mit Swift
swift build
```

**Erwartetes Ergebnis**: 
```
Build complete! (X.XXs)
```

### Schritt 2: CLI testen

```bash
# CLI bauen und ausführen
make run-cli

# Oder manuell
swift build --product SyncCLI
.build/debug/SyncCLI
```

**Erwartetes Verhalten**:
- Zeigt aktuelle Konfiguration
- Zeigt aktuellen Status
- Option zum Starten der Sync

### Schritt 3: Xcode öffnen (für App/Widget)

```bash
# Öffne Package.swift in Xcode
open Package.swift

# Oder generiere Xcode-Projekt (falls nötig)
swift package generate-xcodeproj
```

## 📱 macOS App testen

### Voraussetzungen

1. ✅ Xcode installiert (für App/Widget)
2. ✅ App Group konfiguriert (siehe unten)

### App Group konfigurieren

**Wichtig**: App und Widget müssen die gleiche App Group verwenden!

1. Öffne Xcode-Projekt
2. Wähle **MySyncApp** Target
3. Gehe zu **"Signing & Capabilities"**
4. Klicke **"+ Capability"**
5. Wähle **"App Groups"**
6. Klicke **"+"** und erstelle: `group.com.mysyncapp.shared`
7. Aktiviere die Checkbox ✅
8. Wiederhole für **SyncWidget** Target

### App bauen und starten

1. In Xcode: Wähle **"My Mac"** als Destination
2. Drücke **Cmd+B** (Build)
3. Prüfe auf Fehler in Build-Log
4. Drücke **Cmd+R** (Run)
5. App sollte starten

### Erster Test in der App

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

## 📱 Widget testen

### Widget bauen

1. In Xcode: Wähle **SyncWidget** Scheme
2. Drücke **Cmd+B** (Build)
3. Prüfe auf Fehler

### Widget hinzufügen

1. Rechtsklick auf Desktop
2. Wähle **"Widget bearbeiten"**
3. Suche nach **"Google Drive Sync Status"**
4. Füge Widget hinzu (Small, Medium oder Large)
5. Widget sollte aktuellen Status anzeigen

### Widget aktualisieren testen

1. Starte Sync in der App
2. Warte auf Abschluss
3. Widget sollte Status aktualisieren (kann bis zu 15 Minuten dauern)
4. Oder: Rechtsklick auf Widget → **"Widget aktualisieren"**

## 🧪 Tests ausführen

### Voraussetzung: Xcode

Tests benötigen vollständiges Xcode (nicht nur Command Line Tools).

```bash
# Prüfe ob XCTest verfügbar ist
make check-xctest

# Falls nicht verfügbar:
# 1. Xcode installieren (App Store)
# 2. Developer Directory setzen:
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

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
```

**In Xcode**:
- Drücke **Cmd+U** um alle Tests auszuführen
- Oder klicke auf einzelne Tests

## 🔧 Troubleshooting

### Build-Fehler

```bash
# Clean Build
make clean
swift build

# Mit Verbose-Output (für Details)
swift build -v
```

### CLI funktioniert nicht

```bash
# Prüfe ob gebaut wurde
ls -la .build/debug/SyncCLI

# Falls nicht vorhanden:
make build

# Führe direkt aus
.build/debug/SyncCLI
```

### App startet nicht (Xcode)

- Prüfe Build-Logs in Xcode (Cmd+8)
- Prüfe Console für Fehler
- Prüfe ob alle Dependencies vorhanden sind
- Prüfe ob App Group konfiguriert ist

### Widget zeigt nichts

- Prüfe ob App Group in beiden Targets aktiviert ist
- Prüfe ob Widget Target gebaut wurde
- Prüfe ob Status in App gespeichert wurde
- Widget aktualisiert alle 15 Minuten (Timeline Policy)

### Tests laufen nicht

```bash
# Prüfe XCTest-Verfügbarkeit
make check-xctest

# Falls nicht verfügbar:
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

## ✅ Erfolgskriterien

### Für ersten erfolgreichen Test

- [ ] Projekt baut ohne Fehler (`make build`)
- [ ] CLI funktioniert (`make run-cli`)
- [ ] App startet in Xcode ohne Crash
- [ ] UI wird korrekt angezeigt
- [ ] Konfiguration kann gespeichert werden
- [ ] Sync-Button funktioniert (auch wenn simuliert)
- [ ] Widget zeigt Status an
- [ ] Tests laufen (wenn Xcode verfügbar)

## 📝 Nächste Schritte nach erfolgreichem Test

1. **rsync Integration** - Echte Sync-Befehle implementieren
2. **UI Polish** - Apple Design Guidelines umsetzen
3. **Error Handling** - Robuste Fehlerbehandlung
4. **Testing** - Vollständige Test-Suite
5. **iOS Vorbereitung** - iOS Target erstellen

## 🎯 Quick Reference

```bash
# Build
make build          # Baut alle Targets
make cli            # Baut nur CLI

# Test
make run-cli        # CLI ausführen
make test           # Tests ausführen (benötigt Xcode)
make check-xctest   # Prüft XCTest-Verfügbarkeit

# Clean
make clean          # Bereinigt Build-Verzeichnisse

# Hilfe
make help           # Zeigt alle verfügbaren Befehle
```

Viel Erfolg beim Testen! 🚀

