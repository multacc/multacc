import 'package:flutter_test/flutter_test.dart';
import 'package:multacc/items/facebook.dart';
import 'package:multacc/items/item.dart';

void main() {
  FacebookItem item;

  group('creating empty FacebookItem', () {
    setUp(() {
      item = FacebookItem();
    });
    test('initial key should be nonempty', () {
      expect(item.key, isNotEmpty);
    });
    test('facebook should be null in json', () {
      expect(item.toJson()['username'], '');
      expect(item.toJson()['id'], null);
    });
    test('key should initially be nonempty in json', () {
      expect(item.toJson()[ITEM_KEY_KEY], isNotEmpty);
    });
    test('updating username using field should update json', () {
      item.username = 'Micah White';
      expect(item.toJson()['username'], 'Micah White');
    });
    test('updating username using value setter should update json', () {
      item.value = 'Micah White';
      expect(item.toJson()['username'], 'Micah White');
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
    test('type should be Facebook', () {
      expect(item.type, MultaccItemType.Facebook);
    });
    test('type should be Facebook in json', () {
      expect(item.toJson()[ITEM_TYPE_KEY], 'Facebook');
    });
    test('icon should not be overridden from type default', () {
      expect(item.icon.icon, item.type.icon.icon);
    });
    test('username should be launchable', () {
      expect(item.isLaunchable, true);
    });
  });

  group('creating FacebookItem from json', () {
    setUp(() {
      Map<String, dynamic> map = Map();
      map['username'] = 'John Cena';
      item = FacebookItem.fromJson(map);
    });
    test('username should be loaded from json', () {
      expect(item.username, 'John Cena');
    });
  });
}