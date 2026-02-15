# NotchNook Clone - Professional Development Specification

## Executive Summary

NotchNook is a sophisticated macOS utility application that transforms the MacBook notch area into a dynamic interactive workspace called "The Nook". This document provides a comprehensive technical specification for building a functionally equivalent clone application.

---

## 1. Application Overview

### Core Concept
Transform the MacBook Pro/Air notch (the camera cutout at the top of the display) from dead space into a productive, interactive widget dashboard that appears when the user hovers near or clicks the notch area.

### Key Value Propositions
- **Space Utilization**: Converts the notch into useful screen real estate
- **Quick Access**: Provides instant access to widgets and tools without leaving current workspace
- **Customization**: Modular widget system allows users to configure their preferred tools
- **System Integration**: Deep macOS integration for media control, calendar, shortcuts, etc.

---

## 2. Technical Architecture

### 2.1 Technology Stack

**Primary Framework**: SwiftUI + AppKit hybrid
- **Language**: Swift 5.x
- **UI Framework**: SwiftUI for modern declarative UI
- **System Integration**: AppKit for advanced window management and system-level features
- **Minimum macOS**: 14.6 (Sonoma)
- **Architecture**: Universal binary (Intel x86_64 + Apple Silicon arm64)

**Key Dependencies**:
```
- Lottie (animation framework for .lottie files)
- Sparkle (auto-update framework)
- MediaRemoteAdapter (custom framework for media control)
- SwiftData (data persistence)
- Combine (reactive programming)
- AVFoundation & AVKit (camera/media)
- EventKit (calendar integration)
- CoreBluetooth (device detection)
- ScreenCaptureKit (screen recording)
- CryptoKit (security/licensing)
- RichTextKit (note editing)
- Highlightr (syntax highlighting)
```

### 2.2 Application Type
**Menu Bar Application** with hidden dock presence
- `LSUIElement = true` (appears in menu bar only, no dock icon)
- Category: `public.app-category.utilities`

---

## 3. Core Architecture Components

### 3.1 Window Management System

**Primary Windows**:
1. **NotchWindow** - The main notch UI overlay
   - Positioned at top-center of screen, anchored to notch
   - `BetterWindow` (custom NSWindow subclass)
   - `SwiftUIAnimatedWindow` for smooth transitions
   - Hover-activated or click-activated
   - Auto-hides when focus lost

2. **ExpandedNookWindow** - Full widget dashboard
   - Expands downward from notch when activated
   - Contains scrollable widget grid
   - Dismisses on outside click or ESC key

3. **SettingsWindow** - Preferences interface
   - `SettingsWindowController` manages tabs
   - `SegmentedControlStyleViewController` for tab navigation
   - Separate window, standard macOS preferences style

**Window Managers**:
- `WindowsManager` - Central coordinator for all window instances
- `AnimatableWindowContentView` - Handles smooth animations
- `CustomScrollView` - Custom scrolling behavior for widgets

### 3.2 Widget System Architecture

**Widget Types** (7 core widgets):

1. **Calendar Widget**
   - `CalendarManager` - Handles EventKit integration
   - `CalendarWidgetSettings` - Configuration storage
   - Features: Upcoming events, quick event creation
   - Permissions: `NSCalendarsFullAccessUsageDescription`

2. **Media Widget**
   - `MediaManager` - Central media state coordinator
   - `MediaManagerPerApp` - Per-application media tracking
   - `MediaKeyTap` + `MediaKeyTapInternals` - Global media key capture
   - `AudioSpectrographNSView` - Live audio visualization
   - `WaveNSView` + `WaveView` - Waveform animations
   - Features: Now playing, playback control, audio visualization
   - Integrates with: Music app, Spotify (via ScriptingBridge)
   - Permissions: `NSAppleMusicUsageDescription`

3. **Quick Apps Widget**
   - `QuickAppsWidgetSettings` - App shortcuts configuration
   - Features: Launcher for frequently used applications
   - Integration: NSWorkspace for app launching

