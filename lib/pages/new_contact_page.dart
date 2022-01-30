import 'dart:io';

import 'package:contact_app_12/db/sqlite_helper.dart';
import 'package:contact_app_12/models/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewContactPage extends StatefulWidget {
  static const String routeName = '/new_contact';
  @override
  _NewContactPageState createState() => _NewContactPageState();
}

class _NewContactPageState extends State<NewContactPage> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _webController = TextEditingController();
  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _imageSource = ImageSource.camera;
  String? _imagePath;
  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _webController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Contact'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveContact,
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                hintText: 'Contact Name'
              ),
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return 'Please provide a valid name';
                }

                if(value.length > 20) {
                  return 'Name should not be greater than 20 chars';
                }

                return null;
              },
            ),
            const SizedBox(height: 15,),
            TextFormField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  hintText: 'Mobile Number'
              ),
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return 'Please provide a valid mobile number';
                }

                return null;
              },
            ),
            const SizedBox(height: 15,),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  hintText: 'Email Address'
              ),
              validator: (value) {
                return null;
              },
            ),
            const SizedBox(height: 15,),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.place),
                  hintText: 'Street Address'
              ),
              validator: (value) {
                return null;
              },
            ),
            const SizedBox(height: 15,),
            TextFormField(
              controller: _webController,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.web),
                  hintText: 'Website (optional)'
              ),
              validator: (value) {
                return null;
              },
            ),
            SizedBox(height: 20,),
            Center(
              child: Card(
                elevation: 10,
                color: Colors.grey,
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: _imagePath == null ? Image.asset('images/person.png', fit: BoxFit.cover,)
                      : Image.file(File(_imagePath!), fit: BoxFit.cover,)
                ),
              ),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  child: Text('Capture Image'),
                  onPressed: () {
                    _imageSource = ImageSource.camera;
                    _getImage();
                  },
                ),
                ElevatedButton(
                  child: Text('Select from Gallery'),
                  onPressed: () {
                    _imageSource = ImageSource.gallery;
                    _getImage();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _saveContact() async {
    if(_imagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose an image first'))
      );
      return;
    }
    if(_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final mobile = _mobileController.text;
      final email = _emailController.text;
      final web = _webController.text;
      final address = _addressController.text;
      final contact = ContactModel(
          name: name,
          mobile: mobile,
          email: email,
          website: web,
          image: _imagePath,
          streetAddress: address,
      );
      int rowId = await SqliteHelper.insertNewContact(contact);
      if(rowId > 0) {
        print(rowId);
        Navigator.pop(context);
      }
    }
  }

  void _getImage() {
    final Future<XFile?> imageFutureFile = ImagePicker().pickImage(source: _imageSource);
    imageFutureFile.then((imgFile) {
      if (imgFile != null) {
        setState(() {
          _imagePath = imgFile.path;
        });
      }
    });
  }
}
