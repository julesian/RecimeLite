import SwiftUI

// Note: for simplicity I put both font and the style, can be separated if needed

extension View {
    func sheetHeaderTextStyle() -> some View {
        font(.title2.weight(.bold))
            .foregroundStyle(.accentBlue)
    }

    func primaryTextStyle() -> some View {
        font(.headline)
            .foregroundStyle(.textPrimary)
    }

    func secondaryTextStyle() -> some View {
        font(.subheadline)
            .foregroundStyle(.textSecondary)
    }
    
    func teritaryTextStyle() -> some View {
        font(.caption)
            .foregroundStyle(.textSecondary)
    }

    func bottomBarTextStyle() -> some View {
        font(.caption)
            .foregroundStyle(.iconTintSecondary)
    }

    func capsuleTextStyle(
        foregroundColor: Color,
        backgroundColor: Color
    ) -> some View {
        font(.caption)
            .foregroundStyle(foregroundColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(backgroundColor)
            .clipShape(Capsule())
    }
}
