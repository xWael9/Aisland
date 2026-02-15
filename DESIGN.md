# Aisland Design System

## Overview
Aisland follows macOS Big Sur+ native design language, emphasizing depth, clarity, and seamless integration with the system appearance. The design adapts intelligently to light/dark modes and provides a polished, professional experience.

---

## Color Scheme

### Semantic Colors (Auto-Adaptive)
All colors automatically adapt to system appearance (light/dark mode).

#### Primary Colors
```swift
// Background Colors
.background           // System background (dynamic)
.secondaryBackground  // System secondary background
.tertiaryBackground   // System tertiary background

// Accent Colors
.accentColor          // System accent color (user-customizable)
.blue                 // Primary action color
.green                // Success states
.orange               // Warning states
.red                  // Error/destructive actions

// Text Colors
.primary              // Primary text (high contrast)
.secondary            // Secondary text (medium contrast)
.tertiary             // Tertiary text (low contrast)
.quaternary           // Placeholder/disabled text
```

#### Widget-Specific Colors
```swift
// Widget Card Background
Color(.controlBackgroundColor)
  .opacity(0.85)

// Widget Card Border
Color.white.opacity(0.1) // Dark mode
Color.black.opacity(0.05) // Light mode

// Hover State
Color.accentColor.opacity(0.1)

// Active/Selected State
Color.accentColor.opacity(0.2)
```

#### Material Effects
```swift
// Background Blur
.ultraThinMaterial     // Notch collapsed state
.regularMaterial       // Widget cards
.thickMaterial         // Modal overlays

// Vibrancy
.vibrancy(.sidebar)    // Sidebar elements
.vibrancy(.label)      // Text labels
.vibrancy(.separator)  // Dividers
```

---

## Typography System

### Font Family
**SF Pro** - Apple's system font (auto-included in macOS)

### Type Scale
```swift
// Display
.largeTitle    // 34pt regular - Page titles
.title         // 28pt regular - Section headers
.title2        // 22pt regular - Subsection headers
.title3        // 20pt regular - Group headers

// Body
.headline      // 17pt semibold - Widget titles
.body          // 17pt regular - Primary content
.callout       // 16pt regular - Secondary content
.subheadline   // 15pt regular - Labels
.footnote      // 13pt regular - Captions
.caption       // 12pt regular - Timestamps
.caption2      // 11pt regular - Fine print

// Custom
Font.system(size: 15, weight: .medium, design: .rounded) // Widget metrics
```

### Font Weights
```swift
.ultraLight    // 100
.thin          // 200
.light         // 300
.regular       // 400 (default)
.medium        // 500
.semibold      // 600 (emphasis)
.bold          // 700 (strong emphasis)
.heavy         // 800
.black         // 900
```

### Dynamic Type Support
All text should support Dynamic Type for accessibility:
```swift
Text("Widget Title")
  .font(.headline)
  .dynamicTypeSize(.medium...(.xxLarge)) // Constrain range if needed
```

---

## Layout Grid

### Spacing System
```swift
// Base unit: 4pt
let spacing2: CGFloat = 2    // Tight spacing
let spacing4: CGFloat = 4    // Extra small
let spacing8: CGFloat = 8    // Small
let spacing12: CGFloat = 12  // Medium-small
let spacing16: CGFloat = 16  // Medium (default)
let spacing20: CGFloat = 20  // Medium-large
let spacing24: CGFloat = 24  // Large
let spacing32: CGFloat = 32  // Extra large
let spacing48: CGFloat = 48  // XXL
```

### Widget Grid Layout
```swift
// Grid Configuration
LazyVGrid(
  columns: [
    GridItem(.adaptive(minimum: 180, maximum: 240), spacing: 16)
  ],
  spacing: 16
)

// Dimensions
let notchCollapsedWidth: CGFloat = 200
let notchCollapsedHeight: CGFloat = 32

let notchExpandedWidth: CGFloat = 780
let notchExpandedHeight: CGFloat = 480

let widgetCardMinWidth: CGFloat = 180
let widgetCardMaxWidth: CGFloat = 240
let widgetCardHeight: CGFloat = 140

// Corner Radius
let cornerRadiusSmall: CGFloat = 8
let cornerRadiusMedium: CGFloat = 12
let cornerRadiusLarge: CGFloat = 16
let cornerRadiusNotch: CGFloat = 20
```

