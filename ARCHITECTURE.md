# Aisland Architecture

## Overview

Aisland is a macOS menu bar utility that transforms the MacBook notch area into an interactive widget dashboard. The architecture follows a hybrid AppKit + SwiftUI approach, leveraging AppKit for precise window management and SwiftUI for modern, declarative UI.

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        AislandApp                           │
│                     (SwiftUI Entry)                         │
└────────────────────────────┬────────────────────────────────┘
                             │
                ┌────────────┴────────────┐
                │                         │
        ┌───────▼────────┐       ┌───────▼────────┐
        │  AppDelegate   │       │  Settings Scene │
        │  (AppKit)      │       │   (SwiftUI)     │
        └───────┬────────┘       └─────────────────┘
                │
    ┌───────────┼───────────┐
    │           │           │
┌───▼───┐  ┌───▼───┐  ┌────▼────┐
│ Menu  │  │Window │  │ Hover   │
│ Bar   │  │Manager│  │Detector │
└───────┘  └───┬───┘  └────┬────┘
               │           │
          ┌────▼───────────▼────┐
          │   AislandWindow     │
          │    (NSPanel)        │
          └──────────┬──────────┘
                     │
          ┌──────────▼──────────┐
          │   ContentView       │
          │   (SwiftUI)         │
          └──────────┬──────────┘
                     │
         ┌───────────┴───────────┐
         │                       │
    ┌────▼────┐           ┌──────▼──────┐
    │ Notch   │           │  Expanded   │
    │  View   │           │    View     │
    └─────────┘           └──────┬──────┘
                                 │
                          ┌──────▼──────┐
                          │ Widget Grid │
                          │   (7 types) │
                          └─────────────┘
```

## Core Components

### 1. Application Entry (AislandApp.swift)

**Responsibility**: SwiftUI app lifecycle management

**Key Features**:
- Uses `@NSApplicationDelegateAdaptor` to bridge SwiftUI and AppKit
- Provides Settings scene (currently empty, will be populated in Phase 4)
- Minimal entry point, delegates core logic to AppDelegate

**Code Pattern**:
```swift
@main
struct AislandApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings { EmptyView() }
    }
}
```

### 2. AppKit Bridge (AppDelegate.swift)

**Responsibility**: System integration and lifecycle management

**Key Features**:
- Hides dock icon (`NSApp.setActivationPolicy(.accessory)`)
- Creates menu bar status item with icon
- Initializes WindowManager and HoverDetector
- Provides quit action

**Critical Behavior**:
- Must run on main thread
- Status item persists for app lifetime
- Menu provides user control when UI is hidden

### 3. Window System

#### AislandWindow.swift

**Responsibility**: Custom floating panel behavior

**Technical Details**:
- Subclass of `NSPanel` for lightweight window
- Level: `.statusBar + 1` (floats above normal windows)
- Style: `.borderless`, `.nonactivatingPanel`
- Collection behavior: `.canJoinAllSpaces`, `.stationary`
- Transparent background, no shadow
- Non-opaque for complex shapes

**Window Hierarchy**:
```
Desktop (level 0)
  ↓
Normal Windows (level 1)
  ↓
Status Bar (level 25)
  ↓
AislandWindow (level 26) ← Aisland floats here
  ↓
