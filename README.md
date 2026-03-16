# RecimeLite

RecimeLite is a SwiftUI iOS sample app focused on browsing recipes, searching with filters, viewing recipe details.

## Demo

[Watch Demo Here](https://drive.google.com/file/d/1TdEqoZDddVZ6JM8PH-B51T_A85S3uoBy/view?usp=sharing)

## Setup Instructions

### Requirements

- Xcode 26 or newer
- iOS Simulator or physical iPhone
- Swift Package Manager access for dependencies

### Run the App

1. Open RecimeLite.xcodeproj.
2. Let Xcode resolve Swift Package dependencies.
3. Select the `RecimeLite` scheme.
4. Build and run on a simulator or device.

### Dependencies

- `Alamofire`
- `Lottie`

### Mock Data

In `DEBUG`, the recipe flows currently use bundled mock JSON instead of a live backend.

Relevant files:

- recipes.json
- recipe_search_results.json

## High-Level Architecture Overview

The app uses a lightweight layered architecture with clear separation between UI, domain, and networking concerns.

### Main Layers

- `Domain`
  - Feature views, view models, models, repositories, services, requests, and use cases.
- `Core`
  - Shared networking primitives such as `NetworkClient`, request contracts, mock loading, and network errors.
- `Extensions`
  - Shared view styling and convenience helpers.
- `Resource` / `Mock`
  - Bundled assets such as the CV PDF and mock API payloads.

### Feature Flow

For recipe data, the typical flow is:

`View -> ViewModel -> UseCase -> Repository -> Service -> NetworkClient / MockResponseProvider`

This is using MVVM + Clean architecture.

Examples:

- `RecipesView` drives loading, debounced search, and filter presentation.
- `RecipesViewModel` coordinates fetch/search use cases.
- `RecipeRepository` and `RecipeService` hide transport details from the UI layer.
- `NetworkClient` handles real requests, while `MockResponseProvider` serves local JSON in debug mode.

### UI Structure

- `HomeView` is the root shell.
- Top-level sections are kept alive in a custom tab container.
- Shared UI elements such as branded headers, circular buttons, capsule inputs, switch controls, increment controls, and tag lists are extracted into reusable views under `Domain/Generic`.

## Key Design Decisions

### Custom Bottom Bar

The app uses a custom floating bottom bar instead of `TabView`.

### Use Case + Repository Separation

Recipe fetch and search actions are routed through use cases and repositories instead of calling services directly from views.

### Debug Mock Networking

Recipe APIs currently use local JSON in debug mode.

### Reusable UI Components

Common control patterns were extracted into reusable components such as:

- `ExpandableInputCapsuleView`
- `IncrementControlView`
- `SwitchControlView`
- `TagListView`
- `CircularIconButtonView`
- `BrandTitleSwapView`

## Assumptions and Tradeoffs

### Assumptions

- Mock data shape is representative of the eventual backend contract.
- Mock data for search will only return the same response, since making a working backend is out of scope.
- Dietary attributes are provided as a list of strings.
- A servings value of `0` means “Any” and should not be sent to the search query.

### Tradeoffs

- The project currently prioritizes UX iteration and clear feature layering over exhaustive abstraction.
- The custom tab shell gives more design control, but it also means some system tab/navigation behaviors are managed manually.
- Debug logging for mock requests/responses is intentionally verbose to help development, but it would be too noisy for production paths.
- Used a custom bar and navigation header to make the app customizable as possible, as utilizing iOS' native bars limits customizability as from my experience.

## Known Limitations

- The app currently depends heavily on local mocks for recipe fetch/search behavior in debug mode.
- Some custom UIKit-backed text input behavior was introduced to avoid SwiftUI keyboard/focus issues, so that area may need extra regression testing.
- Little routing and dependency injection structure is applied due to scope.

## Project Structure

```text
RecimeLite/
  RecimeLite/
    App/
    Core/
    Domain/
    Extensions/
    Mock/
    Resource/
    Root/
  RecimeLiteTests/
  RecimeLiteUITests/
```

## Notes

- I've put my CV in the About screen, if you want to take a look :D
- Used Codex for assistive coding
- Recreated Icons
- Created Lottie animation for Splash Screen