### Padding Standards
```swift
// Component Padding
.padding(.horizontal, 16)  // Card horizontal
.padding(.vertical, 12)    // Card vertical
.padding(20)               // Container default
.padding(.top, 32)         // Top-level views
```

---

## Animation System

### Timing Functions
```swift
// Easing Curves
.easeIn        // Acceleration
.easeOut       // Deceleration (most common)
.easeInOut     // Smooth acceleration/deceleration
.linear        // Constant speed

// Spring Animations (Preferred)
.spring(
  response: 0.3,      // Duration feel (0.2-0.6)
  dampingFraction: 0.7, // Bounciness (0.6-1.0)
  blendDuration: 0
)

// Custom Spring Presets
static let snappy = Animation.spring(response: 0.3, dampingFraction: 0.8)
static let bouncy = Animation.spring(response: 0.4, dampingFraction: 0.6)
static let smooth = Animation.spring(response: 0.5, dampingFraction: 0.9)
```

### Animation Timings
```swift
// Duration Standards
let durationFast: Double = 0.15      // Quick feedback
let durationDefault: Double = 0.25   // Standard transitions
let durationMedium: Double = 0.35    // Emphasized transitions
let durationSlow: Double = 0.5       // Dramatic reveals

// Delays
let hoverDelay: Double = 0.3         // Hover activation delay
let tooltipDelay: Double = 0.8       // Tooltip appearance
```

### Common Animations
```swift
// Fade In/Out
.opacity(isVisible ? 1 : 0)
.animation(.easeOut(duration: 0.25), value: isVisible)

// Scale Transform
.scaleEffect(isHovered ? 1.05 : 1.0)
.animation(.snappy, value: isHovered)

// Slide In/Out
.offset(y: isExpanded ? 0 : -50)
.opacity(isExpanded ? 1 : 0)
.animation(.spring(response: 0.4, dampingFraction: 0.8), value: isExpanded)

// Rotation
.rotationEffect(.degrees(isActive ? 180 : 0))
.animation(.easeInOut(duration: 0.3), value: isActive)
```

---

## Notch UI States

### State 1: Collapsed (Idle)
```
┌────────────────────┐
│   ···  Aisland  ●  │  32pt height
└────────────────────┘
200pt width

- Ultra-thin material background
- Centered text with icon
- Subtle pulse animation on app logo
- Low visual weight
```

### State 2: Hover Preview
```
┌────────────────────┐
│   ···  Aisland  ●  │  32pt → 36pt
└────────────────────┘
200pt → 220pt (scale 1.05)

- Slight scale up (1.05x)
- Increased shadow
- Accent color glow
- Cursor: pointer
```

### State 3: Expanded (Active)
```
┌──────────────────────────────────┐
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐    │
│  │Wgt1│ │Wgt2│ │Wgt3│ │Wgt4│    │  480pt height
│  └────┘ └────┘ └────┘ └────┘    │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐    │
│  │Wgt5│ │Wgt6│ │Wgt7│ │Wgt8│    │
│  └────┘ └────┘ └────┘ └────┘    │
└──────────────────────────────────┘
780pt width

- Regular material background
- Widget grid layout
- Smooth spring animation (0.4s)
- Blur intensifies
```

### State Transitions
```swift
// Collapsed → Hover
withAnimation(.spring(response: 0.2, dampingFraction: 0.8)) {
  scale = 1.05
  shadowRadius = 15
}

// Hover → Expanded
withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
  width = 780
  height = 480
  cornerRadius = 20
}

// Expanded → Collapsed
withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
  width = 200
  height = 32
  cornerRadius = 16
}
```

---

## Widget Card Design

### Anatomy
```
┌─────────────────────┐
│ 󰃰 Widget Title    ⚙️ │  Header (40pt)
├─────────────────────┤
│                     │
│   Primary Content   │  Content (80pt)
│                     │
├─────────────────────┤
│ Footer Info         │  Footer (20pt)
└─────────────────────┘
180-240pt wide × 140pt tall
```

