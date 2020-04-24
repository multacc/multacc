import 'package:flutter_test/flutter_test.dart';
import 'package:multacc/items/url.dart';
import 'package:multacc/items/item.dart';

void main() {
  URLItem item;

  group('creating empty URLItem', () {
    setUp(() {
      item = URLItem();
    });
    test('initial key should be nonempty', () {
      expect(item.key, isNotEmpty);
    });
    test('url should be null in json', () {
      expect(item.toJson()['url'], null);
    });
    test('key should initially be nonempty in json', () {
      expect(item.toJson()[ITEM_KEY_KEY], isNotEmpty);
    });
    test('updating url using field should update json', () {
      item.url = 'multacc.com';
      expect(item.toJson()['url'], 'multacc.com');
    });
    test('updating url using value setter should update json', () {
      item.value = 'multacc.com';
      expect(item.toJson()['url'], 'multacc.com');
    });
    test('updating key should update json', () {
      item.key = '69';
      expect(item.toJson()[ITEM_KEY_KEY], '69');
    });
    test('initial human-readable value should be empty', () {
      expect(item.humanReadableValue, '');
    });
    test('human-readable value should be username', () {
      item.url = 'multacc.com';
      expect(item.humanReadableValue, 'multacc.com');
    });
    test('type should be URL', () {
      expect(item.type, MultaccItemType.URL);
    });
    test('type should be URL in json', () {
      expect(item.toJson()[ITEM_TYPE_KEY], 'URL');
    });
    test('icon should not be overridden from type default', () {
      expect(item.icon.icon, item.type.icon.icon);
    });
    test('url should be launchable', () {
      expect(item.isLaunchable, true);
    });
  });

  group('creating URLItem from json', () {
    setUp(() {
      Map<String, dynamic> map = Map();
      map['url'] = 'multacc.com';
      item = URLItem.fromJson(map);
    });
    test('url should be loaded from json', () {
      expect(item.url, 'multacc.com');
    });
  });
}