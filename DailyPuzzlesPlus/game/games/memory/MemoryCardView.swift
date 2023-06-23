import SwiftUI

//  https://betterprogramming.pub/card-flip-animation-in-swiftui-45d8b8210a00
struct MemoryCardView: View {
    @EnvironmentObject var viewModel: MemoryViewModel
    @State var backDegree = 0.0
    @State var frontDegree = -90.0
    let index: Int
    let image: Image
    let found: Bool
    @State var isFlipped = false
    let durationAndDelay : CGFloat = 0.18
    @State private var rotation = 0.0

    func rotateCard() {
        withAnimation(.linear(duration: 0.75).delay(durationAndDelay)){
            rotation = 360
        }
    }

    func flipCard () {
        isFlipped = !isFlipped
        if isFlipped {
            withAnimation(.linear(duration: durationAndDelay)) {
                backDegree = 90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                frontDegree = 0
            }
        } else {
            withAnimation(.linear(duration: durationAndDelay)) {
                frontDegree = -90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                backDegree = 0
            }
        }
    }

    var body: some View {
        ZStack {
            FrontView(image: image, degree: $frontDegree, found: found)
                .rotationEffect(Angle(degrees: rotation))
            BackView(degree: $backDegree)
        }
        .onReceive(NotificationCenter.default.publisher(for: .flipCard)) { notification in
            if let info = notification.object as? [String:Int] {
                if let i = info["index"] {
                    if i == index {
                        flipCard()
                    }
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .rotateCard)) { notification in
            if let info = notification.object as? [String:Int] {
                if let i = info["index"] {
                    if i == index {
                        rotateCard()
                    }
                }
            }
        }
        .onTapGesture {
            viewModel.cardTap(index: index)
        }
    }

    struct FrontView : View {
        let image: Image
        @Binding var degree : Double
        let found: Bool

        var body: some View {
            ZStack {

                RoundedRectangle(cornerRadius: 7)
                    .strokeBorder(GameDescriptor.memory.color, lineWidth: found ? 0 : 5)
                    .background(RoundedRectangle(cornerRadius: 7)
                        .fill(Color(uiColor: UIColor.secondarySystemGroupedBackground)))
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(GameDescriptor.memory.color)
                    .padding()
            }
            .rotation3DEffect(Angle(degrees: degree), axis: (x: 0.001, y: 1, z: 0.001))
        }
    }

    struct BackView : View {
        @Binding var degree : Double

        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 7)
                    .strokeBorder(Color(uiColor: UIColor.systemGray3), lineWidth: 1)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 7)
                                .fill(Color(uiColor: UIColor.secondarySystemGroupedBackground))
                            Image("question-mark")
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .foregroundColor(Color(uiColor: UIColor.systemGray3))
                            //                                .shadow(color: .black, radius: 1, x: 1, y: 1)
                                .padding()
                        }
                    )

            }
            .rotation3DEffect(Angle(degrees: degree), axis: (x: 0.001, y: 1, z: 0.001))

        }
    }
}

struct MemoryCardView_Previews: PreviewProvider {
    static var back: some View {
        MemoryCardView.BackView(degree: .constant(0.0))
            .padding()
    }

    static var front: some View {
        MemoryCardView.FrontView(image: Image(systemName: "brain.head.profile"), degree: .constant(0.0), found: true)
            .padding()
    }

    static var frontSelected: some View {
        MemoryCardView.FrontView(image: Image(systemName: "brain.head.profile"), degree: .constant(0.0), found: false)
            .padding()
    }

    static var previews: some View {
        back
            .previewDisplayName("back")
        front
            .previewDisplayName("front")
        frontSelected
            .previewDisplayName("frontSelected")
    }
}
