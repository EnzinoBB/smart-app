# Smart App - Backend (Spring Boot)

This module contains the REST API for the Smart App application. It is built with **Spring Boot**, **Java**, and interfaces with a **MySQL** database. It provides secure user management, authentication, and user profile services.

## ✨ Features

-   **RESTful API**: Follows REST conventions for endpoint design.
-   **Robust Security**: Utilizes **Spring Security** with a stateless architecture based on **JWT**.
-   **Multiple Authentication Methods**:
    -   Standard login with email and password (hashed with BCrypt).
    -   Registration with an **email confirmation** flow.
    -   Token validation for **Google Sign-In**.
-   **Data Persistence**: Uses **Spring Data JPA (Hibernate)** to communicate with a **MySQL** database.
-   **API Documentation**: Automatically generates interactive documentation with **Swagger (OpenAPI 3)**.
-   **Secure Configuration**: Isolates sensitive data in a properties file that is not tracked by Git, with a template for easy setup.

## 🛠️ Prerequisites

### Windows, macOS & Linux

1.  **Java Development Kit (JDK)**: Version 17 or later (21 LTS is recommended).
2.  **Apache Maven**: For dependency management and builds.
3.  **MySQL Database**: A running instance of MySQL Server.
    -   Ensure you have created an empty database named `smart_wallet_db`.

## ⚙️ Sensitive Data Configuration

Before running the application, you must configure your sensitive data.

1.  Navigate to the `src/main/resources/` directory.
2.  Find the `application-secrets.properties.template` file.
3.  **Create a copy** of this file and rename it to **`application-secrets.properties`**.
4.  Open the new `application-secrets.properties` file and **replace the placeholders** with your actual credentials.

The `application-secrets.properties` file is already included in the `.gitignore` and will never be committed. The template file, however, remains in the repository as a setup reference.

## 🚀 Running in Debug Mode (VS Code)

1.  **Open the Folder**: Open the `backend` folder directly in VS Code (or use the multi-root workspace).
2.  **Install Extensions**: Make sure you have the `Extension Pack for Java` and `Spring Boot Extension Pack` installed.
3.  **Start the Application**:
    -   Navigate to the `src/main/java/com/smartwallet/backend/BackendApplication.java` file.
    -   Click on **Debug** above the `main` method.
    -   The output will appear in the "TERMINAL" panel.

## 📖 API Documentation (Swagger)

Once the server is running, you can access the interactive API documentation by navigating your browser to:

[http://localhost:8080/api/swagger-ui.html](http://localhost:8080/api/swagger-ui.html)