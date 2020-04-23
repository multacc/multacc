import 'package:flutter_test/flutter_test.dart';
import 'package:multacc/items/instagram.dart';
import 'package:multacc/items/item.dart';

void main() {
  InstagramItem item;

  group('creating empty InstagramItem', () {
    setUp(() {
      item = InstagramItem();
    });
    test('initial key should be null', () {
      expect(item.key, null);
    });
    test('instagram should be null in json', () {
      expect(item.toJson()['username'], null);
      expect(item.toJson()['id'], null);
    });
    test('key should initially be null in json', () {
      expect(item.toJson()[ITEM_KEY_KEY], null);
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
      item.username = 'MayankAgarwal';
      expect(item.humanReadableValue, '@MayankAgarwal');
    });
    test('type should be Instagram', () {
      expect(item.type, MultaccItemType.Instagram);
    });
    test('type should be Instagram in json', () {
      expect(item.toJson()[ITEM_TYPE_KEY], 'Instagram');
    });
    test('icon should not be overridden from type default', () {
      expect(item.icon.icon, item.type.icon.icon);
    });
    test('username should be launchable', () {
      expect(item.isLaunchable, true);
    });
  });

  group('creating InstagramItem from json', () {
    setUp(() {
      Map<String, dynamic> map = Map();
      map['username'] = 'JohnCena';
      item = InstagramItem.fromJson(map);
    });
    test('username address should be loaded from json', () {
      expect(item.username, 'JohnCena');
    });
  });
}