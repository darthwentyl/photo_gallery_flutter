import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:mms/mms.dart';
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
  late ContactInformation _contactInformation;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
                onPressed: _openContactList,
                icon: const Icon(Icons.contacts_outlined)),
            IconButton(
                onPressed: _sendMessage, icon: const Icon(Icons.mms_outlined)),
          ],
        ),
        const Center(
          child: Text('Feature will be avaiable in future.'),
        ),
      ],
    );
  }

  void _openContactList() {
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
      _contactInformation = contactInformation;
    });
  }

  void _sendMessage() {
    print("${widget.photo.photo.path}|${_contactInformation.tel_num}");
    // TODO: It does not work. It seems mms plugin does not support photo
    //  sending. Probably it should be resolved sending url to data base like
    //  firebase. This issue will be resolved in future.
    // Mms().sendVideo(widget.photo.photo.path, [_contactInformation.tel_num]);
  }
}
