import SwiftUI

struct MemorySettingsView: View {
    private let image = Image(uiImage: UIImage(named: "chick")!)
    private let emoji = "💩".toImage()
    private let symbol = Image(systemName: "hand.point.up.left")
    @State private var isPortrait = UIDevice.current.orientation == .portrait
    @State private var imageType = MemorySettings.imageType
    @State private var levelType = GameLevel.value(forGame: .memory)
    let selectorLen: CGFloat = 48

    var body: some View {
        SettingsWrapperView {
            Section(header: Text("Choose a visual preference")) {
                HStack {
                    Spacer()
                    selectorButton(image: image, title: "Images", isSelected: imageType == .clipArt)
                    Spacer()
                    selectorButton(image: emoji, title: "Emoji", isSelected: imageType == .emoji)
                    Spacer()
                    selectorButton(image: symbol, title: "Symbols", isSelected: imageType == .symbol)
                    Spacer()
                }
            }

            Section(header: Text("Choose a difficulty level")) {
                HStack {
                    Spacer()
                    gridSelectorButton(rows: isPortrait ? 4 : 3, cols: isPortrait ? 3 : 4, title: "Easy", isSelected: levelType == .easy)
                    Spacer()
                    gridSelectorButton(rows: isPortrait ? 6 : 4, cols: isPortrait ? 4 : 6, title: "Medium", isSelected: levelType == .medium)
                    Spacer()
                    gridSelectorButton(rows: isPortrait ? 8 : 5, cols: isPortrait ? 5 : 8, title: "Hard", isSelected: levelType == .hard)
                    Spacer()
                }
            }
        }
    }

    private func selectorButton(image: Image, title: String, isSelected: Bool) -> some View {
        RoundedRectangle(cornerRadius: 7)
            .strokeBorder(GameDescriptor.memory.color, lineWidth: isSelected ? 5 : 1)
            .overlay (
                VStack {
                    image
                        .resizable()
                        .frame(width: selectorLen, height: selectorLen)
                    Text(title)
                }
            )
            .background(
                GameDescriptor.memory.color.opacity(isSelected ? 0.2 : 0)
            )
            .frame(width: 99, height: 99)
            .onTapGesture {
                withAnimation(.linear) {
                    if title == "Images" {
                        MemorySettings.imageType = .clipArt
                    }
                    if title == "Emoji" {
                        MemorySettings.imageType = .emoji
                    }
                    if title == "Symbols" {
                        MemorySettings.imageType = .symbol
                    }
                    imageType = MemorySettings.imageType
                }
            }
    }

    private func gridSelectorButton(rows: Int, cols: Int, title: String, isSelected: Bool) -> some View {
        RoundedRectangle(cornerRadius: 7)
            .strokeBorder(GameDescriptor.memory.color, lineWidth: isSelected ? 5 : 1)
            .overlay (
                VStack {
                    gridBody(rows: rows, cols: cols)
                        .frame(width: selectorLen, height: selectorLen)
                    Text(title)
                }
            )
            .background(
                GameDescriptor.memory.color.opacity(isSelected ? 0.2 : 0)
            )
            .frame(width: 99, height: 99)
            .onTapGesture {
                withAnimation(.linear) {
                    if title == "Easy" {
                        levelType = .easy
                    }
                    if title == "Medium" {
                        levelType = .medium
                    }
                    if title == "Hard" {
                        levelType = .hard
                    }
                    GameLevel.set(level: levelType, forGame: .memory)
                }
            }
    }

    private func gridBody(rows: Int, cols: Int) -> some View {
        GeometryReader { geometry in
            Path { path in
                let xStepWidth = geometry.size.width / CGFloat(rows)
                let yStepWidth = geometry.size.height / CGFloat(cols)

                // Y axis lines
                (0...cols).forEach { index in
                    let y = CGFloat(index) * yStepWidth
                    path.move(to: .init(x: 0, y: y))
                    path.addLine(to: .init(x: geometry.size.width, y: y))
                }

                // X axis lines
                (0...rows).forEach { index in
                    let x = CGFloat(index) * xStepWidth
                    path.move(to: .init(x: x, y: 0))
                    path.addLine(to: .init(x: x, y: geometry.size.height))
                }
            }
            .stroke(Color.gray)
        }
    }
}

struct MemorySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MemorySettingsView()
//                .environmentObject(Navigator())
//                .environmentObject(Settings())
//                .environmentObject(Play())
        }
    }
}

extension String {
    func toImage() -> Image {
//        let timer = CodeTimer()
        let nsString = (self as NSString)
        let font = UIFont.systemFont(ofSize: 124) // you can change your font size here
        let stringAttributes = [NSAttributedString.Key.font: font]
        let imageSize = nsString.size(withAttributes: stringAttributes)

        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0) //  begin image context
        UIColor.clear.set() // clear background
        UIRectFill(CGRect(origin: CGPoint(), size: imageSize)) // set rect size
        nsString.draw(at: CGPoint.zero, withAttributes: stringAttributes) // draw text within rect
        let image = UIGraphicsGetImageFromCurrentImageContext() // create image from context
        UIGraphicsEndImageContext() //  end image context
//        timer.log("Time to convert emoji:")

        return Image(uiImage: image!)
    }
}