4. **To-Do List Widget**
   - `TodoListWidgetSettings` - Task storage
   - SwiftData models for persistence
   - Features: Task creation, completion tracking

5. **Notes Widget**
   - `ExpandedNoteManager` - Note lifecycle management
   - `NoteDocument` - Document model
   - RichTextKit integration for formatting
   - Features: Quick note-taking with rich text

6. **Mirror Widget**
   - `CameraManager` - AVFoundation camera access
   - `CameraPreview` + `VideoPreviewView` - Live camera feed
   - Features: Front camera mirror view
   - Permissions: `NSCameraUsageDescription`, `NSMicrophoneUsageDescription`

7. **Shortcuts Widget**
   - `ShortcutsManager` - macOS Shortcuts.app integration
   - Features: Quick access to Shortcuts automations

**Widget Framework**:
```swift
// Base widget protocol
protocol NookWidget {
    var id: UUID { get }
    var settings: WidgetSettings { get }
    var view: AnyView { get }
    func configure()
    func refresh()
}

// Widget settings base
class WidgetSettings: ObservableObject {
    @Published var isEnabled: Bool
    @Published var position: Int
    // SwiftData persistence
}
```

### 3.3 Live Activities Integration

**System Integration**:
- `ActiveLiveActivitiesManager` - Monitors iOS Live Activities
- `LiveActivitySelectionManager` - User selection of which activities to show
- Uses macOS Continuity/Handoff to display iPhone Live Activities in the Nook

**Implementation**:
- Monitors connected iOS devices
- Receives Live Activity data via Continuity
- Renders in expanded Nook view
- Real-time updates

### 3.4 System Monitoring & Detection

**Managers**:
1. **BluetoothManager**
   - CoreBluetooth integration
   - Shows connected devices (AirPods, keyboard, mouse, etc.)
   - Permissions: `NSBluetoothAlwaysUsageDescription`

2. **FullscreenMonitor**
   - Detects fullscreen app state
   - Auto-hides Nook when fullscreen content is active
   - Uses ScreenCaptureKit

3. **CurrentWallpaperManager**
   - Reads current desktop wallpaper
   - Adjusts Nook opacity/blur for visibility

4. **TimersManager**
   - Background timers for periodic updates
   - Widget refresh scheduling

---

## 4. User Interaction Patterns

### 4.1 Activation Methods

**Hover Activation**:
```
1. User moves cursor near notch area (top 50px of screen)
2. Delay: 300ms hover detection
3. Notch UI fades in with animation
4. Shows compact status icons
```

**Click Activation**:
```
1. User clicks notch area
2. Immediate activation
3. Expands to show full widget grid
```

**Keyboard Shortcuts**:
- Global hotkey to toggle Nook (configurable)
- ESC to dismiss
- Arrow keys for widget navigation

### 4.2 Animation System

**Lottie Animations**:
- `hello.lottie` - Welcome/onboarding animation
- `click.lottie` - Click feedback
- `drag.lottie` - Drag-and-drop feedback
- `lock.lottie` - Lock screen indicator
- `tray.lottie` - Menu bar icon animation
- `update.lottie` - Update available indicator

**Video Assets**:
- `airdrop.mp4` - AirDrop tutorial
- `media.mp4` - Media widget demo

**GIF Animations**:
- `gunter.gif`, `lisa.gif`, `michael.gif`, `snoopy.gif` - Easter eggs/personality

**Implementation**:
```swift
// Lottie integration via Lottie.framework
import Lottie

struct AnimatedNotchView: View {
    @State private var animationView: LottieAnimationView

    var body: some View {
        LottieView(animation: .named("hello"))
            .playing()
            .looping()
    }
}
```

### 4.3 Drag & Drop Support

**File Drop View**:
- `FileDropView` + `DropAreaView` - Drag-and-drop handling
- `Coordinator` pattern for SwiftUI <-> AppKit bridge
- Supports file attachments to notes
- Visual feedback during drag operations

---

## 5. Data Persistence & Settings

### 5.1 Storage Architecture

