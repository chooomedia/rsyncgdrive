#
# Makefile für MySyncApp
# Build-Skripte mit Swift Package Manager (SPM)
# Funktioniert ohne Xcode - perfekt für Cursor!
#

.PHONY: help build cli test test-verbose test-filter test-coverage clean swift-build swift-test run-cli xcode info

# Build-Verzeichnis
BUILD_DIR = .build

help:
	@echo "Verfügbare Targets (SPM-basiert):"
	@echo ""
	@echo "Build:"
	@echo "  make build          - Baut alle Targets (Shared Library + CLI)"
	@echo "  make cli            - Baut nur das CLI-Tool"
	@echo "  make clean          - Bereinigt Build-Verzeichnisse"
	@echo ""
	@echo "Testing:"
	@echo "  make test           - Führt alle Tests aus"
	@echo "  make test-verbose   - Tests mit verbose Output"
	@echo "  make test-filter    - Spezifischen Test ausführen (FILTER=TestName)"
	@echo "  make test-coverage  - Tests mit Code Coverage"
	@echo ""
	@echo "Run:"
	@echo "  make run-cli        - Baut und führt CLI aus"
	@echo ""
	@echo "Tools:"
	@echo "  make xcode          - Generiert Xcode-Projekt (falls benötigt)"
	@echo "  make info           - Zeigt Package-Informationen"
	@echo "  make check-xctest   - Prüft ob XCTest verfügbar ist"
	@echo ""
	@echo "Hinweis: App und Widget benötigen Xcode für vollständige Funktionalität"
	@echo "Hinweis: Tests benötigen XCTest - siehe TESTING_SETUP.md"

build: cli
	@echo "✓ Alle SPM-Targets erfolgreich gebaut"

cli:
	@echo "Baue CLI-Tool mit Swift Package Manager..."
	@swift build --product SyncCLI
	@echo "✓ CLI erfolgreich gebaut"
	@echo "  Ausführbar: .build/debug/SyncCLI"

test:
	@echo "Führe Tests mit Swift Package Manager aus..."
	@swift test
	@echo "✓ Tests erfolgreich ausgeführt"

test-verbose:
	@echo "Führe Tests mit verbose Output aus..."
	@swift test --verbose
	@echo "✓ Tests erfolgreich ausgeführt"

test-filter:
	@echo "Führe spezifischen Test aus..."
	@swift test --filter $(FILTER)
	@echo "✓ Test ausgeführt"

test-coverage:
	@echo "Führe Tests mit Code Coverage aus..."
	@swift test --enable-code-coverage
	@echo "✓ Tests mit Coverage ausgeführt"
	@echo "  Coverage-Daten in .build/debug/CodeCoverage/"

clean:
	@echo "Bereinige Build-Verzeichnisse..."
	@swift package clean
	@rm -rf $(BUILD_DIR)
	@echo "✓ Bereinigung abgeschlossen"

run-cli: cli
	@echo "Führe CLI aus..."
	@.build/debug/SyncCLI

# Generiert Xcode-Projekt für App/Widget Entwicklung (optional)
xcode:
	@echo "Generiere Xcode-Projekt..."
	@swift package generate-xcodeproj 2>/dev/null || swift package xcode
	@echo "✓ Xcode-Projekt generiert (falls unterstützt)"

# Swift-spezifische Befehle
swift-build:
	@swift build

swift-test:
	@swift test

# Zeige Package-Informationen
info:
	@swift package describe --type json | python3 -m json.tool || swift package describe

# Prüfe ob XCTest verfügbar ist
check-xctest:
	@./scripts/check-xctest.sh

