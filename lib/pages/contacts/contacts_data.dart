import 'package:contacts_service/contacts_service.dart';
import 'package:mobx/mobx.dart';
import 'package:multacc/pages/contacts/contact_model.dart';

part 'contacts_data.g.dart';

class ContactsData = _ContactsData with _$ContactsData;

abstract class _ContactsData with Store {
  @observable
  List<ContactModel> allContacts;

  @observable
  bool loaded = false;

  @observable
  List<ContactModel> displayedContacts;
  
  @computed
  List<ContactModel> get selectedContacts => displayedContacts.where((e) => e.isSelected);

  @action
  getAllContacts() async {
    loaded = false;
    allContacts = (await ContactsService.getContacts()).map((e) => ContactModel(e)).toList();
    displayedContacts = allContacts;
    loaded = true;
  }
  
}