import SwiftUI

struct RecipesFilterSheetView: View {
    enum Constants {
        static let horizontalPadding = 20.0
        static let verticalSpacing = 12.0
        static let sectionSpacing = 12.0
        static let cardPadding = 16.0
        static let cardCornerRadius = 24.0
        static let controlHeight = 38.0
        static let controlIconSize = 15.0
        static let closeButtonSize = controlHeight
        static let bottomButtonHeight = controlHeight
        static let controlSpacing = 16.0
        static let dividerHeight = 1.0
        static let servingsMaxValue = 99
    }

    @StateObject private var viewModel: RecipesSheetFilterViewModel

    // Maybe move this to view model when there is more complicated stuff going on
    let onClose: () -> Void
    let onApply: (RecipesFilter) -> Void

    init(
        filters: RecipesFilter,
        onClose: @escaping () -> Void,
        onApply: @escaping (RecipesFilter) -> Void
    ) {
        _viewModel = StateObject(
            wrappedValue: RecipesSheetFilterViewModel(filters: filters)
        )
        self.onClose = onClose
        self.onApply = onApply
    }

    var body: some View {
        VStack(spacing: 0) {
            headerView
            bottomDivider
            scrollableContent
            bottomDivider
            applyButtonSection
        }
        .background(Color.backgroundPrimary)
        .contentShape(Rectangle())
        .onTapGesture {
            dismissKeyboard()
        }
    }

    private var scrollableContent: some View {
        ScrollView(showsIndicators: false) {
            contentStack
                .padding(.horizontal, Constants.horizontalPadding)
                .padding(.top, Constants.verticalSpacing)
                .padding(.bottom, Constants.horizontalPadding)
        }
    }

    private var contentStack: some View {
        VStack(alignment: .leading, spacing: Constants.verticalSpacing) {
            groupedControlsSection
            includeIngredientsSection
            excludeIngredientsSection
            instructionSection
        }
    }

    private var headerView: some View {
        HStack {
            Text("Filter")
                .headerTextStyle()

            Spacer()

            CircularIconButtonView(
                systemImage: "xmark",
                size: Constants.closeButtonSize,
                iconSize: Constants.controlIconSize,
                action: onClose
            )
        }
        .padding(.horizontal, Constants.horizontalPadding)
        .padding(.top, Constants.horizontalPadding)
        .padding(.bottom, 12)
        .background(Color.foregroundPrimary)
    }

    private var groupedControlsSection: some View {
        VStack(spacing: 8) {
            groupedControlRow(
                title: "Servings",
                control: {
                    IncrementControlView(
                        value: $viewModel.filters.servings,
                        minimumValue: 0,
                        maximumValue: Constants.servingsMaxValue,
                        zeroValuePlaceholder: "Any"
                    )
                }
            )
            .padding(.horizontal, Constants.cardPadding)

            bottomDivider

            groupedControlRow(
                title: "Vegetarian",
                control: {
                    SwitchControlView(isOn: $viewModel.filters.vegetarianOnly)
                }
            )
            .padding(.horizontal, Constants.cardPadding)
        }
        .padding(.vertical, Constants.cardPadding)
        .background(Color.foregroundPrimary)
        .clipShape(
            RoundedRectangle(
                cornerRadius: Constants.cardCornerRadius,
                style: .continuous
            )
        )
    }

    private func groupedControlRow<Control: View>(
        title: String,
        @ViewBuilder control: () -> Control
    ) -> some View {
        HStack(spacing: Constants.controlSpacing) {
            Text(title)
                .primaryTextStyle()

            Spacer()

            control()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var includeIngredientsSection: some View {
        TagListView(
            title: "Include Ingredients",
            placeholder: "Add ingredient",
            tags: $viewModel.filters.includeIngredients,
            isInputExpanded: $viewModel.isIncludeIngredientsInputExpanded,
            inputText: $viewModel.includeIngredientsInputText,
            isActionEnabled: viewModel.canAddIncludeIngredient,
            onSubmitTag: viewModel.addIncludeIngredient
        )
    }

    private var excludeIngredientsSection: some View {
        TagListView(
            title: "Exclude Ingredients",
            placeholder: "Exclude ingredient",
            tags: $viewModel.filters.excludeIngredients,
            isInputExpanded: $viewModel.isExcludeIngredientsInputExpanded,
            inputText: $viewModel.excludeIngredientsInputText,
            isActionEnabled: viewModel.canAddExcludeIngredient,
            onSubmitTag: viewModel.addExcludeIngredient
        )
    }

    private var instructionSection: some View {
        VStack(alignment: .leading, spacing: Constants.sectionSpacing) {
            Text("Instruction Search")
                .primaryTextStyle()

            ExpandableInputCapsuleView(
                text: $viewModel.instructionQueryInputText,
                isExpanded: .constant(true),
                placeholder: "Search within instructions",
                collapsedImage: "magnifyingglass",
                inputContextImage: "magnifyingglass",
                inputActionImage: "xmark",
                height: Constants.controlHeight,
                iconSize: Constants.controlIconSize,
                hidesActionWhenExpandedAndEmpty: false,
                managesFocus: false,
                onAction: {
                    viewModel.clearInstructionQuery()
                }
            )
        }
        .padding(Constants.cardPadding)
        .background(Color.foregroundPrimary)
        .clipShape(
            RoundedRectangle(
                cornerRadius: Constants.cardCornerRadius,
                style: .continuous
            )
        )
    }

    private var bottomDivider: some View {
        Rectangle()
            .fill(Color.divider)
            .frame(height: Constants.dividerHeight)
    }

    private var applyButtonSection: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Button(action: resetFilters) {
                    Text("Reset")
                        .font(.headline)
                        .foregroundStyle(Color.accentOrange)
                        .frame(maxWidth: .infinity)
                        .frame(height: Constants.bottomButtonHeight)
                        .background(Color.foregroundPrimary)
                        .overlay {
                            Capsule()
                                .stroke(Color.accentOrange, lineWidth: 1)
                        }
                        .clipShape(Capsule())
                }

                Button(action: applyFilters) {
                    Text("Apply")
                        .font(.headline)
                        .foregroundStyle(Color.foregroundPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: Constants.bottomButtonHeight)
                        .background(Color.accentOrange)
                        .clipShape(Capsule())
                }
            }
            .buttonStyle(.plain)
            .padding(.horizontal, Constants.horizontalPadding)
            .padding(.vertical, 16)
        }
        .background(Color.foregroundPrimary)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }

    private func applyFilters() {
        onApply(viewModel.appliedFilters)
    }

    private func resetFilters() {
        withAnimation(.easeInOut(duration: 0.2)) {
            viewModel.resetFilters()
        }
        dismissKeyboard()
    }
}

#Preview {
    PreviewContainer()
        .background(Color.backgroundPrimary)
}

private struct PreviewContainer: View {
    var body: some View {
        RecipesFilterSheetView(
            filters: RecipesFilter(),
            onClose: {},
            onApply: { _ in }
        )
    }
}
