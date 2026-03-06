import SwiftUI

struct OnboardingPage: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
}

struct WelcomeView: View {
    @Binding var showAddMember: Bool
    @State private var currentPage = 0

    let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Welcome to\nSláinte",
            subtitle: "Your personal health record — all your health information in one safe place, ready when you need it.",
            icon: "heart.text.clipboard.fill",
            color: Color.rose
        ),
        OnboardingPage(
            title: "Track Your Vitals",
            subtitle: "Keep a close eye on your blood pressure, weight, heart rate, and more over time.",
            icon: "waveform.path.ecg",
            color: AppTheme.Section.vitals
        ),
        OnboardingPage(
            title: "Manage Records",
            subtitle: "Store your blood test and lab results. Safely track all your prescriptions in one spot.",
            icon: "drop.fill",
            color: AppTheme.Section.labs
        ),
        OnboardingPage(
            title: "Appointments\n& History",
            subtitle: "Log your doctor visits, eye tests, and hearing checks. Manage it all for the whole family.",
            icon: "stethoscope",
            color: AppTheme.Section.appointments
        )
    ]

    var body: some View {
        VStack {
            // Top Navigation Bar
            HStack {
                Spacer()
                if currentPage < pages.count - 1 {
                    Button(action: {
                        withAnimation {
                            currentPage = pages.count - 1
                        }
                    }) {
                        Text("Skip")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                } else {
                    // Invisible placeholder to keep spacing consistent
                    Text("Skip")
                        .font(.subheadline)
                        .opacity(0)
                        .padding()
                }
            }

            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    OnboardingPageView(page: pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))

            // Bottom Navigation Bar
            VStack {
                if currentPage < pages.count - 1 {
                    PrimaryButton("Next", icon: "arrow.right") {
                        withAnimation {
                            currentPage += 1
                        }
                    }
                } else {
                    PrimaryButton("Get Started", icon: "checkmark.circle.fill") {
                        showAddMember = true
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
            .padding(.bottom, AppTheme.Spacing.xxl)
            .padding(.top, AppTheme.Spacing.md)
        }
        .background(AppTheme.Background.grouped)
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: AppTheme.Spacing.xl) {
                Spacer()
                
                Image(systemName: page.icon)
                    .font(.system(size: min(120, geometry.size.height * 0.2)))
                    .foregroundStyle(page.color)
                    .symbolEffect(.bounce, options: .nonRepeating)
                
                VStack(spacing: AppTheme.Spacing.md) {
                    Text(page.title)
                        .font(AppTheme.Font.hero)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.5)
                    
                    Text(page.subtitle)
                        .font(AppTheme.Font.body)
                        .foregroundStyle(Color.warmBrown.opacity(0.65))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppTheme.Spacing.xl)
                        .minimumScaleFactor(0.7)
                }
                
                Spacer()
                Spacer() // Extra spacer to push content up slightly for page dots
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
    }
}
