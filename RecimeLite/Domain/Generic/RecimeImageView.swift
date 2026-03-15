import SwiftUI

struct RecimeImageView: View {
    let height: CGFloat

    init(height: CGFloat = 26) {
        self.height = height
    }

    var body: some View {
        Image(.appLogoText)
            .resizable()
            .scaledToFit()
            .frame(height: height)
            .foregroundStyle(.accentBlue)
    }
}
