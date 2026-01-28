import SwiftUI

struct SpeechBubble: View {
    let text: String
    let arrowDown: Bool
    let arrowOnRight: Bool

    var body: some View {
        Text(text)
            .font(.callout)
            .foregroundColor(.primary)
            .padding(14)
            .background(
                BubbleShape(
                    arrowDown: arrowDown,
                    arrowOnRight: arrowOnRight
                )
                .fill(.ultraThinMaterial)
            )
            .overlay(
                BubbleShape(
                    arrowDown: arrowDown,
                    arrowOnRight: arrowOnRight
                )
                .stroke(Color.purple.opacity(0.6), lineWidth: 2)
            )
            .shadow(radius: 8)
    }
}

struct BubbleShape: Shape {
    let arrowDown: Bool
    let arrowOnRight: Bool

    func path(in rect: CGRect) -> Path {
        let corner: CGFloat = 16
        let nubWidth: CGFloat = 18
        let nubHeight: CGFloat = 10

        let nubX: CGFloat = arrowOnRight
            ? rect.maxX - corner - nubWidth
            : rect.midX - nubWidth / 2

        var path = Path()

        if arrowDown {
            path.move(to: CGPoint(x: corner, y: 0))
            path.addLine(to: CGPoint(x: rect.width - corner, y: 0))
            path.addQuadCurve(
                to: CGPoint(x: rect.width, y: corner),
                control: CGPoint(x: rect.width, y: 0)
            )

            path.addLine(to: CGPoint(x: rect.width, y: rect.height - corner - nubHeight))
            path.addQuadCurve(
                to: CGPoint(x: rect.width - corner, y: rect.height - nubHeight),
                control: CGPoint(x: rect.width, y: rect.height - nubHeight)
            )

            path.addLine(to: CGPoint(x: nubX + nubWidth, y: rect.height - nubHeight))
            path.addLine(to: CGPoint(x: nubX + nubWidth / 2, y: rect.height))
            path.addLine(to: CGPoint(x: nubX, y: rect.height - nubHeight))

            path.addLine(to: CGPoint(x: corner, y: rect.height - nubHeight))
            path.addQuadCurve(
                to: CGPoint(x: 0, y: rect.height - nubHeight - corner),
                control: CGPoint(x: 0, y: rect.height - nubHeight)
            )

            path.addLine(to: CGPoint(x: 0, y: corner))
            path.addQuadCurve(
                to: CGPoint(x: corner, y: 0),
                control: CGPoint(x: 0, y: 0)
            )
        } else {
            path.move(to: CGPoint(x: corner, y: nubHeight))
            path.addLine(to: CGPoint(x: nubX, y: nubHeight))
            path.addLine(to: CGPoint(x: nubX + nubWidth / 2, y: 0))
            path.addLine(to: CGPoint(x: nubX + nubWidth, y: nubHeight))

            path.addLine(to: CGPoint(x: rect.width - corner, y: nubHeight))
            path.addQuadCurve(
                to: CGPoint(x: rect.width, y: nubHeight + corner),
                control: CGPoint(x: rect.width, y: nubHeight)
            )

            path.addLine(to: CGPoint(x: rect.width, y: rect.height - corner))
            path.addQuadCurve(
                to: CGPoint(x: rect.width - corner, y: rect.height),
                control: CGPoint(x: rect.width, y: rect.height)
            )

            path.addLine(to: CGPoint(x: corner, y: rect.height))
            path.addQuadCurve(
                to: CGPoint(x: 0, y: rect.height - corner),
                control: CGPoint(x: 0, y: rect.height)
            )

            path.addLine(to: CGPoint(x: 0, y: nubHeight + corner))
            path.addQuadCurve(
                to: CGPoint(x: corner, y: nubHeight),
                control: CGPoint(x: 0, y: nubHeight)
            )
        }

        return path
    }
}

func bubblePosition(for step: Int, geo: GeometryProxy) -> CGPoint {
    switch step {
    case 1:
        return CGPoint(
            x: geo.size.width / 2,
            y: geo.size.height / 2 - 140
        )

    case 2:
        return CGPoint(
            x: geo.size.width / 2 + geo.size.width * 0.18,
            y: geo.size.height / 2 - 220
        )

    case 3:
        return CGPoint(
            x: geo.size.width / 2,
            y: geo.size.height - 90
        )

    case 4:
        return CGPoint(
            x: geo.size.width / 2,
            y: geo.size.height - 90
        )

    default:
        return .zero
    }
}

func introText(for step: Int) -> String {
    switch step {
    case 1:
        return "press and hold.\nlet your breath lead."
    case 2:
        return "this follows you.\nbreathe however feels right."
    case 3:
        return "extra grounding tips.\nonly if you want them."
    case 4:
        return "this moment will pass.\nso will the train."
    default:
        return ""
    }
}
