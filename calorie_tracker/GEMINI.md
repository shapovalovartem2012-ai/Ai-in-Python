# Calorie Tracker App

A simple, minimalist calorie counting app built with Flutter.

## Tech Stack
-   **Framework**: Flutter
-   **Language**: Dart
-   **State Management**: Provider
-   **Navigation**: GoRouter
-   **Local Storage**: Hive
-   **UI Components**: Material 3 (Customized)

## Features
-   **User Profile**: Calculate BMR/TDEE based on age, gender, height, weight.
-   **Daily Diary**: Track food items.
-   **Progress Tracking**: Visual indicator of remaining calories.
-   **Quick Add**: Manual entry and Favorites system.
-   **PRO Mode**: Placeholder for premium features.

## Architecture
-   `lib/models`: Data models (Hive objects).
-   `lib/providers`: State management logic.
-   `lib/screens`: UI screens.
-   `lib/widgets`: Reusable widgets.

## Routes
-   `/`: Splash
-   `/onboarding`: Setup
-   `/home`: Dashboard
-   `/add-food`: Add entry
-   `/profile`: Settings

## Setup
1.  Run `flutter pub get`
2.  Run `flutter run`
