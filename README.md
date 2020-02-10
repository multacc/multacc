# multacc
multacc

## structure
- lib
  - main.dart: sets up colors, bottom bar, navigation
  - pages: contains files for every screen
  - common: constants, styles, routes, etc
  - components: custom widgets

## state management
- Use the provider package to ensure there are mostly stateless widgets
- Define a `ChangeNotifier` for all models
- Use `ChangeNotiferProvider` and `Consumer` to access state
- See "lifting state up"

## conventions
- All constants start with k
- Dart/Prettier automatically formats the code if there are trailing commas.

## build & run
Use `beta` channel of flutter and run `flutter config --enable-web` to be able to debug in Chrome.