import 'package:flutter/cupertino.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:photo_gallery/datas/contact_information.dart';

class ContactsListPage extends StatefulWidget {
  ContactsListPage({Key? key, required this.callback}) : super(key: key);

  Function(ContactInformation) callback;
  @override
  State<StatefulWidget> createState() => ContactsListState();
}

class ContactsListState extends State<ContactsListPage>
    with AfterLayoutMixin<ContactsListPage> {
  late List<Contact> _contacts;
  late Function(ContactInformation) _callback;
  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _callback = widget.callback;
      _isInit = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: add to strings.dart
      appBar: AppBar(title: const Text("Kontakty")),
      body: _body(),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _fetchContacts();
  }

  void _fetchContacts() async {
    final contacts = (await FlutterContacts.getContacts()).toList();

    setState(() {
      _contacts = contacts;
    });
  }

  Widget _body() {
    if (_contacts == null && !_isInit) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      itemCount: _contacts.length,
      itemBuilder: (context, index) {
        final contact = _contacts[index];
        return ListTile(
          title: Text(contact.displayName),
          onTap: () => _selectContact(index),
        );
      },
    );
  }

  _selectContact(int index) async {
    final contacts = _contacts;
    Contact? contact = await FlutterContacts.getContact(contacts[index].id);
    print("contact: ${contact?.phones.first.number}");
    if (contact != null) {
      _callback(ContactInformation(
          name: contact.displayName, tel_num: contact.phones.first.number));
    }
    Navigator.of(context).pop();
  }
}
