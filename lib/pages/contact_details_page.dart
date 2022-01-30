import 'dart:io';

import 'package:contact_app_12/db/sqlite_helper.dart';
import 'package:contact_app_12/models/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDetailsPage extends StatefulWidget {
  static final String routeName = '/details';

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {

  late ContactModel contactModel;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    final contactId = ModalRoute.of(context)!.settings.arguments as int;
    SqliteHelper.getContactById(contactId)
    .then((value) {
      setState(() {
        contactModel = value;
        isLoading = false;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Details'),
      ),
      body: Center(
        child: isLoading ? const CircularProgressIndicator() : ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Image.file(File(contactModel.image!),width: double.maxFinite, height: 200, fit: BoxFit.cover,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(contactModel.name, style: const TextStyle(fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Text(contactModel.mobile),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.call),
                    onPressed: () {
                      _callNumber();
                    },
                  ),

                  IconButton(
                    icon: Icon(Icons.sms),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(contactModel.email ?? 'Not provided'),
              trailing: IconButton(
                icon: Icon(Icons.email),
                onPressed: contactModel.email == null ? null : () {},
              ),
            ),
            ListTile(
              title: Text(contactModel.website ?? 'Not provided'),
              trailing: IconButton(
                icon: Icon(Icons.web),
                onPressed: contactModel.website == null ? null : () {},
              ),
            ),
            ListTile(
              title: Text(contactModel.streetAddress ?? 'Not provided'),
              trailing: IconButton(
                icon: Icon(Icons.map),
                onPressed: contactModel.streetAddress == null ? null : () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _callNumber() async{
    final url = 'tel:${contactModel.mobile}';
    if(await canLaunch(url)) {
      await launch(url);
    }else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No apps found to perform this action')));
    }
  }
}
