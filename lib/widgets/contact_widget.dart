import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:mms/mms.dart';
import 'package:photo_gallery/datas/contact_information.dart';
import 'package:photo_gallery/datas/photo_information.dart';
import 'package:photo_gallery/pages/contacts_list_page.dart';

class ContactWidget extends StatefulWidget {
  ContactWidget({Key? key, required this.photo}) : super(key: key);

  PhotoInformation photo;

  @override
  State<StatefulWidget> createState() => _ContactState();
}

class _ContactState extends State<ContactWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: _openContactList,
            icon: const Icon(Icons.contacts_outlined)),
      ],
    );
  }

  void _openContactList() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactsListPage(callback: _selectPhoneNumber),
        fullscreenDialog: true,
      ),
    );
  }

  void _selectPhoneNumber(ContactInformation contactInformation) {
    setState(() {
      print("${widget.photo.photo.path}|${contactInformation.tel_num}");
      Mms().sendVideo(
          File(widget.photo.photo.path).path, [contactInformation.tel_num]);
    });
  }
}
