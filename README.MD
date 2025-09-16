# Smart App - Full-Stack Project

Welcome to Smart App, a secure and modern cross-platform application built with a decoupled frontend and backend architecture.

This repository contains the entire source code for a complete application, featuring a responsive user interface developed in **Flutter** and a robust, secure REST API built with **Spring Boot**.

## Project Structure

The repository is organized into two main modules:

-   **/backend**: A Java application based on Spring Boot that exposes the REST APIs for user management and authentication.
-   **/frontend**: A Flutter application that provides the user interface for Android, iOS, and Web.

## ✨ Key Features

-   **Secure Architecture**: Authentication based on JWT (JSON Web Tokens).
-   **Complete Authentication Flows**:
    -   Standard registration with email/password and email confirmation.
    -   "Sign in with Google" integration for quick access.
-   **Cross-Platform**: The frontend is designed to run on Android, iOS, and Web from a single codebase.
-   **Modern & Responsive UI**: Elegant, animated layouts that adapt to various screen sizes.
-   **API Documentation**: The backend includes Swagger (OpenAPI) for interactive API documentation.
-   **Security Management**: Sensitive data (API keys, passwords) is managed outside the source code and ignored by Git. Template files are provided for easy setup.

## 🛠️ Prerequisites

Ensure you have the following software installed on your system.

### Common to all OS (Windows, macOS, Linux)

1.  **Git**: To clone the repository.
2.  **Visual Studio Code**: The recommended IDE for this project.
    -   **Recommended Extensions**: `Extension Pack for Java`, `Spring Boot Extension Pack`, `Flutter`, `Dart`.
3.  **Java Development Kit (JDK)**: Version 17 or later (21 LTS is recommended).
4.  **Flutter SDK**: To run the frontend.
5.  **MySQL Database**: A locally running MySQL server.

## ⚙️ Initial Setup

Both the `frontend` and `backend` modules require the configuration of sensitive data (like API keys and passwords) which are not included in the repository. To simplify this process, template files have been provided:

-   In the backend, copy `application-secrets.properties.template` to `application-secrets.properties`.
-   In the frontend, copy `.env.template` to `.env`.

**Fill in the new files with your actual data.** For detailed instructions, please refer to the `README.md` files inside each module.

## 🚀 Running the Entire Project in Debug Mode (VS Code)

To work on both modules simultaneously, using a **Multi-root Workspace** in VS Code is essential.

1.  **Open VS Code**: Make sure no other folders are open (`File > Close Folder`).
2.  **Open the Backend Folder**: Go to `File > Open Folder...` and select the `backend` folder of this project.
3.  **Add Frontend to Workspace**: Go to `File > Add Folder to Workspace...` and select the `frontend` folder.
4.  **Save the Workspace**: For faster access in the future, go to `File > Save Workspace As...` and save the file (e.g., `smart-app.code-workspace`) in the project's root folder.

Once the workspace is configured:

1.  **Start the Backend**:
    -   Go to the "Run and Debug" view (🐞 icon).
    -   In the top dropdown menu, select the launch configuration for **Java** (e.g., `Launch BackendApplication`).
    -   Press the Play button (▶️) or `F5`. Wait for the Spring Boot server to start in the terminal.

2.  **Start the Frontend**:
    -   Still in the "Run and Debug" view, select the launch configuration for **Flutter** (e.g., `Web (normal)` or `Mobile`).
    -   Make sure you have selected a target device (e.g., `Chrome` or an emulator) in the bottom-right status bar.
    -   Press the Play button (▶️) or `F5`.