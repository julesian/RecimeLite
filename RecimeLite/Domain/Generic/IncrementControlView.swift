import SwiftUI

struct IncrementControlView: View {
    enum Action {
        case decrement
        case increment

        var systemImage: String {
            switch self {
            case .decrement: "minus"
            case .increment: "plus"
            }
        }
    }

    enum Constants {
        static let controlHeight = 44.0
        static let buttonSize = 36.0
        static let iconSize = 16.0
        static let horizontalPadding = 6.0
        static let contentSpacing = 8.0
        static let valueWidth = 44.0
    }

    @Binding var value: Int

    let minimumValue: Int?
    let maximumValue: Int?

    init(
        value: Binding<Int>,
        minimumValue: Int? = nil,
        maximumValue: Int? = nil
    ) {
        _value = value
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
    }

    var body: some View {
        HStack(spacing: Constants.contentSpacing) {
            actionButton(.decrement)

            Text("\(value)")
                .primaryTextStyle()
                .frame(width: Constants.valueWidth)

            actionButton(.increment)
        }
        .padding(.horizontal, Constants.horizontalPadding)
        .frame(height: Constants.controlHeight)
        .background(Color.foregroundPrimary)
        .overlay {
            Capsule()
                .stroke(Color.divider, lineWidth: 1)
        }
        .clipShape(Capsule())
    }

    private func actionButton(_ action: Action) -> some View {
        Button(action: { handle(action) }) {
            Image(systemName: action.systemImage)
                .font(.system(size: Constants.iconSize, weight: .semibold))
                .foregroundStyle(.textPrimary)
                .frame(width: Constants.buttonSize, height: Constants.buttonSize)
                .background(Color.backgroundPrimary)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .disabled(!canPerform(action))
        .opacity(canPerform(action) ? 1 : 0.45)
    }

    private var canDecrement: Bool {
        guard let minimumValue else { return true }
        return value > minimumValue
    }

    private var canIncrement: Bool {
        guard let maximumValue else { return true }
        return value < maximumValue
    }

    private func canPerform(_ action: Action) -> Bool {
        switch action {
        case .decrement: canDecrement
        case .increment: canIncrement
        }
    }

    private func handle(_ action: Action) {
        guard canPerform(action) else { return }

        switch action {
        case .decrement: value -= 1
        case .increment: value += 1
        }
    }
}

#Preview {
    IncrementControlPreview()
        .padding()
        .background(Color.backgroundPrimary)
}

private struct IncrementControlPreview: View {
    @State private var servings = 2

    var body: some View {
        IncrementControlView(
            value: $servings,
            minimumValue: 1,
            maximumValue: 6
        )
    }
}
