import SwiftUI

struct ContentView: View {
    @AppStorage("onboardingDone") var onboardingDone: Bool = false
    var body: some View {
        NavigationStack {
            if (onboardingDone) {
                BreatheView()
            } else {
                OnboardingView()
            }
        }
    }
}