Dock (level 500)
```

#### WindowManager.swift

**Responsibility**: Window lifecycle and positioning

**Singleton Pattern**: Uses `static let shared` for global access

**Key Methods**:
- `show()`: Creates window if needed, positions it, displays
- `hide()`: Hides window without destroying
- `toggle()`: Smart show/hide based on current state
- `positionWindow()`: Centers window at top of screen (notch position)

**Positioning Algorithm**:
```swift
let screenFrame = NSScreen.main?.frame ?? .zero
let x = (screenFrame.width - window.frame.width) / 2
let y = screenFrame.height - window.frame.height
window.setFrameOrigin(NSPoint(x: x, y: y))
```

**Future Enhancement**: Detect actual notch bounds using screen safe area insets

### 4. Hover Detection System (HoverDetector.swift)

**Responsibility**: Mouse tracking and activation triggers

**Components**:
- Global mouse monitor using `NSEvent.addGlobalMonitorForEvents`
- Timer-based 300ms hover delay
- Activation zone at top-center of screen

**Detection Algorithm**:
```
1. Monitor mouse moves globally
2. Check if cursor Y > screen height - 100 (top 100px)
3. Check if cursor X within center 40% of screen width
4. If both true for 300ms → activate
5. If cursor exits zone → deactivate
```

**Performance Considerations**:
- Uses weak self to prevent retain cycles
- Invalidates timer on deactivation to save CPU
- Only monitors when app is active

### 5. SwiftUI View Hierarchy

#### ContentView.swift

**Responsibility**: State management and view orchestration

**State Machine**:
```
collapsed → hovering → expanded
    ↑                      ↓
    └──────────────────────┘
```

**State Transitions**:
- `collapsed → hovering`: Mouse enters top zone
- `hovering → expanded`: After 300ms hover
- `expanded → collapsed`: User clicks outside or ESC key

**Animation System**:
- Uses `.spring()` animation for smooth transitions
- Different durations per state (fast collapse, slower expand)
- Matched geometry effects for seamless morphing

#### NotchView.swift

**Responsibility**: Collapsed state UI

**Design**:
- Pill-shaped capsule (120×40pt)
- Ultra-thin material background
- Centered sparkles icon
- Subtle pulsing animation (scale 1.0 → 1.05)

**Hover States**:
- Normal: Opacity 0.8, Scale 1.0
- Hovered: Opacity 1.0, Scale 1.05, Shadow

#### ExpandedView.swift

**Responsibility**: Full widget dashboard

**Layout System**:
- `LazyVGrid` with adaptive columns (180-240pt)
- 16pt spacing between widgets
- Header with title and action buttons
- Scrollable for overflow widgets

**Grid Configuration**:
```swift
LazyVGrid(columns: [
    GridItem(.adaptive(minimum: 180, maximum: 240), spacing: 16)
], spacing: 16) {
    // Widget cards
}
```

#### WidgetCardView.swift

**Responsibility**: Reusable widget card component

**Design Specifications**:
- Fixed height: 140pt
- Rounded corners: 16pt
- Background: `.ultraThinMaterial`
- Header: Icon + Title + Settings button
- Content area: 80pt height
- Footer: Last updated timestamp

**Interaction States**:
- Normal: No shadow, scale 1.0
- Hovered: Medium shadow, scale 1.02
- Pressed: Scale 0.98

**Accessibility**:
- Full VoiceOver support
- Semantic labels for all buttons
- Hint text for interactions
- Proper heading hierarchy

## Data Flow

### Phase 1 (Current)
```
User hovers → HoverDetector → WindowManager → ContentView
                                                    ↓
                                            State changes
                                                    ↓
                                            View updates
```

### Phase 2+ (Future)
```
User hovers → HoverDetector → WindowManager → ContentView
                                                    ↓
                                            WidgetManager
                                                    ↓
                                            SwiftData ← → Individual Widgets
                                                    ↓
                                            View updates
```

## Widget System (Phase 2+)

### Widget Protocol

All widgets conform to `AislandWidget` protocol:

```swift
protocol AislandWidget: Identifiable {
    var id: UUID { get }
    var name: String { get }
    var icon: String { get } // SF Symbol
    var isEnabled: Bool { get set }
    var position: Int { get set }
    var settingsView: AnyView { get }
    var contentView: AnyView { get }

