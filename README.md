
<img width="128" height="128" alt="app_icon" src="https://github.com/user-attachments/assets/1a76daa0-2c99-4908-aaad-5abf2168cf84" />

# RecimeLite

RecimeLite is a SwiftUI iOS sample app focused on browsing recipes, searching with filters, viewing recipe details.

<p align="center">
  <img src="https://github.com/user-attachments/assets/21706513-2d85-4e76-a4a4-3aa4de37789a" width="180"/>
  <img src="https://github.com/user-attachments/assets/4fc34878-76c3-422e-b096-75ac67f372f8" width="180"/>
  <img src="https://github.com/user-attachments/assets/b5a8ca82-018a-448f-b15d-a26ec7edc5f9" width="180"/>
  <img src="https://github.com/user-attachments/assets/1222cfaa-4edf-468e-a874-8fee6a56a8f1" width="180"/>
  <img src="https://github.com/user-attachments/assets/2cb861d4-d382-4dff-ba4a-461f0f609b33" width="180"/>
</p>


## Demo

https://github.com/user-attachments/assets/d640d401-777e-44c0-b3f5-8f8e500dba0c
[Clearer version](https://drive.google.com/file/d/1TdEqoZDddVZ6JM8PH-B51T_A85S3uoBy/view?usp=sharing)

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

### How `mockRequest` Is Used

`mockRequest` is used at the service layer, currently in `RecipeService`.

In `DEBUG`, the service calls:

```swift
try await networkClient.mockRequest(
    RecipeRequest.fetchRecipes,
    as: [RecipeResponse].self,
    behavior: .willDeliver(speed: .slow)
)
```

and for search:

```swift
try await networkClient.mockRequest(
    RecipeRequest.searchRecipes(...),
    as: [RecipeResponse].self,
    behavior: .willDeliver(speed: .fast)
)
```

Outside `DEBUG`, the same service uses the real network path with:

```swift
try await networkClient.request(...)
```

So if you want to change a feature between mock and live behavior, the main place to update is:

- `Domain/Recipes/Services/RecipeService.swift`

The mock file name itself comes from the request type:

- `RecipeRequest.fetchRecipes` -> `recipes.json`
- `RecipeRequest.searchRecipes` -> `recipe_search_results.json`

That mapping currently lives in:

- `Domain/Recipes/Requests/RecipeRequest.swift`

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
  - Bundled assets and mock API payloads.

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

- Mock data for search will only return the same response, since making a working backend which does the filter and query logic is out of scope.
- Dietary attributes are provided as a list of strings.
- A servings value of `0` means “Any” and should not be sent to the search query.
- Mock data is simple, I only focused on the ones that I can use to the UI.

### Tradeoffs

- The project currently prioritizes UX iteration and clear feature layering over exhaustive abstraction.
- The custom tab shell gives more design control, but it also means some system tab/navigation behaviors are managed manually.
- Debug logging for mock requests/responses is intentionally verbose to help development, but it would be too noisy for production paths.
- Used a custom bar and navigation header to make the app customizable as possible, as utilizing iOS' native bars limits customizability as from my experience.

## Known Limitations

- The app currently depends heavily on local mocks for recipe fetch/search behavior in debug mode.
- Some custom UIKit-backed text input behavior was introduced to avoid SwiftUI keyboard/focus issues.
- Little routing and dependency injection structure is applied due to scope.
- Not using native iOS navigation bar and bottom bar.

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
