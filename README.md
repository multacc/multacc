# multacc
multacc

## structure
- assets: fonts, icons, etc
- lib
  - main.dart: sets up colors, bottom bar, navigation
  - pages: contains folders for every screen
  - common: constants, styles, routes, etc

## state management
- Use mobx for state management: define services for all data
- Use GetIt.I to make data persist globally in a singleton
- Use provider package where mobx is not suitable
- See "lifting state up"

## conventions
- All constants start with k
- Line length is 120
- Single quotes for strings
- Dart/Prettier automatically formats the code if there are trailing commas

## build & run
- Generate mobx code using build runner: `flutter packages pub run build_runner build -v`
- Use `beta` channel of flutter and run `flutter config --enable-web` to be able to debug in Chrome