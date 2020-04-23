import 'package:flutter_test/flutter_test.dart';
import 'package:multacc/items/text.dart';
import 'package:multacc/items/item.dart';

void main() {
  TextItem item;

  group('creating empty TextItem', () {
    setUp(() {
      item = TextItem();
    });
    test('initial key should be null', () {
      expect(item.key, null);
    });
    test('text should be null in json', () {
      expect(item.toJson()['v'], null);
    });
    test('key should initially be null in json', () {
      expect(item.toJson()[ITEM_KEY_KEY], null);
    });
    test('updating username using field should update json', () {
      item.text = 'Micah White';
      expect(item.toJson()['v'], 'Micah White');
    });
    test('updating username using value setter should update json', () {
      item.value = 'Micah White';
      expect(item.toJson()['v'], 'Micah White');
    });
    test('updating key should update json', () {
      item.key = '69';
      expect(item.toJson()[ITEM_KEY_KEY], '69');
    });
    test('initial human-readable value should be empty', () {
      expect(item.humanReadableValue, '');
    });
    test('human-readable value should be username', () {
      item.text = 'Mayank Agarwal';
      expect(item.humanReadableValue, 'Mayank Agarwal');
    });
    test('type should be Text', () {
      expect(item.type, MultaccItemType.Text);
    });
    test('type should be Text in json', () {
      expect(item.toJson()[ITEM_TYPE_KEY], 'Text');
    });
    test('icon should not be overridden from type default', () {
      expect(item.icon.icon, item.type.icon.icon);
    });
    test('text should not be launchable', () {
      expect(item.isLaunchable, false);
    });
  });

  group('creating TextItem from json', () {
    setUp(() {
      Map<String, dynamic> map = Map();
      map['v'] = 'John Cena';
      item = TextItem.fromJson(map);
    });
    test('text should be loaded from json', () {
      expect(item.text, 'John Cena');
    });
  });
}