import SwiftUI

// MARK: - Pastel Garden colour palette
// #C75F71  Deep Rose    — primary accent, vitals, key actions
// #F0B8B8  Blush Pink   — soft backgrounds, lab section, highlights
// #A2AE9D  Sage Green   — appointments, clinical sections
// #54463A  Dark Brown   — text, medical history, prescriptions

// MARK: - Open Sans font
// Font files required in bundle (add to Xcode project target):
//   OpenSans-Light.ttf, OpenSans-Regular.ttf, OpenSans-Italic.ttf,
//   OpenSans-SemiBold.ttf, OpenSans-Bold.ttf, OpenSans-ExtraBold.ttf
// Register in Info.plist under UIAppFonts array.

enum AppFont {
    enum Weight { case light, regular, semiBold, bold, extraBold }

    static func openSans(_ weight: Weight = .regular, size: CGFloat) -> SwiftUI.Font {
        let name: String
        switch weight {
        case .light:     name = "OpenSans-Light"
        case .regular:   name = "OpenSans-Regular"
        case .semiBold:  name = "OpenSans-SemiBold"
        case .bold:      name = "OpenSans-Bold"
        case .extraBold: name = "OpenSans-ExtraBold"
        }
        // Fallback to system rounded if font not yet loaded
        let custom = SwiftUI.Font.custom(name, size: size)
        return custom
    }
}

// MARK: - Pastel Garden colours

extension Color {
    /// #C75F71 — deep rose, primary accent
    static let rose        = Color(hex: "C75F71")
    /// #F0B8B8 — blush pink, soft backgrounds & highlights
    static let blush       = Color(hex: "F0B8B8")
    /// #A2AE9D — muted sage green, clinical/calm sections
    static let sage        = Color(hex: "A2AE9D")
    /// #54463A — warm dark brown, text & structural elements
    static let warmBrown   = Color(hex: "54463A")

    /// Very light blush — used as grouped background tint
    static let blushBackground = Color(hex: "FBF0F0")

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int & 0xFF0000) >> 16) / 255
        let g = Double((int & 0x00FF00) >> 8)  / 255
        let b = Double( int & 0x0000FF)         / 255
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Design System

enum AppTheme {

    // MARK: Typography — Open Sans, all sizes scalable with Dynamic Type
    enum Font {
        static let hero    = AppFont.openSans(.extraBold, size: 34)
        static let title   = AppFont.openSans(.bold,      size: 28)
        static let heading = AppFont.openSans(.semiBold,  size: 22)
        static let subhead = AppFont.openSans(.semiBold,  size: 18)
        static let body    = AppFont.openSans(.regular,   size: 17)
        static let label   = AppFont.openSans(.regular,   size: 15)
        static let caption = AppFont.openSans(.light,     size: 13)
    }

    // MARK: Spacing
    enum Spacing {
        static let xs: CGFloat  = 4
        static let sm: CGFloat  = 8
        static let md: CGFloat  = 16
        static let lg: CGFloat  = 24
        static let xl: CGFloat  = 32
        static let xxl: CGFloat = 48
    }

    // MARK: Corner radius
    enum Radius {
        static let sm: CGFloat = 10
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
    }

    // MARK: Minimum tap target height (accessibility)
    static let tapTargetHeight: CGFloat = 60

    // MARK: Section colours — all drawn from Pastel Garden palette
    enum Section {
        /// Vitals, primary actions → deep rose
        static let vitals:        Color = .rose
        /// Lab results → sage (calm, clinical)
        static let labs:          Color = .sage
        /// Doctor appointments → sage
        static let appointments:  Color = .sage
        /// Prescriptions → warm brown
        static let prescriptions: Color = .warmBrown
        /// Medical history → warm brown
        static let history:       Color = .warmBrown
        /// Vision → blush-tinted rose
        static let vision:        Color = Color(hex: "D4818A")   // rose lightened
        /// Hearing → sage darkened
        static let hearing:       Color = Color(hex: "7E9479")   // sage darkened
    }

    // MARK: Background tints
    enum Background {
        static let grouped  = Color.blushBackground
        static let card     = Color(.secondarySystemBackground)
        static let input    = Color(.tertiarySystemBackground)
    }
}