    func onAppear()
    func onDisappear()
    func refresh()
}
```

### Widget Types

1. **Calendar Widget**: EventKit integration, upcoming events
2. **Media Widget**: Now playing, playback controls
3. **Quick Apps Widget**: App launcher with custom list
4. **Notes Widget**: Quick text notes, SwiftData persistence
5. **Camera Mirror Widget**: Live camera preview
6. **Shortcuts Widget**: macOS Shortcuts.app integration
7. **Bluetooth Monitor Widget**: Connected devices display

### Widget Lifecycle

```
App Launch → WidgetManager loads enabled widgets
                ↓
         Creates widget instances
                ↓
         Registers with SwiftData
                ↓
User expands Aisland → Widgets call onAppear()
                ↓
         Widgets refresh data
                ↓
User collapses → Widgets call onDisappear()
                ↓
         Widgets pause updates
```

## Persistence (Phase 2+)

### SwiftData Models

**UserPreferences**:
- Hover delay duration
- Default collapsed state
- Auto-hide in fullscreen
- Theme preference

**WidgetConfiguration**:
- Widget ID
- Enabled state
- Position in grid
- Widget-specific settings (JSON blob)

### Storage Location
```
~/Library/Application Support/com.gbe.Aisland/
├── default.store (SwiftData database)
└── Logs/
```

## Performance Characteristics

### Memory Footprint
- **Target**: < 150MB
- **Current** (Phase 1): ~40MB (minimal widgets)
- **Strategy**: Lazy widget loading, image caching, efficient SwiftUI

### CPU Usage
- **Target**: < 2% average
- **Hover detection**: ~0.1% (global mouse monitoring)
- **Animations**: ~1-2% during transitions (60fps target)
- **Widget updates**: Varies by widget type

### Launch Time
- **Target**: < 500ms
- **Current** (Phase 1): ~200ms
- **Strategy**: Defer widget initialization until first expand

## Security & Permissions

### Required Entitlements

- **Accessibility**: For global mouse monitoring
- **Calendar** (Phase 3): `NSCalendarsFullAccessUsageDescription`
- **Camera** (Phase 3): `NSCameraUsageDescription`
- **Bluetooth** (Phase 3): `NSBluetoothAlwaysUsageDescription`

### Sandboxing

Currently **not sandboxed** for development. Distribution build will require:
- Temporary exception entitlements for system APIs
- Hardened Runtime enabled
- Apple notarization

## Build Configuration

### Debug
- Optimization: `-Onone`
- Assertions: Enabled
- Logging: Verbose
- Code signing: Development

### Release
- Optimization: `-O`
- Assertions: Disabled
- Logging: Error only
- Code signing: Developer ID
- Hardened Runtime: Enabled
- Notarization: Required

## Future Architecture Enhancements

### Phase 4: System Integration
- Fullscreen app detection using `NSWorkspace` notifications
- Auto-hide when fullscreen video detected
- Menu bar preferences window

### Phase 5: Polish
- Lottie animation integration for widget transitions
- Dynamic wallpaper color sampling
- Vibrancy effects based on desktop background

### Phase 6: Testing
- Unit tests for WidgetManager, WindowManager
- UI tests for hover activation, widget interactions
- Performance profiling with Instruments

### Phase 7: Distribution
- Sparkle framework for auto-updates
- EdDSA signature verification
- Update server with changelog RSS feed

## Dependencies

### Current (Phase 1)
- **Swift**: 5.9+
- **macOS SDK**: 14.6+
- **Xcode**: 15.0+

### Planned (Phase 2+)
- **Lottie**: 4.x for animations
- **Sparkle**: 2.x for auto-updates (Phase 7)

## Debugging

### Window Positioning Issues
```bash
# View window hierarchy
sudo lldb --attach-name Aisland
(lldb) po [NSApp windows]
```

### Hover Detection Issues
```bash
# Log mouse events
log stream --predicate 'subsystem == "com.gbe.Aisland"' --level debug
```

### SwiftData Issues
```bash
# View database
sqlite3 ~/Library/Application\ Support/com.gbe.Aisland/default.store
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines and architecture decisions.

---

**Last Updated**: February 15, 2026
**Architecture Version**: 1.0 (Phase 1)
**Next Review**: After Phase 2 completion
