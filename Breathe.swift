import SwiftUI

struct FourSideBars: View {
    let size: CGFloat
    let thickness: CGFloat = 10
    let progress: CGFloat

    var body: some View {
        ZStack {
            // top
            Rectangle()
                .fill(.red)
                .frame(width: size, height: thickness)
                .offset(y: -(size / 2 + thickness / 2))
                .scaleEffect(
                    x: 1,
                    y: 1,
                    anchor: .top
                )

            // right
            Rectangle()
                .fill(.yellow)
                .frame(width: thickness, height: size)
                .offset(x: (size / 2 + thickness / 2))
                .scaleEffect(
                    x: 1,
                    y: 1,
                    anchor: .trailing
                )

            // bottom
            Rectangle()
                .fill(.green)
                .frame(width: size, height: thickness)
                .offset(y: (size / 2 + thickness / 2))
                .scaleEffect(
                    x: 1,
                    y: 1,
                    anchor: .bottom
                )

            // left
            Rectangle()
                .fill(.blue)
                .frame(width: thickness, height: size)
                .offset(x: -(size / 2 + thickness / 2))
                .scaleEffect(
                    x: 1,
                    y: 1,
                    anchor: .leading
                )
        }
    }
}


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

struct BreatheView: View {
    @State private var isPressed = false
    @State private var tapStatus = "hold to breathe"
    @State private var counter = 0
    @State private var timer: Timer?

    var body: some View {
        GeometryReader { geo in
            let buttonSize = geo.size.width * 0.7

            VStack {
                Spacer()

                ZStack {
                    FourSideBars(
                        size: buttonSize,
                        progress: CGFloat(counter) / 10
                    )

                    Button {
                        tapStatus = "finished breathing"
                        isPressed = false
                        timer?.invalidate()
                        counter = 0
                    } label: {
                        Text("HOLD")
                            .font(.system(size: buttonSize * 0.25, weight: .bold))
                    }
                    .buttonStyle(HoldButton(size: buttonSize))
                    .simultaneousGesture(
                        LongPressGesture(minimumDuration: 0.1)
                            .onEnded { _ in
                                tapStatus = "holding down"
                                isPressed = true
                                timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                                    DispatchQueue.main.async {
                                        counter += 1
                                    }
                                }
                                RunLoop.main.add(timer!, forMode: .common)
                            }
                    )
                }

                Text(tapStatus)
                Text("\(counter)")

                Spacer()

                // bottom button
                NavigationLink {
                    TipsView()
                } label: {
                    Text("want some other tips?")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.black)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
