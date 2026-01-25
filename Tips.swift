import SwiftUI

struct Tip: Identifiable {
    let id = UUID()
    let title: String
    let body: String
}

struct TipsView: View {
    @State private var selectedTip: Tip?

    let tips: [Tip] = [
        Tip(
            title: "Feel something solid",
            body: "Press your feet into the floor.\nNotice the pressure through your shoes.\nName one solid thing you can feel."
        ),
        Tip(
            title: "Steady posture",
            body: "Keep your back straight.\nRelax shoulders and jaw.\nLet your hands rest naturally."
        ),
        Tip(
            title: "Listen selectively",
            body: "Pick one sound around you.\nFocus on it for a few seconds.\nLet background noise fade away."
        ),
        Tip(
            title: "Mental anchor",
            body: "Silently pick a simple phrase or word (\"calm\", \"steady\", \"here\").\nRepeat it in your mind.\nGently redirect attention whenever anxiety spikes."
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
                            .foregroundStyle(.primary)

                        Spacer()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 50)
                            .fill(Color.white)
                    )
                    .foregroundStyle(.primary)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color.black.opacity(0.05))
                    )
                    .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Tips")
        .sheet(item: $selectedTip) { tip in
            TipSheet(tip: tip)
        }
        .background(Color(red: 0.98, green: 0.95, blue: 0.90))
    }
}

struct TipSheet: View {
    let tip: Tip

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text(tip.title)
                .font(.title2)
                .fontWeight(.semibold)

            Text(tip.body)
                .font(.body)
                .multilineTextAlignment(.center)
                .lineSpacing(6)

            Spacer()
        }
        .padding(32)
    }
}
