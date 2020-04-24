import 'package:flutter_test/flutter_test.dart';
import 'package:multacc/items/phone.dart';
import 'package:multacc/items/item.dart';

void main() {
  PhoneItem item;

  group('creating empty PhoneItem', () {
    setUp(() {
      item = PhoneItem();
    });
//    test('initial key should be null', () {
//      expect(item.key, null);
//    });
    test('phone should be null in json', () {
      expect(item.toJson()['no'], null);
    });
//    test('key should initially be null in json', () {
//      expect(item.toJson()[ITEM_KEY_KEY], null);
//    });
    test('updating phone using field should update json', () {
      item.phone = '205-123-4567';
      expect(item.toJson()['no'], '205-123-4567');
    });
    test('updating phone using value setter should update json', () {
      item.value = '615-123-4567';
      expect(item.toJson()['no'], '615-123-4567');
    });
    test('updating key should update json', () {
      item.key = '69';
      expect(item.toJson()[ITEM_KEY_KEY], '69');
    });
    test('initial human-readable value should be empty', () {
      expect(item.humanReadableValue, '');
    });
    test('human-readable value should be phone number', () {
      item.phone = '861-123-4567';
      expect(item.humanReadableValue, '861-123-4567');
    });
    test('type should be Phone', () {
      expect(item.type, MultaccItemType.Phone);
    });
    test('type should be Phone in json', () {
      expect(item.toJson()[ITEM_TYPE_KEY], 'Phone');
    });
    test('icon should not be overridden from type default', () {
      expect(item.icon.icon, item.type.icon.icon);
    });
    test('phone should be launchable', () {
      expect(item.isLaunchable, true);
    });
  });

  group('creating PhoneItem from json', () {
    setUp(() {
      Map<String, dynamic> map = Map();
      map['no'] = '615-615-6155';
      item = PhoneItem.fromJson(map);
    });
    test('phone address should be loaded from json', () {
      expect(item.phone, '615-615-6155');
    });
  });
}