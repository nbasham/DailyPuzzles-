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

    init(backDegree: Double = 0.0, frontDegree: Double = 90.0, index: Int, image: Image, found: Bool, isFlipped: Bool, rotation: Double = 0.0) {
        self.backDegree = backDegree
        self.frontDegree = frontDegree
        self.index = index
        self.image = image
        self.found = found
        self.isFlipped = isFlipped
        self.rotation = rotation
        flipCard()
    }

    init(index: Int, image: Image, found: Bool, isFlipped: Bool = false, rotation: Double = 0.0) {
        if isFlipped || found {
            self.backDegree = 90
            self.frontDegree = 0
        } else {
            self.backDegree = 0
            self.frontDegree = 90
        }
        self.index = index
        self.image = image
        self.found = found
        self.isFlipped = isFlipped
        self.rotation = rotation
        flipCard()
    }

    func rotateCard() {
        withAnimation(.linear(duration: 0.75).delay(durationAndDelay)){
            rotation = 360
        }
    }

    func flipCard () {
        isFlipped = !isFlipped
        if isFlipped || found {
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
            FrontView(cardSelectionLen: viewModel.cardSelectionLen, cardPadding: viewModel.cardPadding, image: image, degree: $frontDegree, found: found)
                .rotationEffect(Angle(degrees: rotation))
            BackView(cardPadding: viewModel.cardPadding, degree: $backDegree)
        }
        .environmentObject(viewModel)
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
        let cardSelectionLen: CGFloat
        let cardPadding: CGFloat
        let image: Image
        @Binding var degree : Double
        let found: Bool

        var body: some View {
            ZStack {

                RoundedRectangle(cornerRadius: 7)
                    .strokeBorder(GameDescriptor.memory.color, lineWidth: found ? 0 : cardSelectionLen)
                    .background(RoundedRectangle(cornerRadius: 7)
                        .fill(Color(uiColor: UIColor.secondarySystemGroupedBackground)))
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(GameDescriptor.memory.color)
                    .padding(cardPadding)
            }
            .rotation3DEffect(Angle(degrees: degree), axis: (x: 0.001, y: 1, z: 0.001))
        }
    }

    struct BackView : View {
        @EnvironmentObject var viewModel: MemoryViewModel
        let cardPadding: CGFloat
        @Binding var degree : Double

        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 7)
                    .strokeBorder(Color(uiColor: UIColor.systemGray3), lineWidth: UIDevice.isPhone ? 1 : 3)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 7)
                                .fill(Color(uiColor: UIColor.secondarySystemGroupedBackground))
                            Image("question-mark")
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .foregroundColor(Color(uiColor: UIColor.systemGray3))
                            //                                .shadow(color: .black, radius: 1, x: 1, y: 1)
                                .padding(UIDevice.isPhone ? cardPadding : cardPadding * 2)
                        }
                    )

            }
            .rotation3DEffect(Angle(degrees: degree), axis: (x: 0.001, y: 1, z: 0.001))

        }
    }
}

struct MemoryCardView_Previews: PreviewProvider {
    static var previews: some View {
        let host = GameHostView(viewModel: GameHostViewModel(game: .memory))
        let size = CGSize(width: 390.0, height: 763.0)
        @State var vm = MemoryViewModel(host: host, size: size, level: .easy, debugPreview: true)
        return VStack {
            MemoryCardView(index: 1, image: Image(systemName: "circle"), found: true, isFlipped: false)
                .environmentObject(vm)
            ForEach(1..<5) { row in
                HStack {
                    MemoryCardView.BackView(cardPadding: CGFloat(2*row), degree: .constant(0.0))
                        .frame(width: CGFloat(64*row/2), height: CGFloat(94*row/2))
                    MemoryCardView.FrontView(cardSelectionLen: CGFloat(1+row), cardPadding: CGFloat(2*row), image: Image(uiImage: UIImage(named: "chick")!), degree: .constant(0.0), found: false)
                        .frame(width: CGFloat(64*row/2), height: CGFloat(94*row/2))
                    MemoryCardView.FrontView(cardSelectionLen: CGFloat(1+row), cardPadding: CGFloat(2*row), image: "🍕".toImage(), degree: .constant(0.0), found: false)
                        .frame(width: CGFloat(64*row/2), height: CGFloat(94*row/2))
                    MemoryCardView.FrontView(cardSelectionLen: CGFloat(1+row), cardPadding: CGFloat(2*row), image: Image(systemName: "figure.dance"), degree: .constant(0.0), found: false)
                        .frame(width: CGFloat(64*row/2), height: CGFloat(94*row/2))
                }
            }
        }
        .previewLayout(.sizeThatFits)
    }
}
