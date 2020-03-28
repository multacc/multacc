# multacc
A flutter app that integrates communication platforms and lets you consolidate all your contact info into a single "profile".

## structure
- assets: fonts, icons, etc
- lib
  - main.dart: sets up colors, bottom bar, navigation
  - pages: contains folders for every screen
  - common: constants, styles, routes, common widgets/logic, etc
  - database: interface for hivedb
  - items: data models
- test: unit tests, widget tests
- .github/workflows: automated tests/build using github actions

## state management
- Use mobx for state management: define services for all data
- Use hivedb to store shared prefs
- Use `GetIt.I` to make data persist globally in a singleton
- Use provider package where mobx is not suitable
- See "lifting state up"

## conventions
- Tab width = 2 spaces
- All constants either use SCREAMING_CAPS or start with k
- Line length is 120
- Single quotes for strings
- Dart/Prettier automatically formats the code if there are proper trailing commas

## build & run
- Generate mobx code using build runner: `flutter packages pub run build_runner build -v`
- Debug app using IDE or run `flutter run`

### misc
- Use `beta` channel of flutter and run `flutter config --enable-web` to be able to debug in Chrome
- Run `flutter pub run flutter_launcher_icons:main` to generate app icons (see pubspec.yaml)