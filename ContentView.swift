import SwiftUI

struct ContentView: View {
    @AppStorage("onboardingPage") var onboardingPage: Int = 1
    var body: some View {
        NavigationStack {
            if (onboardingPage < 4) {
                OnboardingView()
            } else {
                BreatheView()
            }
        }
    }
}