**SwiftData** (modern persistence):
```swift
@Model
class WidgetConfiguration {
    var widgetType: WidgetType
    var isEnabled: Bool
    var position: Int
    var customSettings: Data // Codable settings per widget
}

@Model
class UserPreferences {
    var autoLaunchAtLogin: Bool
    var hoverSensitivity: Double
    var theme: ThemeMode
    var enabledWidgets: [UUID]
}
```

**Defaults Framework**:
- Uses `Defaults_Defaults.bundle`
- Type-safe UserDefaults wrapper
- Automatic persistence

### 5.2 Configuration Files

**Widget Reordering**:
- Drag-to-reorder interface
- `ReorderWidgetsView` component
- Saves order in SwiftData

**Import/Export**:
- `.nookpipeline` file format
- Compressed configuration bundle
- UTI: `lo.cafe.NotchNook.pipeline-installer`
- Allows sharing widget setups

---

## 6. Security & Permissions

### 6.1 Required Permissions

```xml
<key>NSAppleEventsUsageDescription</key>
<string>Required for keyboard event handling</string>

<key>NSAppleMusicUsageDescription</key>
<string>Display currently playing track</string>

<key>NSBluetoothAlwaysUsageDescription</key>
<string>Show connected Bluetooth devices</string>

<key>NSCalendarsFullAccessUsageDescription</key>
<string>Power calendar widget and Live Activities</string>

<key>NSCameraUsageDescription</key>
<string>Mirror widget camera feed</string>

<key>NSMicrophoneUsageDescription</key>
<string>Mirror widget audio</string>
```

### 6.2 Licensing System

**Framework**: CryptoKit + swift-crypto
- `LicenseManager` - License validation
- Public key verification: `setappPublicKey.pem`
- Encrypted license storage
- Trial/paid license states

**Setapp Integration**:
- Subscription validation via Setapp SDK
- Public key: `setappPublicKey.pem`

---

## 7. Updates & Distribution

### 7.1 Auto-Update System

**Sparkle Framework** (v2.6.4):
```xml
<key>SUFeedURL</key>
<string>https://lo.cafe/notchnook-files/appcast.xml</string>

<key>SUPublicEDKey</key>
<string>3DhmF9fTgJEvwxALa0MoAMflZtjyhtSaVg/UAB0Q2PA=</string>

<key>SUScheduledCheckInterval</key>
<integer>86400</integer> <!-- 24 hours -->
```

**Implementation**:
- `SparkleManager` - Update coordinator
- `updaterController` - UI for update prompts
- Automatic check every 24 hours
- EdDSA signature verification

### 7.2 Changelog System

- `changelogViewWindow` - Release notes display
- Markdown-formatted changelogs
- Shown on first launch after update

---

## 8. Internationalization (i18n)

### Supported Languages (28 total):
```
ar (Arabic), ca (Catalan), cs (Czech), da (Danish),
de (German), el (Greek), es (Spanish), fi (Finnish),
fr (French), he (Hebrew), hi (Hindi), hu (Hungarian),
it (Italian), ja (Japanese), ko (Korean), nb (Norwegian),
nl (Dutch), pl (Polish), pt-BR (Brazilian Portuguese),
pt-PT (European Portuguese), ro (Romanian), ru (Russian),
sk (Slovak), sr (Serbian), sv (Swedish), tr (Turkish),
uk (Ukrainian), vi (Vietnamese), zh-Hans (Simplified Chinese),
zh-Hant (Traditional Chinese)
```

**Implementation**:
- `.lproj` directories for each language
- NSLocalizedString for all UI text
- Dynamic layout for RTL languages (Arabic, Hebrew)

---

## 9. Visual Design System

### 9.1 Design Language

**Fluid Gradient System**:
- `FluidGradientView` (custom framework)
- Animated background gradients
- Adapts to system appearance (Light/Dark mode)

**Vibrancy & Blur**:
- macOS native materials (NSVisualEffectView)
- Dynamic blur adapts to wallpaper
- `VibratingCircleNSView` - Pulsing indicators

