import SwiftUI

struct TagListView: View {
    enum Constants {
        static let containerSpacing = 16.0
        static let tagSpacing = 10.0
        static let containerPadding = 16.0
        static let tagHorizontalPadding = 12.0
        static let tagVerticalPadding = 8.0
        static let containerCornerRadius = 20.0
        static let inputHeight = 40.0
        static let inputIconSize = 16.0
        static let collapsedInputWidth = 40.0
        static let expandedInputWidth = 220.0
    }

    let title: String
    let placeholder: String
    @Binding var tags: [String]

    @State private var isInputExpanded = false
    @State private var inputText = ""

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.containerSpacing) {
            headerView

            WrappingTagLayout(
                horizontalSpacing: Constants.tagSpacing,
                verticalSpacing: Constants.tagSpacing
            ) {
                ForEach(tags, id: \.self) { tag in
                    tagView(tag)
                }
            }
        }
        .padding(Constants.containerPadding)
        .background(Color.foregroundPrimary)
        .clipShape(
            RoundedRectangle(
                cornerRadius: Constants.containerCornerRadius,
                style: .continuous
            )
        )
        .contentShape(
            RoundedRectangle(
                cornerRadius: Constants.containerCornerRadius,
                style: .continuous
            )
        )
        .onTapGesture {
            guard isInputExpanded else { return }
            collapseInput()
        }
    }

    private var headerView: some View {
        ZStack(alignment: .trailing) {
            Text(title)
                .primaryTextStyle()
                .frame(maxWidth: .infinity, alignment: .leading)
                .opacity(isInputExpanded ? 0 : 1)
                .animation(.easeInOut(duration: 0.18), value: isInputExpanded)

            ExpandableInputCapsuleView(
                text: $inputText,
                isExpanded: $isInputExpanded,
                placeholder: placeholder,
                collapsedImage: "plus",
                inputContextImage: nil,
                inputActionImage: "plus",
                height: Constants.inputHeight,
                iconSize: Constants.inputIconSize,
                hidesActionWhenExpandedAndEmpty: false,
                onAction: addTag
            )
            .frame(
                maxWidth: isInputExpanded ? .infinity : Constants.collapsedInputWidth,
                alignment: .trailing
            )
            .animation(.easeInOut(duration: 0.28), value: isInputExpanded)
        }
    }

    private func tagView(_ tag: String) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                tags.removeAll { $0 == tag }
            }
        } label: {
            HStack(spacing: 8) {
                Text(tag)
                    .font(.subheadline)
                    .foregroundStyle(.textPrimary)

                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.textSecondary)
            }
            .padding(.horizontal, Constants.tagHorizontalPadding)
            .padding(.vertical, Constants.tagVerticalPadding)
            .background(Color.backgroundPrimary)
            .overlay {
                Capsule()
                    .stroke(Color.divider, lineWidth: 1)
            }
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    private func addTag() {
        let trimmedText = inputText.trimmingCharacters(in: .whitespacesAndNewlines)

        if isInputExpanded, !trimmedText.isEmpty {
            withAnimation(.easeInOut(duration: 0.2)) {
                tags.append(trimmedText)
            }
            inputText = ""
        } else {
            isInputExpanded = true
        }
    }

    private func collapseInput() {
        withAnimation(.easeInOut(duration: 0.2)) {
            isInputExpanded = false
        }
        inputText = ""
    }
}

private struct WrappingTagLayout: Layout {
    let horizontalSpacing: CGFloat
    let verticalSpacing: CGFloat

    init(horizontalSpacing: CGFloat, verticalSpacing: CGFloat) {
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
    }

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var currentRowWidth: CGFloat = 0
        var currentRowHeight: CGFloat = 0
        var totalHeight: CGFloat = 0
        var maxRowWidth: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            if currentRowWidth + size.width > maxWidth, currentRowWidth > 0 {
                totalHeight += currentRowHeight + verticalSpacing
                maxRowWidth = max(maxRowWidth, currentRowWidth - horizontalSpacing)
                currentRowWidth = 0
                currentRowHeight = 0
            }

            currentRowWidth += size.width + horizontalSpacing
            currentRowHeight = max(currentRowHeight, size.height)
        }

        if currentRowHeight > 0 {
            totalHeight += currentRowHeight
            maxRowWidth = max(maxRowWidth, currentRowWidth - horizontalSpacing)
        }

        return CGSize(width: maxRowWidth, height: totalHeight)
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        var origin = CGPoint(x: bounds.minX, y: bounds.minY)
        var currentRowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            if origin.x + size.width > bounds.maxX, origin.x > bounds.minX {
                origin.x = bounds.minX
                origin.y += currentRowHeight + verticalSpacing
                currentRowHeight = 0
            }

            subview.place(
                at: origin,
                proposal: ProposedViewSize(width: size.width, height: size.height)
            )

            origin.x += size.width + horizontalSpacing
            currentRowHeight = max(currentRowHeight, size.height)
        }
    }
}

#Preview {
    PreviewContainer()
        .padding()
        .background(Color.backgroundPrimary)
}

private struct PreviewContainer: View {
    @State private var includeIngredients = [
        "garlic", "tomato", "olive oil", "basil", "mushroom", "onion"
    ]
    @State private var excludeIngredients = [
        "peanuts", "shrimp", "milk"
    ]

    var body: some View {
        VStack(spacing: 16) {
            TagListView(
                title: "Include Ingredients",
                placeholder: "Include ingredient",
                tags: $includeIngredients
            )

            TagListView(
                title: "Exclude Ingredients",
                placeholder: "Exclude ingredient",
                tags: $excludeIngredients
            )
        }
        .padding()
    }
}
