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
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Tips")
        .sheet(item: $selectedTip) { tip in
            TipSheet(tip: tip)
        }
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
