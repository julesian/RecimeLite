import SwiftUI

struct RecipeDetailView: View {
    enum Constants {
        static let verticalSpacing = 6.0
        static let sectionSpacing = 12.0
        static let summarySpacing = 8.0
        static let headerHorizontalPadding = 16.0
        static let headerTopPadding = 20.0
        static let headerBottomPadding = 12.0
        static let controlSize = 38.0
        static let controlIconSize = 15.0
        static let bottomContentInset = 140.0
        static let titleSwapThreshold = 44.0
        static let headerSwapOffset = 8.0
        static let headerSwapAnimationDuration = 0.42
    }

    @StateObject private var viewModel: RecipeDetailViewModel
    @State private var contentOffsetY = 0.0

    @Environment(\.dismiss) private var dismiss

    init(viewModel: RecipeDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    init(recipe: Recipe) {
        _viewModel = StateObject(
            wrappedValue: RecipeDetailViewModel(recipe: recipe)
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            headerView

            scrollContent
        }
        .background(Color.backgroundPrimary)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var scrollContent: some View {
        ScrollView(showsIndicators: false) {
            contentStack
                .padding(.top, Constants.verticalSpacing)
                .padding(.bottom, Constants.bottomContentInset)
        }
        .onScrollGeometryChange(for: CGFloat.self) { geometry in
            geometry.contentOffset.y
        } action: { _, newValue in
            contentOffsetY = newValue
        }
    }

    private var contentStack: some View {
        VStack(alignment: .leading, spacing: Constants.verticalSpacing) {
            summarySection
            ingredientsSection
            instructionsSection
        }
    }

    private var headerView: some View {
        VStack(spacing: 0) {
            headerContent
            .padding(.horizontal, Constants.headerHorizontalPadding)
            .padding(.top, Constants.headerTopPadding)
            .padding(.bottom, Constants.headerBottomPadding)

            Divider()
                .foregroundStyle(.divider)
        }
        .background(Color.foregroundPrimary)
    }

    private var headerContent: some View {
        HStack {
            backButton

            Spacer()

            headerTitleContent

            Spacer()

            trailingHeaderSpacer
        }
    }

    private var backButton: some View {
        CircularIconButtonView(
            systemImage: "chevron.left",
            size: Constants.controlSize,
            iconSize: Constants.controlIconSize,
            action: { dismiss() }
        )
    }

    private var headerTitleContent: some View {
        ZStack {
            RecimeImageView()
                .opacity(showsRecipeTitleInHeader ? 0 : 1)
                .offset(y: showsRecipeTitleInHeader ? -Constants.headerSwapOffset : 0)

            Text(viewModel.title)
                .headerTextStyle()
                .lineLimit(1)
                .opacity(showsRecipeTitleInHeader ? 1 : 0)
                .offset(y: showsRecipeTitleInHeader ? 0 : Constants.headerSwapOffset)
        }
        .animation(
            .easeInOut(duration: Constants.headerSwapAnimationDuration),
            value: showsRecipeTitleInHeader
        )
    }

    private var trailingHeaderSpacer: some View {
        Color.clear
            .frame(width: Constants.controlSize, height: Constants.controlSize)
    }

    private var summarySection: some View {
        VStack(alignment: .leading, spacing: Constants.sectionSpacing) {
            summaryContent

            if !viewModel.dietaryAttributes.isEmpty {
                Divider()
                    .foregroundStyle(.divider)

                dietaryAttributesContent
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.foregroundPrimary)
    }

    private var summaryContent: some View {
        VStack(alignment: .leading, spacing: Constants.sectionSpacing) {
            Text(viewModel.title)
                .headerTextStyle()

            Text(viewModel.description)
                .secondaryTextStyle()

            Text(viewModel.servingsText)
                .teritaryTextStyle()
        }
    }

    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: Constants.sectionSpacing) {
            Text("Ingredients")
                .primaryTextStyle()

            ingredientsList
        }
        .detailSectionStyle()
    }

    private var ingredientsList: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(viewModel.ingredients, id: \.self) { ingredient in
                ingredientRow(for: ingredient)
            }
        }
    }

    private func ingredientRow(for ingredient: RecipeIngredient) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Circle()
                .fill(Color.accentOrange)
                .frame(width: 6, height: 6)
                .padding(.top, 7)

            ingredientTextView(for: ingredient)
        }
    }

    private var instructionsSection: some View {
        VStack(alignment: .leading, spacing: Constants.sectionSpacing) {
            Text("Instructions")
                .primaryTextStyle()

            instructionsList
        }
        .detailSectionStyle()
    }

    private var instructionsList: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(viewModel.instructions.enumerated()), id: \.offset) { index, instruction in
                instructionRow(number: index + 1, instruction: instruction)
            }
        }
    }

    private func instructionRow(number: Int, instruction: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.caption.weight(.bold))
                .foregroundStyle(.foregroundPrimary)
                .frame(width: 24, height: 24)
                .background(Color.accentBlue)
                .clipShape(Circle())

            Text(instruction)
                .secondaryTextStyle()
        }
    }

    private var dietaryAttributesContent: some View {
        VStack(alignment: .leading, spacing: Constants.summarySpacing) {
            Text("Dietary Attributes")
                .primaryTextStyle()

            HStack(spacing: 8) {
                ForEach(viewModel.dietaryAttributes, id: \.self) { attribute in
                    Text(attribute.name)
                        .capsuleTextStyle(
                            foregroundColor: .foregroundPrimary,
                            backgroundColor: color(for: attribute.backgroundColor)
                        )
                }
            }
        }
    }

    private func ingredientTextView(for ingredient: RecipeIngredient) -> some View {
        Group {
            if let measurementText = ingredient.measurementText {
                Text("\(styledMeasurementText(measurementText))\(styledIngredientName(ingredient.name))")
            } else {
                Text(ingredient.name)
                    .secondaryTextStyle()
            }
        }
    }

    private func styledMeasurementText(_ text: String) -> Text {
        Text("\(text) ")
            .font(.subheadline.weight(.bold))
            .foregroundStyle(.textPrimary)
    }

    private func styledIngredientName(_ text: String) -> Text {
        Text(text)
            .font(.subheadline)
            .foregroundStyle(.textSecondary)
    }

    private func color(for colorToken: ColorToken) -> Color {
        switch colorToken {
        case .accentGreen: .accentGreen
        case .accentBlue: .accentBlue
        case .accentOrange: .accentOrange
        case .accentYellow: .accentYellow
        case .accentPurple: .accentPurple
        }
    }

    private var showsRecipeTitleInHeader: Bool {
        contentOffsetY >= Constants.titleSwapThreshold
    }
}

private extension View {
    func detailSectionStyle() -> some View {
        padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.foregroundPrimary)
    }
}

#Preview {
    NavigationStack {
        RecipeDetailView(recipe: Recipe.skeletonSamples[0])
    }
}
