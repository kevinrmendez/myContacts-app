import 'package:mycontacts_free/contact.dart';
import 'package:mycontacts_free/contactDb.dart';
import 'package:rxdart/rxdart.dart';
import '../main.dart';

class AppState {
  BehaviorSubject _contactList =
      BehaviorSubject.seeded([contactsfromDb] == null ? [] : contactsfromDb);

  BehaviorSubject _screenIndex = BehaviorSubject.seeded(0);

  BehaviorSubject _contactsDuplicate = BehaviorSubject.seeded(0);

  Stream get streamIndex => _screenIndex.stream;
  Stream get stream => _contactList.stream;

  Stream get streamContactsDuplicate => _contactsDuplicate.stream;

  List<Contact> get current => _contactList.value;
  int get currentIndex => _screenIndex.value;
  int get currentContactsDuplicates => _contactsDuplicate.value;

  changeIndex(int index) {
    _screenIndex.add(index);
  }

  add(Contact contact) {
    _contactList.value.add(contact);
    _contactList.add(List<Contact>.from(current));
  }

  updateContacts(List contacts) {
    _contactList.add(List<Contact>.from(contacts));
  }

  update(Contact contact) {
    int index = _contactList.value.indexOf(contact);
    _contactList.value.removeAt(index);
    _contactList.value.insert(index, contact);
    _contactList.add(List<Contact>.from(current));
  }

  remove(Contact contact) {
    _contactList.value.remove(contact);
    _contactList.add(List<Contact>.from(current));
  }

  removeAll() {
    _contactList.value = <Contact>[];
    _contactList.add(List<Contact>.from(current));
  }

  updateContactsDuplicate(int duplicateContactsQuantity) {
    _contactsDuplicate.add(duplicateContactsQuantity);
  }
}

AppState contactService = AppState();
