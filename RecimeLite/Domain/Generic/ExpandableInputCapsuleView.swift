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

    let placeholder: String
    let collapsedSystemImage: String
    let expandedLeadingSystemImage: String?
    let actionSystemImage: String
    let height: CGFloat
    let iconSize: CGFloat
    let hidesActionWhenExpandedAndEmpty: Bool
    let onAction: () -> Void

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: Constants.contentSpacing) {
            if isExpanded, let expandedLeadingSystemImage {
                Image(systemName: expandedLeadingSystemImage)
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
        isExpanded ? actionSystemImage : collapsedSystemImage
    }

    private var actionOpacity: Double {
        if hidesActionWhenExpandedAndEmpty && isExpanded && text.isEmpty {
            return 0
        }

        return 1
    }
}
