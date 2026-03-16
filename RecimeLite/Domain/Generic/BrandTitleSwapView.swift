import SwiftUI

struct BrandTitleSwapView: View {
    enum Constants {
        static let verticalOffset = 8.0
        static let animationDuration = 0.42
    }

    let title: String
    let showsTitle: Bool

    var body: some View {
        ZStack {
            RecimeImageView()
                .opacity(showsTitle ? 0 : 1)
                .offset(y: showsTitle ? -Constants.verticalOffset : 0)

            Text(title)
                .headerTextStyle()
                .lineLimit(1)
                .opacity(showsTitle ? 1 : 0)
                .offset(y: showsTitle ? 0 : Constants.verticalOffset)
        }
        .animation(
            .easeInOut(duration: Constants.animationDuration),
            value: showsTitle
        )
    }
}

#Preview {
    VStack(spacing: 24) {
        BrandTitleSwapView(title: "Vegetarian Pasta", showsTitle: false)
        BrandTitleSwapView(title: "Vegetarian Pasta", showsTitle: true)
    }
    .padding()
    .background(Color.foregroundPrimary)
}