**Icon System**:
- SF Symbols integration
- Custom app icon: `AppIcon.icns`
- Adaptive menu bar icon

### 9.2 Theming

**Light/Dark Mode**:
- Automatic system appearance matching
- Manual override option
- Widget-specific color schemes

---

## 10. Performance Optimization

### 10.1 Resource Management

**Lazy Loading**:
- Widgets loaded on-demand
- SwiftUI's `@StateObject` and `@ObservedObject`
- View recycling for widget grid

**Memory Management**:
- Proper cleanup on window dismiss
- Release camera/mic resources when inactive
- Periodic cache clearing

### 10.2 Animation Performance

**CALayer Optimization**:
- Hardware-accelerated animations
- Metal backend for Lottie
- 60fps target for all transitions

---

## 11. Development Workflow

### 11.1 Project Structure

```
NotchNook/
├── App/
│   ├── NotchNookApp.swift          # Main app entry
│   └── AppDelegate.swift           # AppKit lifecycle
├── Views/
│   ├── RootView.swift              # Root SwiftUI view
│   ├── BetterWindow.swift          # Custom window class
│   ├── NotchView/                  # Notch UI components
│   ├── Widgets/                    # Individual widget views
│   │   ├── CalendarWidgetView.swift
│   │   ├── MediaWidgetView.swift
│   │   ├── MirrorWidgetView.swift
│   │   ├── NotesWidgetView.swift
│   │   └── ...
│   └── Settings/                   # Settings UI
├── Managers/
│   ├── WindowsManager.swift
│   ├── MediaManager.swift
│   ├── CalendarManager.swift
│   ├── BluetoothManager.swift
│   └── ...
├── Models/
│   ├── WidgetSettings.swift        # SwiftData models
│   └── UserPreferences.swift
├── Utilities/
│   ├── MediaKeyTap.swift           # Global shortcuts
│   └── Extensions/
└── Resources/
    ├── Animations/                 # .lottie files
    ├── Videos/                     # Demo videos
    └── Localizations/              # .lproj folders
```

### 11.2 Build Configuration

**Xcode Settings**:
- Deployment Target: macOS 14.6+
- Swift Language Version: 5.x
- Enable Hardened Runtime
- Code signing: Developer ID Application
- Sandbox: No (requires system-level permissions)

**Build Phases**:
1. Compile Swift sources
2. Link frameworks (Lottie, Sparkle, custom)
3. Copy resources (.lottie, .lproj, bundles)
4. Code sign frameworks
5. Generate .app bundle
6. Notarize for distribution

---

## 12. Implementation Roadmap

### Phase 1: Core Infrastructure (Week 1-2)
- [ ] Set up Xcode project with Swift Package Manager
- [ ] Implement `BetterWindow` custom window class
- [ ] Create basic notch detection and positioning
- [ ] Build hover/click activation system
- [ ] Set up SwiftData persistence

### Phase 2: Window Management (Week 3)
- [ ] Implement `WindowsManager`
- [ ] Create expand/collapse animations
- [ ] Add keyboard shortcut handling
- [ ] Implement auto-hide on focus loss
- [ ] Add fullscreen detection (`FullscreenMonitor`)

### Phase 3: Widget Framework (Week 4-5)
- [ ] Design widget protocol and base classes
- [ ] Implement widget grid layout
- [ ] Add drag-to-reorder functionality
- [ ] Create widget settings system
- [ ] Build widget enable/disable toggles

### Phase 4: Individual Widgets (Week 6-9)
**Week 6**: Calendar + Quick Apps
- [ ] Calendar widget with EventKit
- [ ] Quick Apps launcher

**Week 7**: Media Widget
- [ ] Media playback detection
- [ ] Playback controls
- [ ] Audio visualization
- [ ] Music.app + Spotify integration

**Week 8**: Notes + To-Do
- [ ] Rich text note editor
- [ ] To-do list with persistence

**Week 9**: Mirror + Shortcuts
- [ ] Camera mirror widget
- [ ] Shortcuts.app integration

