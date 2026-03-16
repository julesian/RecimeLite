import SwiftUI

struct CircularIconButtonView: View {
    enum Style {
        case standard
        case accent

        var foregroundColor: Color {
            switch self {
            case .standard: .textPrimary
            case .accent: .foregroundPrimary
            }
        }

        var backgroundColor: Color {
            switch self {
            case .standard: .backgroundPrimary
            case .accent: .accentOrange
            }
        }

        var strokeColor: Color {
            switch self {
            case .standard: .divider
            case .accent: .accentOrange
            }
        }
    }

    let systemImage: String
    let size: CGFloat
    let iconSize: CGFloat
    let style: Style
    let action: () -> Void

    init(
        systemImage: String,
        size: CGFloat = 44,
        iconSize: CGFloat = 16,
        style: Style = .standard,
        action: @escaping () -> Void
    ) {
        self.systemImage = systemImage
        self.size = size
        self.iconSize = iconSize
        self.style = style
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: iconSize, weight: .semibold))
                .foregroundStyle(style.foregroundColor)
                .frame(width: size, height: size)
                .background(style.backgroundColor)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke(style.strokeColor, lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 16) {
        Text("Standard")
            .primaryTextStyle()

        CircularIconButtonView(
            systemImage: "magnifyingglass",
            size: 38,
            iconSize: 15,
            style: .standard,
            action: {}
        )

        Text("Accent")
            .primaryTextStyle()

        CircularIconButtonView(
            systemImage: "line.3.horizontal.decrease",
            size: 38,
            iconSize: 15,
            style: .accent,
            action: {}
        )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    .padding()
    .background(Color.foregroundPrimary)
}
