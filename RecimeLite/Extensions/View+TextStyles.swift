import SwiftUI

extension View {
    func primaryTextStyle() -> some View {
        foregroundStyle(.textPrimary)
    }

    func secondaryTextStyle() -> some View {
        foregroundStyle(.textSecondary)
    }

    func capsuleTextStyle(
        foregroundColor: Color,
        backgroundColor: Color
    ) -> some View {
        foregroundStyle(foregroundColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(backgroundColor)
            .clipShape(Capsule())
    }
}
