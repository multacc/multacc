import 'package:flutter_test/flutter_test.dart';
import 'package:multacc/items/item.dart';


void main() {
  Map<String, dynamic> json;
  setUp(() {
    json = Map<String, dynamic>();
    json[ITEM_KEY_KEY] = 'whatever';
  });

  test('rehydrating a Twitter item should result in a TwitterItem', () {
    json[ITEM_TYPE_KEY] = 'Twitter';
    json['at'] = 'ahaha';
    expect(MultaccItem.fromDB(json).type, MultaccItemType.Twitter);
  });
  test('rehydrating an email item should result in an EmailItem', () {
    json[ITEM_TYPE_KEY] = 'Email';
    json['email'] = 'abc@def.xyz';
    expect(MultaccItem.fromDB(json).type, MultaccItemType.Email);
  });
  test('rehydrating a phone item should result in a PhoneItem', () {
    json[ITEM_TYPE_KEY] = 'Phone';
    json['phone'] = '5555555555';
    expect(MultaccItem.fromDB(json).type, MultaccItemType.Phone);
  });
  test('rehydrating an incomplete item should throw an exception', () {
    expect(() => MultaccItem.fromDB(json), throwsException);
  });
  test('rehydrating an item of unsupported type should throw an exception', () {
    json[ITEM_TYPE_KEY] = 'Platypus';
    expect(() => MultaccItem.fromDB(json), throwsException);
  });
}