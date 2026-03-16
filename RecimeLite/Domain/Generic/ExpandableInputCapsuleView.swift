import SwiftUI

struct ExpandableInputCapsuleView: View {
    enum Constants {
        static let textLeadingPadding = 14.0
        static let textTrailingPadding = 6.0
        static let contentSpacing = 10.0
        static let textAnimationDuration = 0.12
    }

    @Binding var text: String
    @Binding var isExpanded: Bool

    /// placeholder text in the input field
    let placeholder: String
    /// image when the view is a circular button
    let collapsedImage: String
    /// leading image of the input field when expanded
    let inputContextImage: String?
    /// trailing tappable image of the input field when expanded
    let inputActionImage: String
    
    let height: CGFloat
    let iconSize: CGFloat
    let hidesActionWhenExpandedAndEmpty: Bool
    let onAction: () -> Void

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: Constants.contentSpacing) {
            if isExpanded, let inputContextImage {
                Image(systemName: inputContextImage)
                    .foregroundStyle(.textSecondary)
            }

            if isExpanded {
                TextField(placeholder, text: $text)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .primaryTextStyle()
                    .focused($isFocused)
            }

            Button(action: onAction) {
                Image(systemName: displayedActionSystemImage)
                    .font(.system(size: iconSize, weight: .semibold))
                    .foregroundStyle(.textPrimary)
                    .frame(width: height, height: height)
                    .background(Color.backgroundPrimary)
                    .clipShape(Circle())
                    .opacity(actionOpacity)
            }
            .buttonStyle(.plain)
        }
        .padding(.leading, isExpanded ? Constants.textLeadingPadding : 0)
        .padding(.trailing, isExpanded ? Constants.textTrailingPadding : 0)
        .frame(height: height)
        .background(Color.backgroundPrimary)
        .clipShape(Capsule())
        .animation(.easeInOut(duration: Constants.textAnimationDuration), value: text.isEmpty)
        .onChange(of: isExpanded) { _, expanded in
            isFocused = expanded
        }
    }

    private var displayedActionSystemImage: String {
        isExpanded ? inputActionImage : collapsedImage
    }

    private var actionOpacity: Double {
        if hidesActionWhenExpandedAndEmpty && isExpanded && text.isEmpty {
            return 0
        }

        return 1
    }
}

#Preview {
    ExpandableInputCapsulePreview()
        .padding()
        .background(Color.foregroundPrimary)
}

private struct ExpandableInputCapsulePreview: View {
    @State private var searchText = ""
    @State private var isSearchExpanded = false
    @State private var ingredientText = "garlic"
    @State private var isIngredientExpanded = true

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Collapsed")
                .primaryTextStyle()

            ExpandableInputCapsuleView(
                text: $searchText,
                isExpanded: $isSearchExpanded,
                placeholder: "Search recipes",
                collapsedImage: "magnifyingglass",
                inputContextImage: "magnifyingglass",
                inputActionImage: "xmark",
                height: 44,
                iconSize: 16,
                hidesActionWhenExpandedAndEmpty: true,
                onAction: {
                    isSearchExpanded.toggle()
                }
            )
            .frame(width: 280, alignment: .trailing)

            Text("Expanded (w/o leading image)")
                .primaryTextStyle()

            ExpandableInputCapsuleView(
                text: $ingredientText,
                isExpanded: $isIngredientExpanded,
                placeholder: "Add ingredient",
                collapsedImage: "plus",
                inputContextImage: nil,
                inputActionImage: "plus",
                height: 40,
                iconSize: 16,
                hidesActionWhenExpandedAndEmpty: false,
                onAction: {}
            )
            .frame(width: 280, alignment: .trailing)
        }
    }
}