### Phase 5: System Integration (Week 10-11)
- [ ] Bluetooth device detection
- [ ] Live Activities integration
- [ ] Wallpaper detection and adaptation
- [ ] Menu bar icon and menu

### Phase 6: Polish & Features (Week 12-14)
- [ ] Lottie animation integration
- [ ] Implement all UI animations
- [ ] Settings window with all preferences
- [ ] Light/Dark mode theming
- [ ] Localization (start with English)

### Phase 7: Updates & Distribution (Week 15-16)
- [ ] Integrate Sparkle framework
- [ ] Set up update server
- [ ] Implement license system
- [ ] Code signing and notarization
- [ ] Create installer/DMG

### Phase 8: Testing & Refinement (Week 17-18)
- [ ] Beta testing on various Mac models
- [ ] Performance optimization
- [ ] Bug fixing
- [ ] Additional localizations
- [ ] Documentation

---

## 13. Critical Technical Challenges

### Challenge 1: Notch Position Detection
**Problem**: Different Mac models have notches at different positions
**Solution**:
```swift
func detectNotchBounds() -> CGRect? {
    guard let screen = NSScreen.main else { return nil }

    // Check for notched screens
    if #available(macOS 12.0, *) {
        let safeArea = screen.safeAreaInsets
        if safeArea.top > 0 {
            // Notch exists, calculate center position
            let notchWidth: CGFloat = 200 // Approximate
            let notchHeight = safeArea.top
            let centerX = screen.frame.width / 2

            return CGRect(
                x: centerX - notchWidth/2,
                y: screen.frame.maxY - notchHeight,
                width: notchWidth,
                height: notchHeight
            )
        }
    }
    return nil
}
```

### Challenge 2: Window Level Management
**Problem**: Notch window must stay above all other windows but below system UI
**Solution**:
```swift
class NotchWindow: NSPanel {
    override init(contentRect: NSRect,
                  styleMask: NSWindow.StyleMask,
                  backing: NSWindow.BackingStoreType,
                  defer flag: Bool) {
        super.init(contentRect: contentRect,
                   styleMask: [.borderless, .nonactivatingPanel],
                   backing: backing,
                   defer: flag)

        self.level = .statusBar + 1 // Above normal windows
        self.collectionBehavior = [.canJoinAllSpaces, .stationary]
        self.isOpaque = false
        self.backgroundColor = .clear
        self.hasShadow = false
    }
}
```

### Challenge 3: Hover Detection
**Problem**: Efficient hover detection without polling
**Solution**:
```swift
class HoverDetector {
    private var trackingArea: NSTrackingArea?

    func setupTracking(in view: NSView) {
        trackingArea = NSTrackingArea(
            rect: view.bounds,
            options: [
                .mouseEnteredAndExited,
                .activeInKeyWindow,
                .inVisibleRect
            ],
            owner: view,
            userInfo: nil
        )
        view.addTrackingArea(trackingArea!)
    }
}
```

### Challenge 4: Media Key Capture
**Problem**: Global media key capture without accessibility permissions
**Solution**: Use `MediaKeyTap` with IOKit HID events
```swift
class MediaKeyTap {
    func startTapping() {
        let eventMask = (1 << NX_KEYDOWN) | (1 << NX_KEYUP) | (1 << NX_FLAGSCHANGED)

        guard let eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: { proxy, type, event, refcon -> Unmanaged<CGEvent>? in
                // Handle media keys (NX_KEYTYPE_PLAY, etc.)
                return Unmanaged.passUnretained(event)
            },
            userInfo: nil
        ) else { return }

        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
    }
}
```

---

## 14. Testing Strategy

### Unit Tests
- Widget data models (SwiftData)
- Manager classes (MediaManager, CalendarManager)
- Utility functions

### Integration Tests
- Window management flow
- Widget activation/deactivation
- Settings persistence

### UI Tests
- Hover activation
- Click activation
- Widget interactions
- Settings navigation

