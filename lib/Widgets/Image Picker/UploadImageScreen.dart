import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_practice/Utils/ToastMessage.dart';
import 'package:firebase_practice/Widgets/Buttons/RoundButtons.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({Key? key}) : super(key: key);

  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  bool loading = false;
  File? _image;
  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Post');

  Future getGalleryImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        ToastMessage().toastMessage('No Image Picked');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            "Upload Image",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: () {
                  getGalleryImage();
                },
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    border: Border.all(color: Colors.black, width: 5),
                  ),
                  child: _image != null
                      ? Image.file(_image!.absolute)
                      : const Icon(Icons.add_photo_alternate_outlined,
                      color: Colors.white, size: 100),
                ),
              ),
            ),
            const SizedBox(height: 20),
            RoundButton(
              title: 'Upload Image',
              loading: loading,
              onTap: () async {
                setState(() {
                  loading = true;
                });

                String imagePath =
                    '/images/${DateTime.now().millisecondsSinceEpoch}.png';

                firebase_storage.Reference ref = storage.ref(imagePath);

                firebase_storage.UploadTask uploadTask = ref.putFile(_image!);

                await uploadTask.whenComplete(() async {

                  String newUrl = await ref.getDownloadURL();

                  await databaseRef.child('1').set({
                    'id': '123456',
                    'title': newUrl,
                  });
                  ToastMessage().toastMessage('Image Uploaded');
                  setState(() {
                    loading = false;
                  });
                }).catchError((error) {
                  ToastMessage().toastMessage(error.toString());
                  setState(() {
                    loading = false;
                  });
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
