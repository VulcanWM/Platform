import SwiftUI

struct HoldButton: ButtonStyle {
    let size: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: size, height: size)
            .background(Color(red: 0.9, green: 0.4, blue: 0))
            .foregroundStyle(.white)
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct ContentView: View {
    @State private var isPressed: Bool = false
    @State private var tapStatus: String = "hold to breathe"
    
    func hold() {
        // action
    }

    var body: some View {
        GeometryReader { geo in
            let buttonSize = geo.size.width * 0.7

            VStack {
                Spacer()

                Button(action: {
                    self.tapStatus = "finished breathing"
                    self.isPressed = false
                }) {
                    Text("HOLD")
                        .font(.system(size: buttonSize * 0.25, weight: .bold))
                }
                .buttonStyle(HoldButton(size: buttonSize))
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: 0.1).onEnded({ _ in
                        self.tapStatus = "holding down"
                        self.isPressed = true
                    })
                )
                Text(tapStatus)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
