#!/bin/bash
#
# Prüft ob XCTest verfügbar ist
#

echo "🔍 Prüfe XCTest-Verfügbarkeit..."
echo ""

# Prüfe Xcode Command Line Tools
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode Command Line Tools nicht gefunden"
    echo "   Installiere mit: xcode-select --install"
    exit 1
fi

echo "✅ Xcode Command Line Tools gefunden"

# Prüfe Developer Directory
DEV_DIR=$(xcode-select -p)
echo "📁 Developer Directory: $DEV_DIR"

# Prüfe XCTest Framework
XCTEST_PATH=$(find "$DEV_DIR" -name "XCTest.framework" 2>/dev/null | head -1)
if [ -z "$XCTEST_PATH" ]; then
    echo "❌ XCTest.framework nicht gefunden"
    exit 1
fi

echo "✅ XCTest.framework gefunden: $XCTEST_PATH"

# Prüfe Swift-Version
SWIFT_VERSION=$(swift --version | head -1)
echo "🔧 $SWIFT_VERSION"

# Test ob XCTest importiert werden kann
echo ""
echo "🧪 Teste XCTest-Import..."
swift -c "import XCTest; print(\"✅ XCTest kann importiert werden\")" 2>&1

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Alles bereit für Tests!"
    echo "   Führe aus: make test"
    exit 0
else
    echo ""
    echo "❌ XCTest kann nicht importiert werden"
    echo "   Versuche: xcode-select --switch /Applications/Xcode.app/Contents/Developer"
    exit 1
fi

