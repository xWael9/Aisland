# Aisland Development Actionbook

**Project**: Aisland - Dynamic Island for Mac
**Goal**: Build a macOS utility that transforms the MacBook notch into an interactive widget dashboard
**Timeline**: 18 weeks (phased approach)
**Repository**: https://github.com/xWael9/Aisland

---

## Current Phase: Phase 1 - Project Foundation

### Immediate Tasks (Week 1)

#### Task 1: Xcode Project Setup
**Agent**: @project-planner + @backend-specialist
**Status**: 🔴 Not Started
**Priority**: P0 (Critical)

**Deliverables**:
- [ ] Create Aisland.xcodeproj with Swift Package Manager
- [ ] Configure build settings (macOS 14.6+ deployment target)
- [ ] Set up folder structure following Apple's conventions
- [ ] Configure Info.plist with required permissions
- [ ] Add .gitignore for Xcode
- [ ] Set up Swift Package dependencies

**Technical Requirements**:
```
Minimum macOS: 14.6
Swift Version: 5.x
Architecture: Universal (Intel + Apple Silicon)
App Type: Menu Bar Utility (LSUIElement = true)
Code Signing: Development for now
```

**Dependencies to Add**:
```swift
// Package.swift dependencies
- Lottie (for animations)
- Sparkle (for auto-updates) - will add later
```

---

#### Task 2: Core Window Management System
**Agent**: @backend-specialist + @frontend-specialist
**Status**: 🔴 Not Started
**Priority**: P0 (Critical)

**Deliverables**:
- [ ] `AislandWindow.swift` - Custom NSPanel subclass
- [ ] `WindowManager.swift` - Singleton to manage window lifecycle
- [ ] Notch position detection algorithm
- [ ] Basic window positioning at notch location
- [ ] Window level management (above normal windows)

**Technical Approach**:
```swift
// AislandWindow.swift
class AislandWindow: NSPanel {
    // Window configuration:
    // - Level: .statusBar + 1
    // - Style: .borderless, .nonactivatingPanel
    // - Collection behavior: .canJoinAllSpaces, .stationary
    // - Transparent background
    // - No shadow initially
}
```

**Success Criteria**:
- Window appears at notch position
- Window stays on top of other apps
- Window visible on all spaces
- No dock icon visible

---

#### Task 3: Hover Detection System
**Agent**: @backend-specialist
**Status**: 🔴 Not Started
**Priority**: P0 (Critical)

**Deliverables**:
- [ ] `HoverDetector.swift` - Tracking area manager
- [ ] Mouse position monitoring
- [ ] 300ms hover delay implementation
- [ ] Activation/deactivation logic

**Technical Approach**:
```swift
class HoverDetector {
    private var trackingArea: NSTrackingArea?
    private var hoverTimer: Timer?

    func setupTracking(in view: NSView)
    func handleMouseEntered()
    func handleMouseExited()
}
```

**Success Criteria**:
- Hovering near top-center triggers activation after 300ms
- Moving away dismisses the window
- No false positives

---

#### Task 4: Basic SwiftUI Integration
**Agent**: @frontend-specialist
**Status**: 🔴 Not Started
**Priority**: P1 (High)

**Deliverables**:
- [ ] `ContentView.swift` - Root SwiftUI view
- [ ] `AislandApp.swift` - App entry point
- [ ] SwiftUI <-> AppKit bridge
- [ ] Basic notch UI mockup

**Technical Approach**:
```swift
@main
struct AislandApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings { EmptyView() } // No settings window yet
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var windowManager: WindowManager?

    func applicationDidFinishLaunching(_ notification: Notification) {
        windowManager = WindowManager.shared
        windowManager?.showAisland()
    }
}
```

---

#### Task 5: Project Documentation
**Agent**: @documentation-writer
**Status**: 🔴 Not Started
**Priority**: P2 (Medium)

**Deliverables**:
- [ ] ARCHITECTURE.md - System design overview
- [ ] CONTRIBUTING.md - Development guidelines
- [ ] CODE_OF_CONDUCT.md - Community standards
- [ ] Update README.md with build instructions

---

### Phase 1 Success Criteria

**Week 1 Milestones**:
1. ✅ Xcode project created and builds successfully
2. ✅ Window appears at notch position when app launches
3. ✅ Hovering near notch shows/hides the window
4. ✅ Basic SwiftUI view displays in the window
5. ✅ Code pushed to GitHub

**Demo**: Run app → hover near notch → see a simple colored rectangle appear

---

## Phase 2: Widget Framework (Week 2-3)

