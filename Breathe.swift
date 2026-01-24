import SwiftUI

struct BreatheBar: View {
    let size: CGFloat
    let thickness: CGFloat = 10
    let count: Int
    var sizeOfBreathe: CGFloat { min(CGFloat(count) / 40 * size, size) }

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.gray)
                .frame(width: thickness, height: size)
                .offset(x: (size / 2 + thickness / 2) + 20)

            Rectangle()
                .fill(.orange)
                .frame(width: thickness, height: sizeOfBreathe)
                .offset(
                    x: (size / 2 + thickness / 2) + 20,
                    y: (size - sizeOfBreathe) / 2
                )

            if count > 40 {
                Rectangle()
                    .fill(.red)
                    .frame(width: thickness, height: size / 8)
                    .offset(
                        x: (size / 2 + thickness / 2) + 20,
                        y: -(size / 2 - (size / 16))
                    )
            }
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
    @State private var breatheOut = true

    var body: some View {
        GeometryReader { geo in
            let buttonSize = geo.size.width * 0.7

            VStack {
                Spacer()

                ZStack {
                    BreatheBar(
                        size: buttonSize,
                        count: counter
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
                                }
                            }
                        }
                        RunLoop.main.add(timer!, forMode: .common)
                    } label: {
                        Text((breatheOut == false && counter > 40) || (breatheOut && counter != 0) ? "LET GO" : "HOLD")
                            .font(.system(size: buttonSize * 0.25, weight: .bold))
                    }
                    .buttonStyle(HoldButton(size: buttonSize))
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
                                RunLoop.main.add(timer!, forMode: .common)
                            }
                    )
                }

                Text(counter > 0 ? "\(counter/10)" : "  ")
                Text((breatheOut == false && counter > 40) || (breatheOut && counter != 0) ? "breathe out" : "breathe in while holding")

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
