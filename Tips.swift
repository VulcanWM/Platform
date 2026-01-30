import SwiftUI

struct Tip: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let body: String
}

struct TipsView: View {
    @State private var selectedTip: Tip?
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("introTip") var introTip: Int = 1

    let tips: [Tip] = [
        Tip(
            title: "feel something solid",
            body: "press your feet into the floor.\nnotice the pressure through your shoes.\nname one solid thing you can feel."
        ),
        Tip(
            title: "steady posture",
            body: "keep your back straight.\nrelax shoulders and jaw.\nlet your hands rest naturally."
        ),
        Tip(
            title: "listen selectively",
            body: "pick one sound around you.\nfocus on it for a few seconds.\nlet background noise fade away."
        ),
        Tip(
            title: "mental anchor",
            body: "silently pick a simple phrase or word (\"calm\", \"steady\", \"here\").\nrepeat it in your mind.\ngently redirect attention whenever anxiety spikes."
        )
    ]
    
    private func tipButton(for tip: Tip) -> some View {
        Button {
            selectedTip = tip
        } label: {
            HStack {
                Text(tip.title)
                    .font(.headline)
                    .foregroundColor(colorScheme == .dark ? .white : .primary)
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 50)
                    .fill(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 50)
                    .stroke(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.05))
            )
            .shadow(color: colorScheme == .dark ? Color.black.opacity(0.5) : Color.black.opacity(0.04), radius: 8, y: 4)
        }
    }

    @ViewBuilder
    private func introOverlay(geo: GeometryProxy) -> some View {
        if introTip == 4 {
            SpeechBubble(
                text: introText(for: introTip),
                arrowDown: true,
                arrowOnRight: false
            )
            .frame(maxWidth: 260)
            .position(bubblePosition(for: introTip, geo: geo))
            .transition(.opacity.combined(with: .scale))
            .animation(.easeInOut(duration: 0.3), value: introTip)
            .allowsHitTesting(false)
        }
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 12) {
                    ForEach(tips) { tip in
                        tipButton(for: tip)
                    }
                    
                    Spacer()
                    
                    Text("you'll be fine")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                }
                .padding()
                .navigationTitle("tips")

                if introTip == 4 {
                    Color.black.opacity(0.001)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            introTip = 5
                        }
                }
                
                if let tip = selectedTip {
                    TipModal(tip: tip) {
                        selectedTip = nil
                    }
                }

                introOverlay(geo: geo)
            }
        }
        .onAppear {
            if introTip == 3 {
                introTip = 4
            }
        }
        .background(colorScheme == .dark ? Color(red: 18/255, green: 18/255, blue: 18/255) : Color(red: 0.98, green: 0.95, blue: 0.90))
    }
}

struct TipModal: View {
    let tip: Tip
    let dismiss: () -> Void
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }

            VStack(spacing: 20) {

                Text(tip.title)
                    .font(.title2)
                    .fontWeight(.semibold)

                Text(tip.body)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)

            }
            .padding(28)
            .frame(maxWidth: 340)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(colorScheme == .dark
                          ? Color(white: 0.12)
                          : Color.white.opacity(0.9))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 28)
                    .stroke(Color.white.opacity(0.15))
            )
            .shadow(radius: 30)
        }
        .transition(.opacity)
        .animation(.easeOut(duration: 0.2), value: tip)
    }
}
