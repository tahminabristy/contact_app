import 'package:contact_app_12/models/contact_model.dart';
import 'package:contact_app_12/pages/contact_details_page.dart';
import 'package:flutter/material.dart';

class ContactRowItem extends StatefulWidget {
  final ContactModel contact;
  final int index;
  ContactRowItem(this.contact, this.index);

  @override
  _ContactRowItemState createState() => _ContactRowItemState();
}

class _ContactRowItemState extends State<ContactRowItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        elevation: 5,
        child: ListTile(
          onTap: () {
            Navigator.pushNamed(
                context,
                ContactDetailsPage.routeName,
                arguments: widget.contact
            );
          },
          tileColor: widget.index.isEven ? Colors.greenAccent : Colors.blueAccent,
          //leading: CircleAvatar(),
          trailing: IconButton(icon: Icon(Icons.favorite_border),onPressed: () {},),
          title: Text(widget.contact.name),
          subtitle: Text(widget.contact.mobile),
        ),
      ),
    );
  }
}
