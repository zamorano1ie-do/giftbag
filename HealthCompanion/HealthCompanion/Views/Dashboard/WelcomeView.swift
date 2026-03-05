import SwiftUI

struct WelcomeView: View {
    @Binding var showAddMember: Bool

    var body: some View {
        VStack(spacing: AppTheme.Spacing.xl) {
            Spacer()

            Image(systemName: "heart.text.clipboard.fill")
                .font(.system(size: 90))
                .foregroundStyle(Color.rose)
                .symbolEffect(.bounce)

            VStack(spacing: AppTheme.Spacing.sm) {
                Text("Welcome to\nSláinte")
                    .font(AppTheme.Font.hero)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text("Your personal health record — all your health information in one safe place, ready when you need it.")
                    .font(AppTheme.Font.body)
                    .foregroundStyle(Color.warmBrown.opacity(0.65))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.Spacing.xl)
            }

            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                FeatureBullet(icon: "waveform.path.ecg", color: AppTheme.Section.vitals,
                              text: "Track blood pressure, weight, heart rate & more")
                FeatureBullet(icon: "drop.fill", color: AppTheme.Section.labs,
                              text: "Store blood test and lab results with reference ranges")
                FeatureBullet(icon: "pill.fill", color: AppTheme.Section.prescriptions,
                              text: "Track prescriptions and changes over time")
                FeatureBullet(icon: "stethoscope", color: AppTheme.Section.appointments,
                              text: "Log doctor visits and consultations")
                FeatureBullet(icon: "eye.fill", color: AppTheme.Section.vision,
                              text: "Record eye and hearing test results")
                FeatureBullet(icon: "person.2.fill", color: AppTheme.Section.history,
                              text: "Manage health records for the whole family")
            }
            .padding(AppTheme.Spacing.md)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md))
            .padding(.horizontal, AppTheme.Spacing.md)

            PrimaryButton("Get Started", icon: "arrow.right.circle.fill") {
                showAddMember = true
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
            .padding(.top, AppTheme.Spacing.sm)

            Spacer()
        }
        .background(AppTheme.Background.grouped)
    }
}

struct FeatureBullet: View {
    let icon: String
    let color: Color
    let text: String

    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            IconBadge(icon: icon, color: color, size: 36)
            Text(text)
                .font(AppTheme.Font.body)
        }
    }
}
