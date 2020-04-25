# Multacc
A flutter app that integrates communication platforms and lets you consolidate all your contact info into a single "profile".

### Main Files: Project Structure

  ```sh
  ├── assets/
  ├── pubspec.yaml *** "flutter pub get"
  ├── test/  ** "flutter test"
  ├── firebase/
  │   ├── functions/
  ├── android/
  ├── ios/
  ├── lib
  │   ├── pages/ *** has folders for every screen
  │   │   └── home_page.dart
  │   ├── common/
  │   ├── database/
  │   ├── sharing/
  │   ├── items/
  │   └── main.dart
  └── README.md
  ```

Overall:
* `common/` contains constants, common widgets, auth, etc
* `pages/home_page.dart`is where much of the app initialization and navigation logic is located
* `main.dart` has code that must be run before the first widget is randered
* `firebase/functions` and `lib/sharing/` have the code for all sharing funtionality
* `android/` and `ios/` are where platform-specific code go

## Important libraries used
- `mobx` for global state management (and `mobx_codegen` for generating code)
- `hive` for local database (and `hive_generator` for generating code)
- `get_it` as the service locator for global singletons
- `contacts_service` for accessing device (native) contacts
- firebase for backend needs

## Build & run
- Generate mobx code using build runner: `flutter pub run build_runner build`
- Debug app using IDE or run `flutter run`
