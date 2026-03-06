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
            title: "Welcome to Sláinte",
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
            title: "Appointments & History",
            subtitle: "Log your doctor visits, eye tests, and hearing checks. Manage it all for the whole family.",
            icon: "stethoscope",
            color: AppTheme.Section.appointments
        )
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Top Navigation Bar
            HStack {
                Spacer()
                Button(action: {
                    withAnimation(.spring()) {
                        currentPage = pages.count - 1
                    }
                }) {
                    Text("Skip")
                        .font(AppTheme.Font.subhead)
                        .foregroundStyle(Color.warmBrown.opacity(currentPage < pages.count - 1 ? 0.6 : 0.0))
                }
                .disabled(currentPage >= pages.count - 1)
                .padding(.horizontal, AppTheme.Spacing.lg)
                .padding(.top, AppTheme.Spacing.md)
            }

            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    OnboardingPageView(page: pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            // Bottom Navigation & Custom Paginator
            VStack(spacing: AppTheme.Spacing.xl) {
                // Custom Paging Dots
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Capsule()
                            .fill(currentPage == index ? Color.rose : Color.rose.opacity(0.2))
                            .frame(width: currentPage == index ? 24 : 8, height: 8)
                            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: currentPage)
                    }
                }
                
                // Action Button
                if currentPage < pages.count - 1 {
                    PrimaryButton("Continue", icon: "arrow.right") {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
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
        .background(AppTheme.Background.main.ignoresSafeArea())
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: AppTheme.Spacing.xl) {
            Spacer()
            
            // Premium Icon Badge with Concentric Circles
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.1))
                    .frame(width: 200, height: 200)
                
                Circle()
                    .fill(page.color.opacity(0.2))
                    .frame(width: 140, height: 140)
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 90, height: 90)
                    .shadow(color: page.color.opacity(0.15), radius: 15, x: 0, y: 8)

                Image(systemName: page.icon)
                    .font(.system(size: 44, weight: .semibold))
                    .foregroundStyle(page.color)
                    .symbolEffect(.bounce, options: .nonRepeating)
            }
            .padding(.bottom, AppTheme.Spacing.md)
            
            // Text Content
            VStack(spacing: AppTheme.Spacing.md) {
                Text(page.title)
                    .font(AppTheme.Font.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.warmBrown)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.8)
                
                Text(page.subtitle)
                    .font(AppTheme.Font.body)
                    .foregroundStyle(Color.warmBrown.opacity(0.65))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    .minimumScaleFactor(0.8)
            }
            
            Spacer()
            Spacer() // Extra spacer to balance the layout visually
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