### Task 6: Widget Protocol & Base Classes
**Agent**: @backend-specialist + @database-architect
**Status**: 🔴 Not Started
**Priority**: P0

**Deliverables**:
- [ ] `Widget.swift` - Protocol defining widget interface
- [ ] `WidgetSettings.swift` - SwiftData model for persistence
- [ ] `WidgetManager.swift` - Widget registry and lifecycle
- [ ] Base widget implementation

**Widget Protocol**:
```swift
protocol AislandWidget: Identifiable {
    var id: UUID { get }
    var name: String { get }
    var icon: String { get } // SF Symbol name
    var isEnabled: Bool { get set }
    var position: Int { get set }
    var settingsView: AnyView { get }
    var contentView: AnyView { get }

    func onAppear()
    func onDisappear()
    func refresh()
}
```

---

### Task 7: Widget Grid Layout
**Agent**: @frontend-specialist
**Status**: 🔴 Not Started
**Priority**: P0

**Deliverables**:
- [ ] `WidgetGridView.swift` - LazyVGrid layout
- [ ] Drag-to-reorder functionality
- [ ] Expand/collapse animations
- [ ] Widget enable/disable toggles

---

### Task 8: SwiftData Persistence
**Agent**: @database-architect
**Status**: 🔴 Not Started
**Priority**: P1

**Deliverables**:
- [ ] SwiftData model container setup
- [ ] `UserPreferences` model
- [ ] `WidgetConfiguration` model
- [ ] Migration strategy

---

## Phase 3: Core Widgets (Week 4-9)

### Task 9: Calendar Widget
**Agent**: @backend-specialist
**Status**: 🔴 Not Started
**Priority**: P1

**Requirements**:
- EventKit integration
- Display upcoming events
- Quick event creation
- Permissions: `NSCalendarsFullAccessUsageDescription`

---

### Task 10: Media Widget
**Agent**: @backend-specialist + @frontend-specialist
**Status**: 🔴 Not Started
**Priority**: P1

**Requirements**:
- Now playing detection (Music.app, Spotify)
- Playback controls (play, pause, skip)
- Audio visualization (optional)
- MediaPlayer framework integration

---

### Task 11: Quick Apps Widget
**Agent**: @backend-specialist
**Status**: 🔴 Not Started
**Priority**: P2

**Requirements**:
- App launcher functionality
- User-configurable app list
- Launch via NSWorkspace

---

### Task 12: Notes Widget
**Agent**: @backend-specialist + @frontend-specialist
**Status**: 🔴 Not Started
**Priority**: P2

**Requirements**:
- Simple text note taking
- SwiftData persistence
- Basic formatting (optional)

---

### Task 13: Camera Mirror Widget
**Agent**: @backend-specialist
**Status**: 🔴 Not Started
**Priority**: P2

**Requirements**:
- AVFoundation camera access
- Live camera preview
- Permissions: `NSCameraUsageDescription`

---

### Task 14: Shortcuts Widget
**Agent**: @backend-specialist
**Status**: 🔴 Not Started
**Priority**: P2

**Requirements**:
- Integration with macOS Shortcuts.app
- Execute shortcuts from widget

---

### Task 15: Bluetooth Monitor Widget
**Agent**: @backend-specialist
**Status**: 🔴 Not Started
**Priority**: P3

**Requirements**:
- CoreBluetooth integration
- Show connected devices
- Permissions: `NSBluetoothAlwaysUsageDescription`

---

## Phase 4: System Integration (Week 10-11)

### Task 16: Fullscreen Detection
**Agent**: @backend-specialist
**Status**: 🔴 Not Started

**Requirements**:
- Detect when fullscreen app is active
- Auto-hide Aisland when fullscreen

---

### Task 17: Menu Bar Icon & Menu
**Agent**: @frontend-specialist
**Status**: 🔴 Not Started

**Requirements**:
- Menu bar icon
- Preferences menu item
- Quit menu item
- About window

---

### Task 18: Settings Window
**Agent**: @frontend-specialist
**Status**: 🔴 Not Started

**Requirements**:
- General preferences
- Widget enable/disable
- Hotkey configuration
- Appearance settings

---

## Phase 5: Polish & Features (Week 12-14)

### Task 19: Animations
**Agent**: @frontend-specialist
**Status**: 🔴 Not Started

**Requirements**:
- Lottie integration
- Smooth transitions
- 60fps animations

---

### Task 20: Theming
**Agent**: @frontend-specialist
**Status**: 🔴 Not Started

**Requirements**:
- Light/Dark mode
- Blur/vibrancy effects
- Wallpaper adaptation

---