### Visual Properties
```swift
// Background
.background(.regularMaterial)
.background(Color(.controlBackgroundColor).opacity(0.85))

// Border
.overlay(
  RoundedRectangle(cornerRadius: 12)
    .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
)

// Shadow
.shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)

// Hover State
.shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 6)
.scaleEffect(1.02)
```

### Interaction States
```swift
// Default
opacity: 1.0
scale: 1.0
shadow: 10pt radius

// Hover
opacity: 1.0
scale: 1.02
shadow: 15pt radius
cursor: pointer

// Active/Pressed
opacity: 0.9
scale: 0.98
shadow: 5pt radius

// Disabled
opacity: 0.5
scale: 1.0
cursor: not-allowed
```

### Content Guidelines
- **Icon**: 24×24pt SF Symbol at top-left
- **Title**: Headline font, single line, truncate with ellipsis
- **Settings**: Gear icon button (16×16pt) at top-right
- **Content**: Custom per widget, centered
- **Footer**: Caption font, metadata (e.g., "Updated 2m ago")

---

## Blur & Vibrancy Effects

### Material Types
```swift
// Background Materials (Ordered by thickness)
.ultraThinMaterial      // Minimal blur, maximum transparency
.thinMaterial           // Light blur
.regularMaterial        // Standard blur (default)
.thickMaterial          // Heavy blur
.ultraThickMaterial     // Maximum blur
```

### Usage Guidelines
```swift
// Notch Collapsed
.background(.ultraThinMaterial)

// Widget Cards
.background(.regularMaterial)

// Modal Overlays
.background(.ultraThickMaterial)

// Sidebar/Toolbars
.background(.thinMaterial)
```

### Vibrancy Labels
```swift
// For text on materials
Text("Label")
  .foregroundStyle(.primary)  // Auto-vibrant

// For icons
Image(systemName: "calendar")
  .foregroundStyle(.secondary)  // Subtle vibrancy

// For separators
Divider()
  .background(.separator)  // Vibrant divider
```

### Custom Blur Effects (AppKit Integration)
```swift
// NSVisualEffectView wrapper for advanced effects
struct BlurView: NSViewRepresentable {
  var material: NSVisualEffectView.Material
  var blendingMode: NSVisualEffectView.BlendingMode

  func makeNSView(context: Context) -> NSVisualEffectView {
    let view = NSVisualEffectView()
    view.material = material
    view.blendingMode = blendingMode
    view.state = .active
    return view
  }

  func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}

// Usage
BlurView(material: .hudWindow, blendingMode: .behindWindow)
```

---

## Icon System

### SF Symbols
All icons use SF Symbols for consistency and automatic weight/size adaptation.

#### Common Icons
```swift
// Widget Types
"calendar"           // Calendar widget
"music.note"         // Media widget
"square.grid.2x2"    // Quick apps
"note.text"          // Notes
"camera.fill"        // Camera mirror
"shortcuts"          // Shortcuts
"antenna.radiowaves.left.and.right" // Bluetooth

// Actions
"gear"               // Settings
"xmark"              // Close/dismiss
"plus"               // Add
"minus"              // Remove
"chevron.down"       // Expand
"chevron.up"         // Collapse
"ellipsis"           // More options

// Status
"checkmark.circle.fill"  // Success
"exclamationmark.triangle.fill"  // Warning
"xmark.circle.fill"      // Error
"info.circle"            // Information
```

#### Icon Sizing
```swift
// Sizes
.iconSmall: 12pt     // Inline indicators
.iconMedium: 16pt    // Buttons, secondary
.iconLarge: 24pt     // Widget headers
.iconXL: 32pt        // Hero icons

// Usage
Image(systemName: "calendar")
  .font(.system(size: 24, weight: .medium))
  .foregroundStyle(.blue)
```

#### Icon Rendering Modes
```swift
// Monochrome
.symbolRenderingMode(.monochrome)

// Hierarchical (single color, variable opacity)
.symbolRenderingMode(.hierarchical)

// Palette (multi-color custom)
.symbolRenderingMode(.palette)
.foregroundStyle(.blue, .cyan)

// Multicolor (pre-defined colors)
.symbolRenderingMode(.multicolor)
```

---

## Shadows & Depth

