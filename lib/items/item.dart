import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hive/hive.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:uuid/uuid.dart';

import 'package:multacc/database/type_ids.dart';
import 'package:multacc/items/facebook.dart';
import 'package:multacc/items/twitter.dart';
import 'package:multacc/items/email.dart';
import 'package:multacc/items/phone.dart';
import 'package:multacc/items/url.dart';
import 'package:multacc/items/text.dart';
import 'package:multacc/items/instagram.dart';
import 'package:multacc/items/snapchat.dart';

// must match functions/src/schema.ts
const ITEM_TYPE_KEY = '_t';
const ITEM_KEY_KEY = '_id';

/// MultaccItem interface
abstract class MultaccItem {
  /// Multacc item key for database
  String key;

  MultaccItem() : key = Uuid().v4();

  /// Use this constructor to create a MultaccItem using database values
  factory MultaccItem.fromDB(Map<String, dynamic> json) {
    MultaccItemType type = EnumToString.fromString(MultaccItemType.values, json[ITEM_TYPE_KEY]);
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
        item = SnapchatItem.fromJson(json);
        break;
      case MultaccItemType.Instagram:
        item = InstagramItem.fromJson(json);
        break;
      case MultaccItemType.Facebook:
        item = FacebookItem.fromJson(json);
        break;
      case MultaccItemType.Discord:
//        item = DiscordItem.fromJson(json);
        break;
      case MultaccItemType.Dogecoin:
//        item = DogecoinItem.fromJson(json);
        break;
      case MultaccItemType.URL:
        item = URLItem.fromJson(json);
        break;
      case MultaccItemType.Text:
        item = TextItem.fromJson(json);
        break;
      default:
        throw new FormatException('Type ${json[ITEM_TYPE_KEY]} is not recognized');
    }
    item.key = json[ITEM_KEY_KEY];
    if ((item.key ?? '') == '') {
      item.key = Uuid().v4();
    }
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
    map[ITEM_TYPE_KEY] = EnumToString.parse(type);
    key = ((key ?? '') == '') ? Uuid().v4() : key;
    map[ITEM_KEY_KEY] = key;
    return map;
  }

  String toString() => jsonEncode(this);

  /// Launch the relevant app to message someone
  void launchApp() {}

  /// Boolean indicating whether calling launchApp() will do something useful
  bool get isLaunchable => false;

  /// Get item type (from MultaccItemType enum; index will be stored in database)
  MultaccItemType get type;

  /// Get human-readable item type (Snapchat, etc.) to display
  String get humanReadableValue => '';

  /// Get item icon
  /// Override this implementation if the icon is dependent on the value of the item
  dynamic get icon => type.icon;

  /// Set the value of this item from manual input
  set value(String item);
}

enum MultaccItemType {
  Twitter,
  Snapchat,
  Instagram,
  Facebook,
  Discord, // @todo Implement discord
  Dogecoin, // @todo Implement dogecoin
  Phone,
  Email,
  URL,
  Text
}

extension MultaccItemTypeInfo on MultaccItemType {
  /// Get icon or image asset to display
  Icon get icon {
    switch (this) {
      case MultaccItemType.Twitter:
        return Icon(MaterialCommunityIcons.twitter);
      case MultaccItemType.Snapchat:
        return Icon(MaterialCommunityIcons.snapchat);
      case MultaccItemType.Instagram:
        return Icon(MaterialCommunityIcons.instagram);
      case MultaccItemType.Facebook:
        return Icon(MaterialCommunityIcons.facebook);
      case MultaccItemType.Discord:
        return Icon(MaterialCommunityIcons.discord);
      case MultaccItemType.Phone:
        return Icon(Icons.phone);
      case MultaccItemType.Email:
        return Icon(Icons.email);
      case MultaccItemType.URL:
        return Icon(Icons.public);
      case MultaccItemType.Text:
        return Icon(MaterialCommunityIcons.text_short);
      default:
        return Icon(Icons.person);
    }
  }

  /// Get human-readable name of type ("Twitter", etc.)
  String get name {
    switch (this) {
      // Add cases here for any types where name should differ from enum alias

      // Use enum alias by default
      default:
        return EnumToString.parse(this);
    }
  }

  /// Connect to this platform
  Connector get connector {
    switch (this) {
      case MultaccItemType.Twitter:
        return TwitterConnector();
      case MultaccItemType.Phone:
        return PhoneConnector();
      default:
        return null;
    }
  }

  /// Determine whether a method exists to connect to this platform
  bool get isConnectable => connector != null;

  /// Determine whether the value setter on an instance of this item is useful
  /// False for things like groupme where there is no meaningful value for a user to type in
  bool get isInputtable {
    switch (this) { // idk if this should be a switch but we can figure it out later
      default:
        return true;
    }
  }

  /// Create an empty item with this type
  MultaccItem createItem() {
    switch (this) {
      case MultaccItemType.Twitter:
        return TwitterItem();
      case MultaccItemType.Snapchat:
        return SnapchatItem();
      case MultaccItemType.Instagram:
        return InstagramItem();
      case MultaccItemType.Facebook:
        return FacebookItem();
      case MultaccItemType.Phone:
        return PhoneItem();
      case MultaccItemType.Email:
        return EmailItem();
      case MultaccItemType.URL:
        return URLItem();
      case MultaccItemType.Text:
      default:
        return TextItem();
    }
  }
}

/// Hive adapter for MultaccItem
class MultaccItemAdapter extends TypeAdapter<MultaccItem> {
  final typeId = MULTACC_ITEM_TYPE_ID;

  MultaccItem read(BinaryReader reader) {
    String json = reader.readString();
    return MultaccItem.fromDB(jsonDecode(json));
  }

  void write(BinaryWriter writer, MultaccItem item) {
    writer.writeString(item.toString());
  }
}

/// Connector class
/// For item types that can be connected (log into platform to detect accounts),
/// implement a connector, add a const default constructor, and add it to MultaccItemTypeInfo.connector above
abstract class Connector {
  /// Return a token or something representing the connection that can be:
  /// * Put in Hive to maintain a connection between sessions
  /// * Passed to get() to get the value from the connection
  dynamic connect();

  /// Use an established connection to get a MultaccItem
  MultaccItem get(dynamic token);
}