### Manual Testing Checklist
- [ ] Test on MacBook Pro with notch (14" & 16")
- [ ] Test on MacBook Air with notch
- [ ] Test on older Macs without notch
- [ ] Test all permissions (Calendar, Camera, Bluetooth, etc.)
- [ ] Test Light/Dark mode switching
- [ ] Test with external displays
- [ ] Test fullscreen app detection
- [ ] Test all widgets individually
- [ ] Test performance with all widgets enabled
- [ ] Test updates via Sparkle

---

## 15. Marketing & Distribution

### App Store Presence
**Not suitable for Mac App Store** due to:
- Sandbox restrictions (requires system-level access)
- Accessibility permissions
- Media key capture
- Global hotkeys

**Alternative Distribution**:
- Direct download from website
- Setapp subscription platform
- GitHub Releases (for open-source variant)

### Pricing Model Options
1. **Freemium**: Basic widgets free, premium widgets paid
2. **One-time Purchase**: $19.99-$29.99
3. **Subscription**: $4.99/month or $39.99/year
4. **Setapp**: Revenue share model

---

## 16. Advanced Features (Post-MVP)

### AI Integration
- ChatGPT/Claude integration in Notes widget
- Smart suggestions based on usage patterns
- Voice commands via Siri integration

### Cloud Sync
- iCloud sync for settings and notes
- Cross-device widget configuration

### Third-Party Integrations
- Notion API for task sync
- Todoist integration
- Spotify/Apple Music rich controls
- Slack notifications

### Custom Widget SDK
- Allow third-party developers to create widgets
- Plugin architecture
- App Store for Nook widgets

---

## 17. Legal & Compliance

### Privacy Policy Requirements
- Clearly state what data is collected (calendar, media, camera)
- Explain how data is used (local only, no server transmission)
- User consent for each permission
- GDPR compliance for EU users

### Code Signing
- Developer ID Application certificate
- Notarization via Apple
- Hardened Runtime enabled
- Secure timestamp

### Open Source Considerations
If releasing as open source:
- Choose license (MIT, GPL, Apache 2.0)
- Remove proprietary assets (Lottie animations, GIFs)
- Remove Setapp integration
- Document build process

---

## 18. Performance Benchmarks

### Target Metrics
- **Launch Time**: < 500ms
- **Hover Response**: < 100ms
- **Animation Frame Rate**: 60fps
- **Memory Footprint**: < 150MB
- **CPU Usage (Idle)**: < 2%
- **CPU Usage (Active)**: < 10%

### Profiling Tools
- Instruments (Time Profiler)
- Instruments (Allocations)
- Instruments (Leaks)
- Xcode Memory Graph Debugger

---

## 19. Support & Documentation

### User Documentation
- Quick Start Guide (first launch tutorial)
- Widget documentation (what each does)
- Troubleshooting guide
- FAQ section
- Video tutorials

### Developer Documentation
- Architecture overview
- Widget API reference
- Contributing guidelines (if open source)
- Build instructions

---

## 20. Success Criteria

### MVP Launch Criteria
- [ ] All 7 core widgets functional
- [ ] Stable on macOS 14.6+
- [ ] < 5 critical bugs
- [ ] All animations smooth (60fps)
- [ ] Settings fully functional
- [ ] Auto-update working
- [ ] Notarized and code-signed

### Post-Launch Metrics
- User retention > 70% after 30 days
- Average session time > 5 minutes/day
- Crash-free rate > 99.5%
- Positive reviews > 80%

---

## Conclusion

This specification provides a complete roadmap for building a NotchNook clone. The application is technically complex but achievable with:
- **Strong Swift/SwiftUI skills**
- **Deep macOS system knowledge**
- **18-20 weeks development time** (for solo developer)
- **Focus on polish and UX** (critical for utility apps)

The key differentiator will be execution quality, animation smoothness, and system integration depth. Start with the core window management and activation system, then incrementally add widgets.

**Recommended First Milestone**: Get a basic notch window appearing and responding to hover/click within Week 1-2. Everything else builds on this foundation.

---

*Document Version: 1.0*
*Last Updated: February 15, 2026*
*Based on: NotchNook v1.5.5 (Build 41)*