// MARK: - Large Primary Button

struct PrimaryButton: View {
    let title: String
    let icon: String?
    let color: Color
    let action: () -> Void

    init(_ title: String, icon: String? = nil, color: Color = .rose, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.color = color
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.sm) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                }
                Text(title)
                    .font(AppTheme.Font.subhead)
            }
            .frame(maxWidth: .infinity)
            .frame(height: AppTheme.tapTargetHeight)
            .background(color)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Section Card

struct SectionCard<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }

    var body: some View {
        content
            .padding(AppTheme.Spacing.md)
            .background(AppTheme.Background.card)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md))
    }
}

// MARK: - Coloured Icon Badge

struct IconBadge: View {
    let icon: String
    let color: Color
    var size: CGFloat = 44

    var body: some View {
        Image(systemName: icon)
            .font(.system(size: size * 0.48, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: size, height: size)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: size * 0.28))
    }
}

// MARK: - Status Pill

struct StatusPill: View {
    let label: String
    let color: Color

    var body: some View {
        Text(label)
            .font(AppTheme.Font.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }
}

// MARK: - Empty State

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let buttonTitle: String
    let action: () -> Void

    var body: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Spacer()
            Image(systemName: icon)
                .font(.system(size: 64))
                .foregroundStyle(Color.blush)

            VStack(spacing: AppTheme.Spacing.sm) {
                Text(title)
                    .font(AppTheme.Font.heading)
                    .foregroundStyle(Color.warmBrown)
                    .multilineTextAlignment(.center)
                Text(message)
                    .font(AppTheme.Font.body)
                    .foregroundStyle(Color.warmBrown.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.Spacing.xl)
            }

            PrimaryButton(buttonTitle, icon: "plus", action: action)
                .padding(.horizontal, AppTheme.Spacing.xl)

            Spacer()
        }
    }
}

// MARK: - Large Row Item

struct LargeListRow<Leading: View, Trailing: View>: View {
    let leading: Leading
    let title: String
    let subtitle: String
    let trailing: Trailing

    init(title: String, subtitle: String,
         @ViewBuilder leading: () -> Leading,
         @ViewBuilder trailing: () -> Trailing) {
        self.title = title
        self.subtitle = subtitle
        self.leading = leading()
        self.trailing = trailing()
    }

    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            leading
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppTheme.Font.subhead)
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(AppTheme.Font.label)
                        .foregroundStyle(Color.warmBrown.opacity(0.55))
                }
            }
            Spacer()
            trailing
        }
        .padding(.vertical, AppTheme.Spacing.sm)
        .frame(minHeight: AppTheme.tapTargetHeight)
        .contentShape(Rectangle())
    }
}

// MARK: - Voice Input Button

struct VoiceInputButton: View {
    let isRecording: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.sm) {
                Image(systemName: isRecording ? "waveform.circle.fill" : "mic.circle.fill")
                    .font(.system(size: 28))
                    .symbolEffect(.pulse, isActive: isRecording)
                Text(isRecording ? "Listening…" : "Speak to fill in")
                    .font(AppTheme.Font.body)
            }
            .foregroundStyle(isRecording ? Color.rose : Color.rose.opacity(0.8))
            .frame(maxWidth: .infinity)
            .frame(height: AppTheme.tapTargetHeight)
            .background(Color.blush.opacity(isRecording ? 0.35 : 0.18))
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Camera Capture Button

struct CameraCaptureButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.sm) {
                Image(systemName: "camera.fill")
                    .font(.system(size: 22))
                Text("Scan Document")
                    .font(AppTheme.Font.body)
            }
            .foregroundStyle(Color.warmBrown)
            .frame(maxWidth: .infinity)
            .frame(height: AppTheme.tapTargetHeight)
            .background(Color.sage.opacity(0.18))
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                    .stroke(Color.sage, lineWidth: 1.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Filter Chip (already used in LabResults, defined here centrally)

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.Font.label)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? Color.rose : AppTheme.Background.card)
                .foregroundStyle(isSelected ? .white : Color.warmBrown)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
