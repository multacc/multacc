# Multacc [![Codemagic build status](https://api.codemagic.io/apps/5e65e53b5cf30625115db459/5e65e53b5cf30625115db458/status_badge.svg)](https://codemagic.io/apps/5e65e53b5cf30625115db459/5e65e53b5cf30625115db458/latest_build)
A flutter app that integrates communication platforms and lets you consolidate all your contact info into a single "profile".

## Project Structure

  ```sh
  ├── assets/
  ├── firebase/
  │   └── functions/
  ├── android/
  ├── ios/
  ├── lib
  │   ├── pages/
  │   │   ├── chats/
  │   │   ├── contacts/
  │   │   ├── profile/
  │   │   ├── settings/
  │   │   └── home_page.dart
  │   ├── common/
  │   ├── database/
  │   ├── sharing/
  │   ├── items/
  │   └── main.dart
  ├── test/        *** "flutter test"
  └── pubspec.yaml *** "flutter pub get"
  ```

### Overall:
* `lib/` has all the dart code
  * `common/` contains constants, common widgets, auth, etc
  * `pages/home_page.dart`is where much of the app initialization and navigation logic is located
  * `main.dart` has code that must be run before the first widget is rendered
* `firebase/functions/` has the backend code
* `android/` and `ios/` have the platform-specific code

## Important libraries used
- `mobx` for global state management (and `mobx_codegen` for generating code)
- `hive` for local database (and `hive_generator` for generating code)
- `get_it` as the service locator for global singletons
- `contacts_service` for accessing device (native) contacts
- firebase for backend needs

## Build & run
- Make sure you're on the beta channel: `flutter channel beta`
- Generate mobx code using build runner: `flutter pub run build_runner build`
- Debug app using IDE or run `flutter run`
