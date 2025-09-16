# Smart App - Frontend (Flutter)

This module contains the user interface for the Smart App application. It is built with **Flutter** and is designed to be **cross-platform**, running on Android, iOS, and Web from a single codebase.

## ✨ Features

-   **Modern Framework**: Developed with the latest stable version of Flutter.
-   **Cross-Platform**: A single UI for Android, iOS, and Web.
-   **Responsive UI**: Layouts that elegantly adapt to smartphone screens and desktop browsers.
-   **Animated Design**: Smooth and modern animations on the login page for a high-quality user experience.
-   **State Management**: Utilizes the `provider` package for clean and predictable authentication state management.
-   **API Integration**: Communicates with the Spring Boot backend for all authentication and user data operations.
-   **Secure Storage**: The session token (JWT) is securely saved on the device using `flutter_secure_storage`.
-   **Secure Configuration**: The Google Client ID is managed externally via a `.env` file and a reference template.

## 🛠️ Prerequisites

### Windows, macOS & Linux

1.  **Flutter SDK**: The complete Flutter development environment.
    -   Follow the [official installation guide](https://docs.flutter.dev/get-started/install) for your operating system.
    -   Run `flutter doctor` in your terminal to ensure your installation is correct.
2.  **Setup for Android/iOS**: To run on a mobile emulator, follow the Flutter guide to install Android Studio (for Android) and/or Xcode (for macOS/iOS).

## ⚙️ Sensitive Data Configuration

Before running the application, you must configure the Google Client ID.

1.  Navigate to the `frontend` root directory.
2.  Find the `.env.template` file.
3.  **Create a copy** of this file and rename it to **`.env`**.
4.  Open the new `.env` file and **replace the placeholder** with your actual Web Client ID.

The `.env` file is already included in the `.gitignore` and will never be committed.

## 🚀 Running in Debug Mode (VS Code)

1.  **Open the Folder**: Open the `frontend` folder directly in VS Code (or use the multi-root workspace).
2.  **Install Extensions**: Make sure you have the `Flutter` and `Dart` extensions installed.
3.  **Fetch Dependencies**: Open an integrated terminal (`Ctrl+Shift+` \` ``) and run:
    ```bash
    flutter pub get
    ```
4.  **Select a Device**: In the blue status bar at the bottom-right, click the device selector and choose a target (e.g., `Chrome` for web, or a running Android/iOS emulator).
5.  **Start Debugging**:
    -   Go to the "Run and Debug" view (🐞 icon).
    -   In the top dropdown menu, select the desired launch configuration (e.g., `Web (normal)` or `Mobile`).
    -   Press `F5` or the Play button (▶️).