### Task 21: Keyboard Shortcuts
**Agent**: @backend-specialist
**Status**: 🔴 Not Started

**Requirements**:
- Global hotkey to toggle
- ESC to dismiss
- Widget navigation

---

## Phase 6: Testing & QA (Week 15-16)

### Task 22: Unit Tests
**Agent**: @test-engineer + @qa-automation-engineer
**Status**: 🔴 Not Started

**Requirements**:
- Widget manager tests
- Data model tests
- Utility function tests

---

### Task 23: UI Tests
**Agent**: @qa-automation-engineer
**Status**: 🔴 Not Started

**Requirements**:
- Hover activation test
- Widget interaction tests
- Settings window tests

---

### Task 24: Performance Testing
**Agent**: @performance-optimizer
**Status**: 🔴 Not Started

**Requirements**:
- Memory profiling
- CPU usage monitoring
- Animation performance
- Launch time optimization

---

## Phase 7: Distribution (Week 17-18)

### Task 25: Code Signing & Notarization
**Agent**: @devops-engineer
**Status**: 🔴 Not Started

**Requirements**:
- Developer ID certificate
- Hardened Runtime
- Notarization workflow

---

### Task 26: Auto-Update System
**Agent**: @devops-engineer
**Status**: 🔴 Not Started

**Requirements**:
- Sparkle integration
- Update server setup
- Changelog display

---

### Task 27: Release Preparation
**Agent**: @product-manager
**Status**: 🔴 Not Started

**Requirements**:
- Release notes
- Demo video
- Marketing materials
- Distribution strategy

---

## Critical Path

```
Week 1:  Project Setup → Window Management → Hover Detection
Week 2:  Widget Framework → Grid Layout
Week 3:  SwiftData Setup → Settings Persistence
Week 4:  Calendar Widget
Week 5:  Media Widget
Week 6:  Quick Apps Widget
Week 7:  Notes Widget
Week 8:  Camera Mirror Widget
Week 9:  Shortcuts Widget
Week 10: Fullscreen Detection → Menu Bar
Week 11: Settings Window
Week 12: Animations
Week 13: Theming → Polish
Week 14: Final UI Polish
Week 15: Testing
Week 16: Bug Fixes
Week 17: Code Signing → Notarization
Week 18: Release Prep → Launch
```

---

## Agent Assignments

### Primary Agents:
- **@project-planner**: Overall project coordination
- **@backend-specialist**: Core systems, managers, integrations
- **@frontend-specialist**: SwiftUI views, animations, theming
- **@database-architect**: SwiftData models, persistence
- **@test-engineer**: Unit testing, integration tests
- **@qa-automation-engineer**: UI tests, automation
- **@performance-optimizer**: Profiling, optimization
- **@devops-engineer**: Build, distribution, CI/CD
- **@documentation-writer**: Docs, guides, README
- **@product-manager**: Requirements, priorities, launch

### Support Agents:
- **@code-archaeologist**: Refactoring, code quality
- **@security-auditor**: Permissions, privacy, security
- **@explorer-agent**: Research, problem solving

---

## Development Standards

### Code Style:
- SwiftLint for code formatting
- Follow Apple's Swift API Design Guidelines
- Meaningful variable names
- Comments for complex logic only

### Git Workflow:
- Feature branches for each task
- Pull requests for review
- Conventional commits
- Semantic versioning

### Testing Requirements:
- Unit tests for business logic
- UI tests for critical flows
- 80%+ code coverage goal

---

## Success Metrics

### MVP Launch (Week 18):
- ✅ Stable on macOS 14.6+
- ✅ All 7 widgets functional
- ✅ < 5 critical bugs
- ✅ 60fps animations
- ✅ < 500ms launch time
- ✅ < 150MB memory footprint

### Post-Launch (Month 1):
- 100+ GitHub stars
- 70%+ user retention
- 99.5%+ crash-free rate
- Positive community feedback

---

## Communication Protocol

### Daily Standup (Async):
- What was completed yesterday
- What's planned for today
- Any blockers

### Weekly Review:
- Milestone progress
- Demo of completed features
- Next week planning

### Issue Tracking:
- GitHub Issues for bugs
- GitHub Projects for task tracking
- Labels: bug, enhancement, documentation, etc.

---

## Resources

### Design References:
- NotchNook (inspiration)
- macOS Human Interface Guidelines
- Apple Design Resources

### Technical Resources:
- SwiftUI Documentation
- AppKit Documentation
- Swift Package Index

---

**Last Updated**: February 15, 2026
**Next Review**: Week 1 completion
**Project Lead**: Claude Code + Wael
