// MultaccItem interface & default implementation for "Other" items
abstract class MultaccItem {
  String value; // Machine-readable item value (username, etc.) to be stored in the database
  String key; // Multacc item key for database

  /// Launch the relevant app to message someone
  void launchApp() {}

  /// Boolean indicating whether calling launchApp() will do something
  bool isLaunchable() {
    return false;
  }

  /// Get item type (from MultaccItemType enum; index will be stored in database)
  MultaccItemType getType();

  /// Get human-readable item type for display
  String getHumanReadableType();

  /// Get human-readable item type (Snapchat, etc.) to display
  String getHumanReadableValue() {
    return value;
  }

  // @todo Frontend team should add something like getIcon to MultaccItem
}

enum MultaccItemType {
  Twitter,
  Snapchat, // @todo Implement snapchat
  Instagram, // @todo Implement instagram
  Facebook, // @todo Implement facebook
  Discord, // @todo Implement discord
  Dogecoin // @todo Implement dogecoin
}