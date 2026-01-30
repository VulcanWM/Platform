import SwiftUI

struct BreatheBar: View {
    let size: CGFloat
    let thickness: CGFloat = 10
    let count: Int
    let introTip: Int

    var sizeOfBreathe: CGFloat {
        min(CGFloat(count) / 40 * size, size)
    }
    
    @Environment(\.colorScheme) var colorScheme

    var trackColour: Color {
        colorScheme == .dark
        ? Color(.darkGray)
        : Color(red: 0.88, green: 0.86, blue: 0.83)
    }

    var fillColour: Color {
        colorScheme == .dark
        ? Color.orange.opacity(0.9)
        : Color(red: 0.95, green: 0.55, blue: 0.25)
    }

    var highlightColour: Color {
        colorScheme == .dark
        ? Color.white
        : Color.black
    }

    var body: some View {
        ZStack {
            Capsule()
                .stroke(
                    introTip == 2 ? highlightColour : .clear,
                    lineWidth: 6
                )
                .frame(width: thickness + 14, height: size + 14)
                .offset(x: (size / 2 + thickness / 2) + 20)
                .shadow(
                    color: introTip == 2 ? highlightColour.opacity(0.5) : .clear,
                    radius: 16
                )
                .animation(.easeInOut(duration: 0.3), value: introTip)

            Capsule()
                .fill(trackColour)
                .frame(width: thickness, height: size)
                .offset(x: (size / 2 + thickness / 2) + 20)
            
            Capsule()
                .fill(fillColour)
                .frame(width: thickness, height: sizeOfBreathe)
                .offset(
                    x: (size / 2 + thickness / 2) + 20,
                    y: (size - sizeOfBreathe) / 2
                )
                .animation(.easeInOut(duration: 0.15), value: sizeOfBreathe)
        }
    }
}


struct HoldButton: ButtonStyle {
    let size: CGFloat
    let introTip: Int
    @Environment(\.colorScheme) var colorScheme
    
    var highlightColour: Color {
        colorScheme == .dark
        ? Color.white
        : Color.black
    }

    func makeBody(configuration: Configuration) -> some View {
        let gradientColors = colorScheme == .dark ?
            [Color.orange.opacity(0.8), Color.orange.opacity(0.6)] :
            [Color(red: 0.96, green: 0.6, blue: 0.3),
             Color(red: 0.92, green: 0.5, blue: 0.2)]

        configuration.label
            .frame(width: size, height: size)
            .background(
                LinearGradient(
                    colors: gradientColors,
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .foregroundStyle(.white)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(introTip == 1 ? highlightColour : Color.clear, lineWidth: 6)
                    .animation(.easeInOut(duration: 0.3), value: introTip)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .shadow(color: colorScheme == .dark ? Color.black.opacity(0.5) : Color.black.opacity(0.3), radius: 12, y: 6)
            .opacity(configuration.isPressed ? 0.9 : 1)
    }
}

struct BreatheView: View {
    @State private var isPressed = false
    @State private var tapStatus = "hold to breathe"
    @State private var counter = 0
    @State private var timer: Timer?
    @State private var breatheOut = true
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("onboardingDone") var onboardingDone: Bool = false
    @AppStorage("introTip") var introTip: Int = 1
    
    var highlightColour: Color {
        colorScheme == .dark
        ? Color.white
        : Color.black
    }
    
    private func backToOnboarding() {
        onboardingDone = false
        introTip = 1
    }

    var body: some View {
        GeometryReader { geo in
            let buttonSize = geo.size.width * 0.7
            
            ZStack {
                VStack {
                    Text("just breathe")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(colorScheme == .dark ? .white : .primary)

                    Text("you've got this")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(colorScheme == .dark ? .white.opacity(0.7) : .secondary)
                }
                .padding(.top, 60)
                .frame(maxHeight: .infinity, alignment: .top)

                VStack(spacing: 16) {
                    ZStack {
                        BreatheBar(
                            size: buttonSize,
                            count: counter,
                            introTip: introTip
                        )
                        
                        Button {
                            tapStatus = "finished breathing"
                            isPressed = false
                            timer?.invalidate()
                            breatheOut = true
                            if (counter > 40) {
                                counter = 40
                            }
                            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                                DispatchQueue.main.async {
                                    if (counter == 0){
                                        timer?.invalidate()
                                    } else {
                                        counter -= 1
                                        if (counter == 0 && introTip == 2){
                                            introTip = 3
                                        }
                                    }
                                }
                            }
                            RunLoop.main.add(timer!, forMode: .common)
                        } label: {
                            Text((breatheOut == false && counter > 40) || (breatheOut && counter != 0) ? "let go" : "hold")
                                .font(.system(size: buttonSize * 0.25, weight: .bold))
                        }
                        .buttonStyle(HoldButton(size: buttonSize, introTip: introTip))
                        .simultaneousGesture(
                            LongPressGesture(minimumDuration: 0.1)
                                .onEnded { _ in
                                    tapStatus = "holding down"
                                    isPressed = true
                                    breatheOut = false
                                    timer?.invalidate()
                                    timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                                        DispatchQueue.main.async {
                                            counter += 1
                                        }
                                    }
                                    if introTip == 1 {
                                        introTip = 2
                                    }
                                    RunLoop.main.add(timer!, forMode: .common)
                                }
                        )
                    }

                    Text(counter > 0 ? "\(min(counter / 10 + 1, 5))" : "0")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(colorScheme == .dark ? .white : .secondary)
                        .opacity(counter / 10 >= 4 ? 0.8 : 1)

                    Text((!breatheOut && counter > 40) || (breatheOut && counter != 0) ? "breathe out" : "breathe in while holding the button")
                        .font(.callout)
                        .foregroundColor(colorScheme == .dark ? .white.opacity(0.7) : .secondary)
                        .padding(.top, 4)
                }
                .frame(maxHeight: .infinity, alignment: .center)

                VStack {
                    Spacer()
                    NavigationLink {
                        TipsView()
                    } label: {
                        Text("want some other tips?")
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
                                    .stroke(introTip == 3 ? highlightColour : (colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.05)), lineWidth: 3)
                            )
                            .shadow(color: colorScheme == .dark ? Color.black.opacity(0.2) : Color.black.opacity(0.04), radius: 6, y: 2)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
            .overlay(alignment: .topTrailing) {
                Button(action: backToOnboarding) {
                    Image(systemName: "questionmark.circle.fill")
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundColor(.orange)
                        .padding(10)
                        .background(
                            .ultraThinMaterial,
                            in: Circle()
                        )
                        .shadow(
                            color: colorScheme == .dark
                            ? Color.black.opacity(0.2)
                            : Color.black.opacity(0.08),
                            radius: 6,
                            y: 3
                        )
                }
                .contentShape(Rectangle())
                .padding(.top, 8)
                .padding(.trailing, 16)
            }
            .overlay {
                if introTip <= 3 {
                    SpeechBubble(
                        text: introText(for: introTip),
                        arrowDown: true,
                        arrowOnRight: introTip == 2
                    )
                    .frame(maxWidth: 260)
                    .position(bubblePosition(for: introTip, geo: geo))
                    .transition(.opacity.combined(with: .scale))
                    .animation(.easeInOut(duration: 0.3), value: introTip)
                }
            }

        }
        .navigationBarBackButtonHidden(true)
        .background(colorScheme == .dark ? Color(red: 18/255, green: 18/255, blue: 18/255) : Color(red: 0.98, green: 0.95, blue: 0.90))
    }
}

