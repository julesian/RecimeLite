import SwiftUI

struct SwitchControlView: View {
    enum Constants {
        static let controlWidth = 72.0
        static let controlHeight = 44.0
        static let knobSize = 36.0
        static let horizontalPadding = 4.0
    }

    @Binding var isOn: Bool

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                isOn.toggle()
            }
        } label: {
            ZStack(alignment: isOn ? .trailing : .leading) {
                Capsule()
                    .fill(isOn ? Color.accentOrange : Color.foregroundPrimary)
                    .overlay {
                        Capsule()
                            .stroke(Color.divider, lineWidth: 1)
                    }

                Circle()
                    .fill(Color.backgroundPrimary)
                    .frame(width: Constants.knobSize, height: Constants.knobSize)
                    .padding(.horizontal, Constants.horizontalPadding)
            }
            .frame(width: Constants.controlWidth, height: Constants.controlHeight)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SwitchControlPreview()
        .padding()
}

private struct SwitchControlPreview: View {
    @State private var isVegetarian = true
    @State private var isEnabled = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Enabled")
                .primaryTextStyle()

            SwitchControlView(isOn: $isVegetarian)

            Text("Disabled")
                .primaryTextStyle()

            SwitchControlView(isOn: $isEnabled)
        }
        .background(Color.foregroundPrimary)
    }
}
