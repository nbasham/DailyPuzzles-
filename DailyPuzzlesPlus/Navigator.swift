import SwiftUI

@MainActor
class Navigator: ObservableObject {
    @Published var path = NavigationPath()

    func push(_ obj: any Hashable) {
        path.append(obj)
    }

    func pop() {
        path.removeLast()
    }
}

struct FullCoverPath: Identifiable, Equatable, Hashable, CustomStringConvertible {
    var description: String { "\(value)" }

    static func == (lhs: FullCoverPath, rhs: FullCoverPath) -> Bool {
        lhs.id == rhs.id
    }
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    let value: any Hashable
    var id = UUID()
}

struct SheetPath: Identifiable, Equatable, Hashable, CustomStringConvertible {
    var description: String { "\(value)" }

    static func == (lhs: SheetPath, rhs: SheetPath) -> Bool {
        lhs.id == rhs.id
    }
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    let value: any Hashable
    var id = UUID()
}

// For testing
struct ColorView: View {
    let color: Color
    @State private var sheetPath: SheetPath? = nil
    init(_ color: Color) {
        self.color = color
    }
    var body: some View {
        ZStack {
            color
            Button("Sheet") {
                sheetPath = SheetPath(value: Color.red)
            }
            .tint(.white)
        }
        .sheet(item: $sheetPath) { sheet in
            ZStack {
                sheet.value as! Color
                Button("Dismiss") { sheetPath = nil }
                    .tint(.white)
            }
        }
    }
}


