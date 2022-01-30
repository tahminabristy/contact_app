import 'dart:io';

import 'package:contact_app_12/db/sqlite_helper.dart';
import 'package:contact_app_12/models/contact_model.dart';
import 'package:contact_app_12/pages/contact_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactRowItemBigImage extends StatefulWidget {
  final ContactModel contact;
  final Function(ContactModel, bool) updateCallback;
  final Function(ContactModel) deleteCallback;
  ContactRowItemBigImage(this.contact, this.updateCallback, this.deleteCallback);
  @override
  _ContactRowItemBigImageState createState() => _ContactRowItemBigImageState();
}

class _ContactRowItemBigImageState extends State<ContactRowItemBigImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 32.0),
      width: double.maxFinite,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(24.0),

      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(80),
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            child: Image.file(
              File(widget.contact.image!),
              width: double.maxFinite,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 0,
              top: 0,
              child: IconButton(
                icon: Icon(widget.contact.favorite ? Icons.favorite : Icons.favorite_border),
                iconSize: 50,
                color: Colors.white70,
                onPressed: () async {
                  final value = widget.contact.favorite ? 0 : 1;
                  await SqliteHelper.updateContactFavorite(widget.contact.id, value);
                    widget.updateCallback(widget.contact, !widget.contact.favorite);
                  },)
          ),
          Positioned(
              right: 0,
              bottom: 0,
              child: IconButton(
                icon: const Icon(Icons.delete_forever, color: Colors.grey,),
                iconSize: 50,
                color: Colors.white70,
                onPressed: () async {
                  _showConfirmationDialog();
                },)
          ),
          Positioned(
            left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Center(child: Container(
                padding: const EdgeInsets.all(4.0),
                  color: Colors.black54,
                  child: Text(widget.contact.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),)))
          ),
          Positioned(
            left: 40,
            right: 40,
            bottom: -25,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 20
              ),
              child: Text('Details'),
              onPressed: () {
                Navigator.pushNamed(
                    context,
                    ContactDetailsPage.routeName,
                    arguments: widget.contact.id
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text('Delete ${widget.contact.name}?'),
      content: const Text('Are you sure to delete this contact?'),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        ElevatedButton(
          child: const Text('Delete'),
          onPressed: () {
            SqliteHelper.deleteContact(widget.contact.id).then((_) {
              Navigator.pop(context);
              widget.deleteCallback(widget.contact);
            });
          },
        ),
      ],
    ));
  }
}
