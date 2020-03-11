import 'twitter.dart';
import 'phone.dart';
import 'email.dart';

/// MultaccItem interface
abstract class MultaccItem {
  /// Multacc item key for database
  String key;

  MultaccItem() : key = null;

  /// Use this constructor to create a MultaccItem using database values
  factory MultaccItem.fromDB(String key, Map<String, dynamic> json) {
    MultaccItemType type = MultaccItemType.values[json['type']];
    MultaccItem item;
    switch (type) {
      case MultaccItemType.Twitter:
        item = TwitterItem.fromJson(json);
        break;
      case MultaccItemType.Snapchat:
//        item = SnapchatItem.fromJson(json);
        break;
      case MultaccItemType.Instagram:
//        item = InstagramItem.fromJson(json);
        break;
      case MultaccItemType.Facebook:
//        item = FacebookItem.fromJson(json);
        break;
      case MultaccItemType.Discord:
//        item = DiscordItem.fromJson(json);
        break;
      case MultaccItemType.Dogecoin:
//        item = DogecoinItem.fromJson(json);
        break;
      default:
        throw new FormatException('Type index ${json['type']} is not recognized');
    }
    item.key = key;
    return item;
  }

  /// This should take the map generated by jsonDecode and use it to populate
  /// instance variables (username, etc.)
  /// Must include 'type': getType().index
  MultaccItem.fromJson(Map<String, dynamic> json);

  /// This should return a map that can be passed to the constructor to
  /// rehydrate this item in the future.
  Map<String, dynamic> toJson();

  /// Launch the relevant app to message someone
  void launchApp() {}

  /// Boolean indicating whether calling launchApp() will do something useful
  bool isLaunchable() => false;

  /// Get item type (from MultaccItemType enum; index will be stored in database)
  MultaccItemType getType();

  /// Get human-readable item type for display
  String getHumanReadableType();

  /// Get human-readable item type (Snapchat, etc.) to display
  String getHumanReadableValue();

// @todo Frontend team should add something like getIcon to MultaccItem
}

// To maintain the relationship between type and enum index, never remove things from this enum and always add new
// things at the end pls kthx
enum MultaccItemType {
  Twitter,
  Snapchat, // @todo Implement snapchat
  Instagram, // @todo Implement instagram
  Facebook, // @todo Implement facebook
  Discord, // @todo Implement discord
  Dogecoin, // @todo Implement dogecoin
  Phone,
  Email
}
