import 'package:flutter_test/flutter_test.dart';
import 'package:multacc/items/snapchat.dart';
import 'package:multacc/items/item.dart';

void main() {
  SnapchatItem item;

  group('creating empty SnapchatItem', () {
    setUp(() {
      item = SnapchatItem();
    });
    test('initial key should be nonempty', () {
      expect(item.key, isNotEmpty);
    });
    test('snapchat should be null in json', () {
      expect(item.toJson()['username'], null);
    });
    test('key should initially be nonempty in json', () {
      expect(item.toJson()[ITEM_KEY_KEY], isNotEmpty);
    });
    test('updating username using field should update json', () {
      item.username = 'MicahWhite';
      expect(item.toJson()['username'], 'MicahWhite');
    });
    test('updating username using value setter should update json', () {
      item.value = 'MicahWhite';
      expect(item.toJson()['username'], 'MicahWhite');
    });
    test('updating key should update json', () {
      item.key = '69';
      expect(item.toJson()[ITEM_KEY_KEY], '69');
    });
    test('initial human-readable value should be empty', () {
      expect(item.humanReadableValue, '');
    });
    test('human-readable value should be username', () {
      item.username = 'Mayank Agarwal';
      expect(item.humanReadableValue, 'Mayank Agarwal');
    });
    test('type should be Snapchat', () {
      expect(item.type, MultaccItemType.Snapchat);
    });
    test('type should be Snapchat in json', () {
      expect(item.toJson()[ITEM_TYPE_KEY], 'Snapchat');
    });
    test('icon should not be overridden from type default', () {
      expect(item.icon.icon, item.type.icon.icon);
    });
    test('username should be launchable', () {
      expect(item.isLaunchable, true);
    });
  });

  group('creating SnapchatItem from json', () {
    setUp(() {
      Map<String, dynamic> map = Map();
      map['username'] = 'John Cena';
      item = SnapchatItem.fromJson(map);
    });
    test('username should be loaded from json', () {
      expect(item.username, 'John Cena');
    });
  });
}