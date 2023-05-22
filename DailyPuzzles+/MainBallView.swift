import SwiftUI

struct MainBallView: View {
    let color: Color
    @State private var animateBall = false

    var body: some View {
        Circle()
            .fill(
               Gradient(colors: [color.lighter(componentDelta: 0.2), color.lighter(), color, color.darker(), color.darker(componentDelta: 0.3)])
            )
            .frame(height: 32)
            .aspectRatio(1, contentMode: .fit)
            .rotationEffect(Angle(degrees: -35))
            .rotationEffect(.degrees(animateBall ? 5*360 : 0))
            .onTapGesture {
                withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                    animateBall.toggle()
                }
            }
    }
}

struct MainBallView_Previews: PreviewProvider {
    static var previews: some View {
        MainBallView(color: .blue)
    }
}
