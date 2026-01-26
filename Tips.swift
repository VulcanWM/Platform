import SwiftUI

struct Tip: Identifiable {
    let id = UUID()
    let title: String
    let body: String
}

struct TipsView: View {
    @State private var selectedTip: Tip?
    @Environment(\.colorScheme) var colorScheme

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

    var body: some View {
        VStack(spacing: 12) {
            ForEach(tips) { tip in
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

            Spacer()
            
            Text("you'll be fine")
                .font(.callout)
                .foregroundColor(.secondary)
                .padding(.top, 8)
        }
        .padding()
        .navigationTitle("tips")
        .sheet(item: $selectedTip) { tip in
            TipSheet(tip: tip)
        }
        .background(colorScheme == .dark ? Color(red: 18/255, green: 18/255, blue: 18/255) : Color(red: 0.98, green: 0.95, blue: 0.90))
    }
}

struct TipSheet: View {
    let tip: Tip
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text(tip.title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(colorScheme == .dark ? .white : .primary)

            Text(tip.body)
                .font(.body)
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.85) : .primary)

            Spacer()
        }
        .padding(32)
    }
}
