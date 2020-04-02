import 'package:flutter_test/flutter_test.dart';
import 'package:multacc/items/email.dart';
import 'package:multacc/items/item.dart';

void main() {
  EmailItem item;

  group('creating empty EmailItem', () {
    setUp(() {
      item = EmailItem();
    });
    test('initial key should be null', () {
      expect(item.key, null);
    });
    test('email should be null in json', () {
      expect(item.toJson()['email'], null);
    });
    test('key should initially be null in json', () {
      expect(item.toJson()[ITEM_KEY_KEY], null);
    });
    test('updating email using field should update json', () {
      item.email = 'abc@ijk.xyz';
      expect(item.toJson()['email'], 'abc@ijk.xyz');
    });
    test('updating email using value setter should update json', () {
      item.email = 'def@ijk.xyz';
      expect(item.toJson()['email'], 'def@ijk.xyz');
    });
    test('updating key should update json', () {
      item.key = '69';
      expect(item.toJson()[ITEM_KEY_KEY], '69');
    });
    test('initial human-readable value should be empty', () {
      expect(item.humanReadableValue, '');
    });
    test('human-readable value should be email address', () {
      item.email = 'abc@ijk.xyz';
      expect(item.humanReadableValue, 'abc@ijk.xyz');
    });
    test('type should be Email', () {
      expect(item.type, MultaccItemType.Email);
    });
    test('type should be Email in json', () {
      expect(item.toJson()[ITEM_TYPE_KEY], 'Email');
    });
    test('icon should not be overridden from type default', () {
      expect(item.icon, item.type.icon);
    });
    test('email should be launchable', () {
      expect(item.isLaunchable, true);
    });
    test('launching a null email should throw an exception', () {
      expect(() => item.launchApp(), throwsException);
    });
    test('launching an empty email should throw an exception', () {
      item.email = '';
      expect(() => item.launchApp(), throwsException);
    });
    test('launching a valid email should not throw an exception', () {
      item.email = 'abc@ijk.xyz';
      expect(() => item.launchApp(), returnsNormally);
    });
  });

  group('creating EmailItem from json', () {
    setUp(() {
      Map<String, dynamic> map;
      map['email'] = 'efg@ijk.xyz';
      item = EmailItem.fromJson(map);
    });
    test('email address should be loaded from json', () {
      expect(item.email, 'efg@ijk.xyz');
    });
  });

  test('attempting to construct with an empty map should throw an exception', () {
    expect(() => EmailItem.fromJson(Map<String, dynamic>()), throwsException);
  });
}