### Shadow Levels
```swift
// Level 0: Flat (no shadow)
.shadow(radius: 0)

// Level 1: Subtle
.shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)

// Level 2: Medium (default cards)
.shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)

// Level 3: Elevated (hover states)
.shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 6)

// Level 4: Floating (modals)
.shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
```

### Dark Mode Adjustments
```swift
// Shadows are automatically lighter in dark mode
@Environment(\.colorScheme) var colorScheme

var shadowOpacity: Double {
  colorScheme == .dark ? 0.3 : 0.1
}

.shadow(color: .black.opacity(shadowOpacity), radius: 10, x: 0, y: 4)
```

---

## Accessibility

### VoiceOver Support
```swift
// Meaningful labels
.accessibilityLabel("Calendar Widget")
.accessibilityHint("Shows upcoming events")

// Action descriptions
Button("Settings") { }
  .accessibilityLabel("Open widget settings")

// Value announcements
.accessibilityValue("3 events today")

// Grouping
.accessibilityElement(children: .combine)
```

### Keyboard Navigation
```swift
// Focus management
@FocusState private var focusedWidget: UUID?

// Tab order
.focusable(true)
.onKeyPress(.tab) { /* handle */ }

// Action shortcuts
.keyboardShortcut("w", modifiers: [.command, .shift]) // Toggle widget
```

### Dynamic Type
```swift
// Respect system text size
Text("Widget Title")
  .font(.headline)
  // Auto-scales with system settings

// Constrain if needed
.dynamicTypeSize(.medium...(.xxLarge))
```

### Color Contrast
All color combinations meet WCAG AA standards (4.5:1 for text, 3:1 for UI components).

```swift
// High contrast mode detection
@Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor

if differentiateWithoutColor {
  // Use shapes/borders instead of color alone
}
```

### Reduced Motion
```swift
@Environment(\.accessibilityReduceMotion) var reduceMotion

withAnimation(reduceMotion ? nil : .spring()) {
  // Animation only if not reduced
}
```

---

## Performance Guidelines

### 60fps Animation Target
```swift
// Use GPU-accelerated properties
.opacity()      // ✓ GPU
.scaleEffect()  // ✓ GPU
.offset()       // ✓ GPU
.rotationEffect() // ✓ GPU

// Avoid CPU-heavy properties in animations
.frame()        // ✗ CPU (use scaleEffect instead)
.padding()      // ✗ CPU (animate offset instead)
```

### Lazy Loading
```swift
// Use LazyVGrid for widget grid
LazyVGrid(columns: columns, spacing: 16) {
  ForEach(widgets) { widget in
    WidgetCardView(widget: widget)
  }
}

// Lazy image loading
AsyncImage(url: imageURL) { image in
  image.resizable()
} placeholder: {
  ProgressView()
}
```

### View Caching
```swift
// Cache expensive views
@State private var cachedView: AnyView?

var body: some View {
  if let cached = cachedView {
    cached
  } else {
    ExpensiveView()
      .onAppear {
        cachedView = AnyView(ExpensiveView())
      }
  }
}
```

---

## Design Checklist

### Before Committing UI Code
- [ ] Supports light AND dark mode
- [ ] Uses semantic colors (no hardcoded hex)
- [ ] SF Symbols for all icons
- [ ] Native materials for backgrounds
- [ ] Smooth spring animations (not linear)
- [ ] VoiceOver labels added
- [ ] Keyboard navigation supported
- [ ] Dynamic Type compatible
- [ ] Respects reduced motion
- [ ] 60fps performance verified
- [ ] Hover states implemented
- [ ] Focus states visible
- [ ] Error states designed
- [ ] Loading states designed
- [ ] Empty states designed

---

## Design Resources

### Apple HIG
- [macOS Design Principles](https://developer.apple.com/design/human-interface-guidelines/macos)
- [SF Symbols Browser](https://developer.apple.com/sf-symbols/)
- [Apple Design Resources](https://developer.apple.com/design/resources/)

### Figma Templates
- macOS Big Sur UI Kit
- SF Symbols Library

### Tools
- SF Symbols App (built into macOS)
- Xcode Previews for rapid iteration
- Accessibility Inspector

---

**Last Updated**: February 15, 2026
**Design Lead**: Claude Frontend Expert
**Version**: 1.0
