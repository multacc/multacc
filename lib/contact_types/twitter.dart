import 'item.dart';

class TwitterItem extends MultaccItem {
  @override
  String getHumanReadableType() {
    return "Twitter";
  }

  @override
  String getHumanReadableValue() {
    return "@" + value;
  }

  @override
  MultaccItemType getType() {
    return MultaccItemType.Twitter;
  }

  @override
  void launchApp() {
    // @todo Implement Twitter launching
  }

  @override
  bool isLaunchable() {
    return true;
  }
}