# Aisland - macOS Menu Bar AI Assistant

A native macOS menu bar application built with Swift and SwiftUI that transforms the MacBook notch into an interactive AI assistant.

## Project Structure

```
Aisland/
├── Aisland/
│   ├── AislandApp.swift          # Main SwiftUI app entry point
│   ├── AppDelegate.swift         # NSApplicationDelegate for menu bar setup
│   ├── Info.plist                # App configuration and permissions
│   ├── Windows/
│   │   ├── AislandWindow.swift   # Custom NSPanel window
│   │   └── WindowManager.swift   # Singleton window manager
│   ├── Views/
│   │   └── ContentView.swift     # Main UI view with notch states
│   ├── Managers/
│   │   └── HoverDetector.swift   # Mouse hover detection
│   ├── Models/                   # Data models (to be added)
│   ├── Utilities/                # Helper utilities (to be added)
│   └── Resources/
│       └── Assets.xcassets/      # App icons and assets
├── AislandTests/
│   └── AislandTests.swift        # Unit tests
├── Package.swift                 # Swift Package Manager dependencies
└── Aisland.xcodeproj/           # Xcode project file
```

## Requirements

- **macOS**: 14.6 or later
- **Xcode**: 15.2 or later
- **Swift**: 5.0 or later
- **Architecture**: Universal binary (Intel + Apple Silicon)

## Configuration

### Info.plist Settings

The app is configured as a menu bar utility with the following permissions:

- **LSUIElement**: `true` - Runs as menu bar app (no dock icon)
- **NSAppleEventsUsageDescription**: For application control
- **NSCalendarsFullAccessUsageDescription**: For calendar access
- **NSCameraUsageDescription**: For visual features
- **NSMicrophoneUsageDescription**: For voice commands
- **NSBluetoothAlwaysUsageDescription**: For device connectivity

### Bundle Configuration

- **Bundle ID**: `com.aisland.macos`
- **Organization**: Aisland
- **Category**: Productivity
- **Minimum Deployment**: macOS 14.6

## Features

### Current Implementation

- ✅ Menu bar integration with status item
- ✅ Custom floating window (NSPanel)
- ✅ SwiftUI-based UI with modern design
- ✅ Window manager singleton pattern
- ✅ Hover detection system
- ✅ Notch-style collapsed/expanded states
- ✅ Smooth animations and transitions

### Planned Features

- 🔄 AI integration backend
- 🔄 Text selection detection via Accessibility API
- 🔄 Widget system framework
- 🔄 Calendar widget
- 🔄 Media player widget
- 🔄 Quick apps launcher
- 🔄 Notes widget
- 🔄 Camera mirror widget
- 🔄 Shortcuts integration
- 🔄 Bluetooth device monitor
- 🔄 Keyboard shortcuts
- 🔄 Preferences window
- 🔄 Voice command support

## Building the Project

### Prerequisites

Before building, ensure you have:
- Xcode Command Line Tools installed: `xcode-select --install`
- macOS 14.6 or later

### Using Xcode (GUI)

1. Open `Aisland.xcodeproj` in Xcode
2. Select the "Aisland" scheme
3. Build and run (⌘R)

### Using xcodebuild (Command Line)

```bash
# Navigate to project directory
cd /path/to/Aisland

# Build debug version
xcodebuild -project Aisland.xcodeproj -scheme Aisland -configuration Debug build

# Build release version
xcodebuild -project Aisland.xcodeproj -scheme Aisland -configuration Release build

# Run tests
xcodebuild test -project Aisland.xcodeproj -scheme Aisland -destination 'platform=macOS'

# Build and run
xcodebuild -project Aisland.xcodeproj -scheme Aisland -configuration Debug build && \
open build/Debug/Aisland.app
```

### Build Output Locations

- **Debug builds**: `build/Debug/Aisland.app`
- **Release builds**: `build/Release/Aisland.app`
- **Derived data**: `~/Library/Developer/Xcode/DerivedData/Aisland-*/`

### Installation

After building, you can:

1. **Run from build directory**:
   ```bash
   open build/Debug/Aisland.app
   ```

2. **Copy to Applications**:
   ```bash
   cp -r build/Release/Aisland.app /Applications/
   ```

3. **Launch at login** (optional):
   - Open System Settings > General > Login Items
   - Add Aisland.app to login items

## Architecture

### App Lifecycle

1. **AislandApp.swift**: SwiftUI app entry point
2. **AppDelegate.swift**: Sets up menu bar item and initializes managers
3. **WindowManager.shared**: Manages the main window lifecycle
4. **HoverDetector**: Monitors mouse events for text detection

### Window Management

- **AislandWindow**: Custom NSPanel with floating behavior
- **WindowManager**: Singleton controlling window visibility and positioning
- **ContentView**: SwiftUI view with collapsed/expanded states

### Design Patterns

- **Singleton**: WindowManager, HoverDetector
- **Delegation**: NSApplicationDelegate pattern
- **SwiftUI + AppKit Bridge**: NSHostingView for SwiftUI in AppKit window

## Testing

Run tests using:

```bash
# In Xcode: ⌘U
# Command line:
xcodebuild test -project Aisland.xcodeproj -scheme Aisland
```

## Development Notes

### Swift Package Manager

Dependencies are managed via `Package.swift`. To add a new package:

```swift
dependencies: [
    .package(url: "https://github.com/example/package.git", from: "1.0.0")
]
```

### Code Style

- Follow Swift API Design Guidelines
- Use `// MARK:` comments for organization
- Document public APIs with triple-slash comments (`///`)
- Keep files focused and single-purpose

## Permissions

The app requires the following permissions (configured in Info.plist):

- **Apple Events**: To control other applications
- **Calendar**: For context-aware features
- **Camera**: For visual capabilities
- **Microphone**: For voice commands
- **Bluetooth**: For device connectivity

Users will be prompted to grant these permissions on first use.

## Project Status

🚧 In Development

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed development guidelines.

Quick reference:

1. Follow the existing code structure
2. Add tests for new features
3. Update documentation for significant changes
4. Use conventional commit messages (see CONTRIBUTING.md)
5. Adhere to Code of Conduct (see CODE_OF_CONDUCT.md)

## Documentation

- **[ACTIONBOOK.md](ACTIONBOOK.md)**: Complete development roadmap with 27 tasks across 7 phases
- **[ARCHITECTURE.md](ARCHITECTURE.md)**: System design and technical architecture
- **[DESIGN.md](DESIGN.md)**: UI/UX design system and guidelines
- **[CONTRIBUTING.md](CONTRIBUTING.md)**: Development guidelines and contribution process
- **[CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)**: Community standards and expectations

## License

Copyright © 2026 Aisland. All rights reserved.

## Version History

- **1.0** - Initial project structure
  - Menu bar app setup
  - Custom window with notch states
  - Hover detection framework
  - Basic SwiftUI UI

---
Built with Claude Code
