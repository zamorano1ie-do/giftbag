import SwiftUI

struct WelcomeView: View {
    @Binding var showAddMember: Bool

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: min(AppTheme.Spacing.xl, geometry.size.height * 0.05)) {
                Spacer(minLength: geometry.size.height * 0.05)
                
                Image(systemName: "heart.text.clipboard.fill")
                    .font(.system(size: min(90, geometry.size.height * 0.15)))
                    .foregroundStyle(Color.rose)
                    .symbolEffect(.bounce)

                VStack(spacing: min(AppTheme.Spacing.sm, geometry.size.height * 0.02)) {
                    Text("Welcome to\nSláinte")
                        .font(geometry.size.height < 600 ? AppTheme.Font.title : AppTheme.Font.hero)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.5)

                    Text("Your personal health record — all your health information in one safe place, ready when you need it.")
                        .font(AppTheme.Font.body)
                        .foregroundStyle(Color.warmBrown.opacity(0.65))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppTheme.Spacing.xl)
                        .minimumScaleFactor(0.7)
                }

                VStack(alignment: .leading, spacing: min(AppTheme.Spacing.md, geometry.size.height * 0.02)) {
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
                .padding(min(AppTheme.Spacing.md, geometry.size.height * 0.02))
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md))
                .padding(.horizontal, AppTheme.Spacing.md)
                
                Spacer(minLength: geometry.size.height * 0.05)

                PrimaryButton("Get Started", icon: "arrow.right.circle.fill") {
                    showAddMember = true
                }
                .padding(.horizontal, AppTheme.Spacing.xl)
                
                Spacer(minLength: geometry.size.height * 0.05)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
