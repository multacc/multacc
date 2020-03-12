import 'twitter.dart';
import 'email.dart';
import 'phone.dart';
import 'package:enum_to_string/enum_to_string.dart';

/// MultaccItem interface
abstract class MultaccItem {
  /// Multacc item key for database
  String key;

  MultaccItem() : key = null;

  /// Use this constructor to create a MultaccItem using database values
  factory MultaccItem.fromDB(String key, Map<String, dynamic> json) {
    MultaccItemType type = EnumToString.fromString(MultaccItemType.values, json['_t']);
    MultaccItem item;
    switch (type) {
      case MultaccItemType.Twitter:
        item = TwitterItem.fromJson(json);
        break;
      case MultaccItemType.Phone:
        item = PhoneItem.fromJson(json);
        break;
      case MultaccItemType.Email:
        item = EmailItem.fromJson(json);
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
        throw new FormatException('Type ${json['_t']} is not recognized');
    }
    item.key = key;
    return item;
  }

  /// This should take the map generated by jsonDecode and use it to populate
  /// instance variables (username, etc.)
  MultaccItem.fromJson(Map<String, dynamic> json);

  /// This should return a map with values (other than type) that can be passed to
  /// fromJson to rehydrate an item
  Map<String, dynamic> toMap();

  /// This returns the map that can be passed to fromJson to rehydrate.
  /// This is the map from toMap() but with an added pair for type ('t':'Twitter')
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = toMap();
    map['_t'] = EnumToString.parse(getType());
    return map;
  }

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

  /// Get icon or image asset to display
  dynamic getIcon();
}

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
