import 'package:flutter_test/flutter_test.dart';
import 'package:multacc/items/twitter.dart';
import 'package:multacc/items/item.dart';

void main() {
  TwitterItem item;

  group('creating empty TwitterItem', () {
    setUp(() {
      item = TwitterItem();
    });
//    test('initial key should be null', () {
//      expect(item.key, null);
//    });
    test('twitter should be null in json', () {
      expect(item.toJson()['username'], null);
      expect(item.toJson()['id'], null);
    });
//    test('key should initially be null in json', () {
//      expect(item.toJson()[ITEM_KEY_KEY], null);
//    });
    test('updating twitter using field should update json', () {
      item.username = 'humblebeast';
      item.userId = 'Micah White';
      expect(item.toJson()['username'], 'humblebeast');
      expect(item.toJson()['id'], 'Micah White');
    });
    test('updating twitter using value setter should update json', () {
      item.value = 'humblebeast';
      expect(item.toJson()['username'], 'humblebeast');
    });
    test('updating key should update json', () {
      item.key = '69';
      expect(item.toJson()[ITEM_KEY_KEY], '69');
    });
    test('initial human-readable value should be empty', () {
      expect(item.humanReadableValue, '');
    });
    test('human-readable value should be twitter handle', () {
      item.username = 'humblebeast';
      expect(item.humanReadableValue, '@humblebeast');
    });
    test('type should be Twitter', () {
      expect(item.type, MultaccItemType.Twitter);
    });
    test('type should be Twitter in json', () {
      expect(item.toJson()[ITEM_TYPE_KEY], 'Twitter');
    });
    test('icon should not be overridden from type default', () {
      expect(item.icon.icon, item.type.icon.icon);
    });
    test('twitter should be launchable', () {
      expect(item.isLaunchable, true);
    });
  });

  group('creating TwitterItem from json', () {
    setUp(() {
      Map<String, dynamic> map = Map();
      map['username'] = 'humblebeast';
      map['id'] = 'Micah White';
      item = TwitterItem.fromJson(map);
    });
    test('twitter should be loaded from json', () {
      expect(item.username, 'humblebeast');
      expect(item.userId, 'Micah White');
    });
  });
}
