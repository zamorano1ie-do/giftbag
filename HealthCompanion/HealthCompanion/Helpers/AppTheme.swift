import SwiftUI

// MARK: - Accessibility-first design system
// Large text, high contrast, generous tap targets (min 60pt height)

enum AppTheme {
    // MARK: Typography — all sizes scalable with Dynamic Type
    enum Font {
        static let hero     = SwiftUI.Font.system(size: 34, weight: .bold, design: .rounded)
        static let title    = SwiftUI.Font.system(size: 28, weight: .bold, design: .rounded)
        static let heading  = SwiftUI.Font.system(size: 22, weight: .semibold, design: .rounded)
        static let subhead  = SwiftUI.Font.system(size: 18, weight: .medium, design: .rounded)
        static let body     = SwiftUI.Font.system(size: 17, weight: .regular, design: .rounded)
        static let label    = SwiftUI.Font.system(size: 15, weight: .regular, design: .rounded)
        static let caption  = SwiftUI.Font.system(size: 13, weight: .regular, design: .rounded)
    }

    // MARK: Spacing
    enum Spacing {
        static let xs: CGFloat   = 4
        static let sm: CGFloat   = 8
        static let md: CGFloat   = 16
        static let lg: CGFloat   = 24
        static let xl: CGFloat   = 32
        static let xxl: CGFloat  = 48
    }

    // MARK: Corner radius
    enum Radius {
        static let sm: CGFloat  = 10
        static let md: CGFloat  = 16
        static let lg: CGFloat  = 24
    }

    // MARK: Minimum tap target height
    static let tapTargetHeight: CGFloat = 60

    // MARK: Section colours (used as tint + card background)
    enum Section {
        static let vitals:       Color = Color(red: 0.93, green: 0.23, blue: 0.38)  // rose
        static let labs:         Color = Color(red: 0.20, green: 0.55, blue: 0.93)  // blue
        static let appointments: Color = Color(red: 0.20, green: 0.70, blue: 0.50)  // teal
        static let prescriptions: Color = Color(red: 0.58, green: 0.35, blue: 0.90) // purple
        static let history:      Color = Color(red: 0.95, green: 0.55, blue: 0.18)  // orange
        static let vision:       Color = Color(red: 0.12, green: 0.65, blue: 0.80)  // cyan
        static let hearing:      Color = Color(red: 0.88, green: 0.42, blue: 0.18)  // amber
    }
}

// MARK: - Large Primary Button

struct PrimaryButton: View {
    let title: String
    let icon: String?
    let color: Color
    let action: () -> Void

    init(_ title: String, icon: String? = nil, color: Color = .accentColor, action: @escaping () -> Void) {
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
                    .fontWeight(.semibold)
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

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(AppTheme.Spacing.md)
            .background(Color(.secondarySystemBackground))
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
                .foregroundStyle(.secondary)

            VStack(spacing: AppTheme.Spacing.sm) {
                Text(title)
                    .font(AppTheme.Font.heading)
                    .multilineTextAlignment(.center)
                Text(message)
                    .font(AppTheme.Font.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.Spacing.xl)
            }

            PrimaryButton(buttonTitle, icon: "plus", action: action)
                .padding(.horizontal, AppTheme.Spacing.xl)

            Spacer()
        }
    }
}

// MARK: - Large Row Item (used in lists — tall tap target)

struct LargeListRow<Leading: View, Trailing: View>: View {
    let leading: Leading
    let title: String
    let subtitle: String
    let trailing: Trailing

    init(title: String, subtitle: String, @ViewBuilder leading: () -> Leading, @ViewBuilder trailing: () -> Trailing) {
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
                    .fontWeight(.semibold)
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(AppTheme.Font.label)
                        .foregroundStyle(.secondary)
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
            .foregroundStyle(isRecording ? Color.red : Color.accentColor)
            .frame(maxWidth: .infinity)
            .frame(height: AppTheme.tapTargetHeight)
            .background((isRecording ? Color.red : Color.accentColor).opacity(0.1))
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
                Text("Take a Photo")
                    .font(AppTheme.Font.body)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: AppTheme.tapTargetHeight)
            .background(Color.secondary)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md))
        }
        .buttonStyle(.plain)
    }
}
