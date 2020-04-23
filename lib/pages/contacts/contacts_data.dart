import 'package:contacts_service/contacts_service.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';
import 'package:multacc/database/database_interface.dart';
import 'package:multacc/items/item.dart';
import 'package:multacc/database/contact_model.dart';

part 'contacts_data.g.dart';

class ContactsData = _ContactsData with _$ContactsData;

abstract class _ContactsData with Store {
  Box<MultaccContact> _contactsBox;

  _ContactsData() {
    // get cached contacts first (synchronously)
    _contactsBox = GetIt.I.get<DatabaseInterface>().contactsBox;
    allContacts = _contactsBox.values.toList();
  }

  @observable
  List<MultaccContact> allContacts;

  @action
  Future<void> getAllContacts() async {
    // update cache from device contacts
    (await ContactsService.getContacts()).forEach((contact) {
      MultaccContact cachedContact = _contactsBox.get(contact.identifier);
      if (cachedContact == null || !cachedContact.equalsBaseContact(contact)) {
        MultaccContact newContact = MultaccContact.fromContact(contact);

        // update existing contact
        if (cachedContact != null) {
          newContact.multaccItems.addAll(
            cachedContact.multaccItems.where((i) => i.type != MultaccItemType.Phone && i.type != MultaccItemType.Email),
          );
        }

        // refresh database
        _contactsBox.put(newContact.clientKey, newContact);
        this.allContacts = _contactsBox.values.toList();
      }
    });
  }

  @action
  Future<void> deleteContact(MultaccContact contact) async {
    allContacts.remove(contact);
    await _contactsBox.delete(contact.clientKey);
    ContactsService.deleteContact(contact);
  }
}
