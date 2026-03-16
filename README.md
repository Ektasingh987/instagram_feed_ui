# Instagram Feed Clone

A premium, pixel-perfect replica of the Instagram Home Feed built using Flutter. This project focuses on high-fidelity UI components, smooth animations, and advanced user interactions like Pinch-to-Zoom.

## 🚀 Features

- **Pixel-Perfect UI**: Closely follows the Instagram design system, including typography, iconography, and spacing.
- **Dynamic Home Feed**: A vertically scrolling feed of posts with rich media support.
- **Pinch-to-Zoom Overlay**: A sophisticated interaction that allows users to zoom into images. The image scales beyond its boundaries and overlays the entire UI, with a smooth snap-back animation on release.
- **Media Carousels**: Support for multiple images in a single post using a smooth carousel slider with page indicators.
- **Story Tray**: A horizontal list of user stories at the top of the feed.
- **Mock Data Layer**: A robust repository providing mock data for posts, users, and stories to simulate real-world content.
- **Optimized Image Loading**: Uses `CachedNetworkImage` for efficient caching and smooth loading placeholders.

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: Provider
- **Image Handling**: `cached_network_image`
- **UI Components**: `carousel_slider`, `smooth_page_indicator`
- **Animations**: Custom `AnimationController` and `Matrix4` transformations for premium interaction effects.

## 📦 Project Structure

```text
lib/
├── models/         # Data models for Posts and Users
├── providers/      # State management logic
├── screens/        # Main screen implementations
├── services/       # Data fetching and repository logic
└── widgets/        # Reusable UI components (Post, Zoom Overlay, Story Tray, etc.)
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Android Studio or VS Code with Flutter extensions

### Installation

1.  **Clone the repository**:
    ```bash
    git clone [repository-url]
    cd instagram_feed
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run the application**:
    ```bash
    flutter run
    ```

## 📱 Build

To create a release APK for Android:

```bash
flutter build apk --release
```

The APK will be located at `build/app/outputs/flutter-apk/app-release.apk`.

## 🎨 Design Philosophy

This project aims for **visual excellence**. It avoids default browser/system styles in favor of curated color palettes, modern typography (Inter/Roboto), and subtle micro-animations that make the interface feel alive and premium.
