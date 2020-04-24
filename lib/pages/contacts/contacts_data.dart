import 'package:contacts_service/contacts_service.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:multacc/database/database_interface.dart';
import 'package:multacc/items/item.dart';
import 'package:multacc/database/contact_model.dart';

part 'contacts_data.g.dart';

class ContactsData = _ContactsData with _$ContactsData;

abstract class _ContactsData with Store {
  DatabaseInterface _db;

  _ContactsData() {
    // get cached contacts first (synchronously)
    _db = GetIt.I.get<DatabaseInterface>();
    allContacts.addAll(_db.getCachedContacts());
  }

  @observable
  ObservableList<MultaccContact> allContacts = ObservableList<MultaccContact>();

  @action
  /// Fetches base contacts and updates the base information for MultaccContacts stored in db.
  /// Uses [localContacts] if supplied, instead of reading the base contacts from device
  Future<void> getAllContacts({Iterable<Contact> localContacts}) async {
    final _localContacts = localContacts ?? await ContactsService.getContacts();
    
    // update base information for cached contacts
    _localContacts.forEach((contact) {
      MultaccContact cachedContact = _db.getContact(contact.identifier);
      
      // if cached contact is not up-to-date
      if (cachedContact == null || !cachedContact.equalsBaseContact(contact)) {
        
        // create a new base contact with existing multacc items details
        MultaccContact newContact = MultaccContact.fromContact(contact);
        if (cachedContact != null) {
          newContact.multaccItems.addAll(
            cachedContact.multaccItems.where((i) => i.type != MultaccItemType.Phone && i.type != MultaccItemType.Email),
          );
        }

        // save to db (cache)
        _db.addContact(newContact);
      }
    });

    // refresh contacts list used in UI
    allContacts.clear();
    allContacts.addAll(_db.getCachedContacts());
  }


  @action
  /// Adds contact to device, gets the updated local list, and then updates the db
  Future<void> addContact(MultaccContact newContact) async {
    // save to device and get the updated list
    await ContactsService.addContact(newContact);
    final localContacts = await ContactsService.getContacts();

    // get id from the updated list by comparing with existing ids 
    final dbIds = allContacts.map((x) => x.identifier);
    final newContactId = localContacts.map((x) => x.identifier).firstWhere((x) => !dbIds.contains(x));

    // add to db with correct key
    newContact.clientKey = newContactId;
    _db.addContact(newContact);
    getAllContacts(localContacts: localContacts);
  }

  @action
  Future<void> updateContact(MultaccContact updatedContact) async {
    // update contact in db and device 
    _db.addContact(updatedContact);
    ContactsService.updateContact(updatedContact);
  }

  @action
  Future<void> updateProfile(MultaccContact profile) async {
    _db.addContact(profile);
  }

  @action
  Future<void> deleteContact(MultaccContact contact) async {
    allContacts.remove(contact);
    _db.deleteContact(contact);
    ContactsService.deleteContact(contact);
  }
}
