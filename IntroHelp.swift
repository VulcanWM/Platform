import SwiftUI

struct SpeechBubble: View {
    let text: String
    let arrowDown: Bool

    var body: some View {
        VStack(spacing: 0) {
            if arrowDown {
                bubble
                arrow
            } else {
                arrow
                bubble
            }
        }
    }

    private var bubble: some View {
        Text(text)
            .font(.callout)
            .foregroundColor(.primary)
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.purple.opacity(0.6), lineWidth: 2)
            )
            .shadow(radius: 8)
    }

    private var arrow: some View {
        Triangle()
            .fill(Color.purple.opacity(0.6))
            .frame(width: 16, height: 8)
            .rotationEffect(.degrees(arrowDown ? 180 : 0))
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: CGPoint(x: rect.midX, y: rect.minY))
            p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            p.closeSubpath()
        }
    }
}

func bubblePosition(for step: Int, geo: GeometryProxy) -> CGPoint {
    switch step {
    case 1:
        // above hold button
        return CGPoint(
            x: geo.size.width / 2,
            y: geo.size.height / 2 - 140
        )
        
    case 2:
        // above bar, arrow points down to it
        return CGPoint(
            x: geo.size.width / 2 + geo.size.width * 0.18,
            y: geo.size.height / 2 - 220
        )
        
    case 3:
        // above tips button
        return CGPoint(
            x: geo.size.width / 2,
            y: geo.size.height - 90
        )
    case 4:
        // above
        return CGPoint(
            x: geo.size.width / 2,
            y: geo.size.height - 80
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
