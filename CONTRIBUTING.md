# Contributing to Aisland

Thank you for your interest in contributing to Aisland! This document provides guidelines and best practices for development.

## Table of Contents

- [Development Setup](#development-setup)
- [Code Style](#code-style)
- [Git Workflow](#git-workflow)
- [Testing Guidelines](#testing-guidelines)
- [Pull Request Process](#pull-request-process)
- [Architecture Decisions](#architecture-decisions)

## Development Setup

### Prerequisites

- **macOS**: 14.6 (Sonoma) or later
- **Xcode**: 15.0 or later
- **Swift**: 5.9+
- **Git**: Latest version
- **GitHub CLI** (optional): `brew install gh`

### Clone and Build

```bash
# Clone repository
git clone https://github.com/xWael9/Aisland.git
cd Aisland

# Open in Xcode
open Aisland.xcodeproj

# Build (⌘+B) and Run (⌘+R)
```

### Project Structure

```
Aisland/
├── Aisland/                    # Main app target
│   ├── AislandApp.swift        # SwiftUI entry point
│   ├── AppDelegate.swift       # AppKit bridge
│   ├── Windows/                # Window management
│   │   ├── AislandWindow.swift
│   │   └── WindowManager.swift
│   ├── Managers/               # Business logic
│   │   └── HoverDetector.swift
│   ├── Views/                  # SwiftUI views
│   │   ├── ContentView.swift
│   │   ├── NotchView.swift
│   │   ├── ExpandedView.swift
│   │   └── WidgetCardView.swift
│   ├── Widgets/                # Widget implementations (Phase 2+)
│   ├── Models/                 # SwiftData models (Phase 2+)
│   └── Resources/              # Assets, Lottie files
├── AislandTests/               # Unit tests (Phase 6)
├── AislandUITests/             # UI tests (Phase 6)
├── ACTIONBOOK.md               # Development roadmap
├── ARCHITECTURE.md             # System design
└── DESIGN.md                   # UI/UX guidelines
```

## Code Style

### Swift Style Guide

We follow [Apple's Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/) with these additions:

#### Naming Conventions

```swift
// ✅ Good
class WindowManager { }
func positionWindow() { }
var isHovering: Bool
let hoverDelay: TimeInterval = 0.3

// ❌ Bad
class windowManager { }
func position_window() { }
var hovering: Bool
let HOVER_DELAY = 0.3
```

#### SwiftUI View Structure

```swift
struct MyView: View {
    // 1. Property wrappers
    @State private var isExpanded = false
    @Environment(\.colorScheme) private var colorScheme

    // 2. Regular properties
    let title: String
    var onTap: (() -> Void)?

    // 3. Body
    var body: some View {
        // View hierarchy
    }

    // 4. Private computed properties
    private var backgroundColor: Color {
        colorScheme == .dark ? .black : .white
    }

    // 5. Private methods
    private func handleTap() {
        // Logic
    }
}
```

#### AppKit Best Practices

```swift
// ✅ Use weak self in closures
NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) { [weak self] event in
    self?.handleMouseMove(event)
}

// ✅ Check for nil when accessing optionals
guard let screen = NSScreen.main else { return }

// ✅ Use proper window levels
window.level = .statusBar + 1

// ❌ Don't force unwrap
let screen = NSScreen.main! // NEVER DO THIS
```

### Comments

```swift
// Only comment complex logic, not obvious code

// ✅ Good - explains WHY
// Add 1 to status bar level to float above menu bar icons
window.level = .statusBar + 1

// ❌ Bad - explains WHAT (already obvious)
// Set window level to status bar plus one
window.level = .statusBar + 1

// ✅ Good - documents algorithm
/// Detects if mouse is hovering in the activation zone.
/// Zone is defined as:
/// - Top 100px of screen (Y coordinate)
/// - Center 40% of screen width (X coordinate)
private func isInActivationZone(_ point: NSPoint) -> Bool {
    // Implementation
}
```

### SwiftLint

We use SwiftLint for automated style checking (will be added in Phase 2).

```bash
# Install SwiftLint
brew install swiftlint

# Run linter
swiftlint lint

# Auto-fix issues
swiftlint --fix
```

## Git Workflow

### Branching Strategy

- `main` - Production-ready code
- `develop` - Integration branch (will be created in Phase 2)
- `feature/<task-name>` - Feature branches
- `bugfix/<issue-number>` - Bug fix branches
- `hotfix/<issue-number>` - Emergency fixes

### Branch Naming

```bash
# Feature branch
git checkout -b feature/calendar-widget

# Bug fix
git checkout -b bugfix/123-hover-detection

# Hotfix
git checkout -b hotfix/456-crash-on-launch
```

### Commit Messages

We use [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Code style (formatting, no logic change)
- `refactor`: Code restructuring
- `test`: Adding tests
- `chore`: Build process, dependencies

**Examples**:

```bash
# Feature
git commit -m "feat(widgets): Add Calendar widget with EventKit integration"

# Bug fix
git commit -m "fix(hover): Prevent false activation on screen edge"

# Documentation
git commit -m "docs(readme): Add build instructions"

# Multi-line with body
git commit -m "feat(window): Implement notch position detection

- Calculate notch bounds using screen safe area
- Center window horizontally within notch
- Add fallback for non-notch Macs

Closes #42"
```

### Pull Request Process

1. **Create Feature Branch**
   ```bash
   git checkout -b feature/my-feature
   ```

2. **Make Changes**
   - Follow code style guidelines
   - Add tests if applicable
   - Update documentation

3. **Commit Changes**
   ```bash
   git add .
   git commit -m "feat: Add my feature"
   ```

4. **Push to GitHub**
   ```bash
   git push origin feature/my-feature
   ```

5. **Create Pull Request**
   - Use GitHub web interface or `gh pr create`
   - Fill out PR template
   - Link related issues
   - Request review

6. **Code Review**
   - Address feedback
   - Update PR as needed
   - Maintain conversation thread

7. **Merge**
   - Squash commits for clean history
   - Delete feature branch after merge

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Tested on macOS 14.6
- [ ] Tested on macOS 15.x
- [ ] Unit tests pass
- [ ] UI tests pass

## Screenshots (if applicable)
[Add screenshots]

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No new warnings
- [ ] Tests added/updated

## Related Issues
Closes #123
```

## Testing Guidelines

### Unit Testing (Phase 6)

```swift
import XCTest
@testable import Aisland

class WindowManagerTests: XCTestCase {
    var windowManager: WindowManager!

    override func setUp() {
        super.setUp()
        windowManager = WindowManager.shared
    }

    override func tearDown() {
        windowManager = nil
        super.tearDown()
    }

    func testWindowPositioning() {
        // Given
        let expectedY = NSScreen.main!.frame.height - windowManager.window?.frame.height ?? 0

        // When
        windowManager.positionWindow()

        // Then
        XCTAssertEqual(windowManager.window?.frame.origin.y, expectedY)
    }
}
```

### UI Testing (Phase 6)

```swift
import XCTest

class AislandUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
    }

    func testHoverActivation() {
        // Test hover detection and expansion
        // Note: Requires accessibility permissions
    }
}
```

### Manual Testing Checklist

Before submitting PR:

- [ ] App launches without crash
- [ ] Menu bar icon appears
- [ ] Hovering near top-center triggers expansion
- [ ] Window appears at correct position
- [ ] Animations are smooth (60fps)
- [ ] No memory leaks (check Instruments)
- [ ] Works on both Intel and Apple Silicon
- [ ] Works on macOS 14.6 and 15.x

## Architecture Decisions

### When to Use AppKit vs SwiftUI

**Use AppKit for**:
- Window management
- Menu bar integration
- Global event monitoring
- Precise positioning and sizing
- Custom window behavior

**Use SwiftUI for**:
- UI layout and views
- State management
- Animations
- Modern declarative patterns

### State Management

```swift
// ✅ Good - Use @State for view-local state
struct MyView: View {
    @State private var isExpanded = false
}

// ✅ Good - Use @StateObject for view-owned models
struct MyView: View {
    @StateObject private var viewModel = MyViewModel()
}

// ✅ Good - Use @ObservedObject for passed-in models
struct MyView: View {
    @ObservedObject var sharedModel: SharedModel
}

// ✅ Good - Use @Environment for dependency injection
struct MyView: View {
    @Environment(\.colorScheme) private var colorScheme
}
```

### Error Handling

```swift
// ✅ Good - Handle errors gracefully
func loadWidget() {
    do {
        let widget = try WidgetLoader.load()
        // Use widget
    } catch {
        print("Failed to load widget: \(error)")
        // Show user-friendly error in UI
    }
}

// ❌ Bad - Force try in production code
let widget = try! WidgetLoader.load()
```

### Performance Guidelines

- **Lazy Loading**: Load widgets only when needed
- **Image Caching**: Cache SF Symbols and images
- **Debouncing**: Debounce rapid state changes
- **Main Thread**: Keep animations and UI updates on main thread
- **Background Work**: Move heavy computation to background queue

```swift
// ✅ Good - Background work
Task {
    let data = await fetchHeavyData() // Background
    await MainActor.run {
        self.displayData(data) // UI update on main
    }
}
```

## Widget Development Guidelines (Phase 2+)

### Creating a New Widget

1. **Create Widget File**
   ```swift
   // Widgets/CalendarWidget.swift
   import SwiftUI
   import EventKit

   struct CalendarWidget: AislandWidget {
       let id = UUID()
       let name = "Calendar"
       let icon = "calendar"
       @Published var isEnabled = true
       var position = 0

       var settingsView: AnyView {
           AnyView(CalendarSettingsView())
       }

       var contentView: AnyView {
           AnyView(CalendarContentView())
       }

       func onAppear() {
           // Request permissions, load data
       }

       func onDisappear() {
           // Pause updates
       }

       func refresh() {
           // Refresh data
       }
   }
   ```

2. **Register Widget**
   ```swift
   // WidgetManager.swift
   WidgetManager.shared.register(CalendarWidget())
   ```

3. **Add Tests**
   ```swift
   // Tests/CalendarWidgetTests.swift
   class CalendarWidgetTests: XCTestCase { }
   ```

## Questions?

- Check [ARCHITECTURE.md](ARCHITECTURE.md) for system design
- Check [DESIGN.md](DESIGN.md) for UI guidelines
- Check [ACTIONBOOK.md](ACTIONBOOK.md) for development roadmap
- Open a [GitHub Discussion](https://github.com/xWael9/Aisland/discussions)
- Create an [Issue](https://github.com/xWael9/Aisland/issues)

---

**Last Updated**: February 15, 2026
**Maintainers**: @xWael9, Claude Code
