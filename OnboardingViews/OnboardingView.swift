import SwiftUI

struct OnboardingView: View {
    @AppStorage("onboardingPage") var onboardingPage: Int = 1
    var body: some View {
        if (onboardingPage == 1){
            Onboarding1View()
        } else if (onboardingPage == 2) {
            Onboarding2View()
        } else {
            Onboarding3View()
        }
    }
}

// MARK: - Page Indicator Component
struct PageIndicator: View {
    let currentPage: Int
    let totalPages: Int
    var activeColor: Color = .orange
    var inactiveColor: Color = Color.gray.opacity(0.3)
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...totalPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? activeColor : inactiveColor)
                    .frame(width: 10, height: 10)
            }
        }
    }
}
