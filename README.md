# Vitals

## Project Setup

1. **Clone the repository:**
    ```sh
    git clone https://github.com/your-repo/flutter-firebase-app.git
    cd flutter-firebase-app
    ```

2. **Install dependencies:**
    ```sh
    flutter pub get
    ```

3. **Set up Firebase using FlutterFire CLI:**
    - Install the FlutterFire CLI:
      ```sh
      dart pub global activate flutterfire_cli
      ```
    - Configure Firebase for your Flutter app:
      ```sh
      flutterfire configure
      ```
    - Follow the prompts to select your Firebase project and platforms (Android/iOS). The CLI will automatically download and configure the `google-services.json` and `GoogleService-Info.plist` files for you.

4. **Configure Firebase in your Flutter app:**
    - Add the Firebase dependencies to your `pubspec.yaml` file:
      ```yaml
      dependencies:
         firebase_core: latest_version
         firebase_auth: latest_version
         cloud_firestore: latest_version
      ```
    - Initialize Firebase in your `main.dart` file:
      ```dart
      import 'package:firebase_core/firebase_core.dart';

      void main() async {
         WidgetsFlutterBinding.ensureInitialized();
         await Firebase.initializeApp();
         runApp(MyApp());
      }
      ```

## Running the App

1. **Run the app on an emulator or physical device:**
    ```sh
    flutter run
    ```

## Design Decisions

- **Flutter:** Chosen for its cross-platform capabilities, allowing the app to run on both Android and iOS with a single codebase.
- **Firebase:** Selected as the backend for its real-time database, authentication, and hosting services, which streamline the development process.
- **State Management:** Utilized Provider for state management due to its simplicity and integration with Flutter's widget tree.
- **Architecture:** Followed the MVC (Model-View-Controller) pattern to separate business logic from UI, making the codebase more maintainable and testable.


