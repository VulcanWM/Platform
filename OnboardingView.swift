import SwiftUI

struct OnboardingView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("onboardingDone") var onboardingDone: Bool = false
    private let totalPages = 3
    
    private func finishOnboarding() {
        onboardingDone = true
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text("welcome to platform")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            Spacer()
            Button {
                finishOnboarding()
            } label: {
                Text("see the app work")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 50)
                            .fill(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.white)
                    )
                    .foregroundColor(colorScheme == .dark ? .white : .primary)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.05))
                    )
                    .shadow(color: colorScheme == .dark ? Color.black.opacity(0.2) : Color.black.opacity(0.04), radius: 6, y: 2)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    let horizontalAmount = value.translation.width
                    if horizontalAmount < -50 {
                        finishOnboarding()
                    }
                }
        )
        .background(colorScheme == .dark ? Color(red: 18/255, green: 18/255, blue: 18/255) : Color(red: 0.98, green: 0.95, blue: 0.90))
    }
}
