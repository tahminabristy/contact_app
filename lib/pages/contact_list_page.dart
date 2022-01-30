 import 'package:contact_app_12/custom_widgets/contact_row_item_big_image.dart';
import 'package:contact_app_12/db/sqlite_helper.dart';
import 'package:contact_app_12/models/contact_model.dart';
import 'package:contact_app_12/pages/new_contact_page.dart';
import 'package:contact_app_12/providers/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactListPage extends StatefulWidget {
  static final String routeName = '/';
  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  late ContactProvider _provider;
  @override
  void didChangeDependencies() {
    _provider = Provider.of<ContactProvider>(context, listen: false);
    _getData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact List'),
        actions: [
          TextButton(
            child: const Text('Show only favorites', style: TextStyle(color: Colors.white),),
            onPressed: () async {
              _provider.getFavContacts();
            },
          )
        ],
      ),
      body: Consumer<ContactProvider>(
        builder: (context, provider, _) => ListView.builder(
          itemCount: provider.contactList.length,
          itemBuilder: (context, index) => ContactRowItemBigImage(provider.contactList[index], _updateContactFav, _deleteContact),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, NewContactPage.routeName).then((_) {
            setState(() {
              _getData();
            });
          });
        },
      ),
    );
  }

  void _getData() async {
    _provider.getContacts();
  }

  void _updateContactFav(ContactModel contactModel, bool fav) {
    _provider.updateContactFav(contactModel, fav);
  }

  void _deleteContact(ContactModel contactModel) {
    /*contactList.remove(contactModel);
    setState(() {

    });*/
  }
}
