import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_practice/Firestore%20Database/FirestoreListScreen.dart';
import 'package:firebase_practice/Utils/ToastMessage.dart';
import 'package:firebase_practice/Widgets/Buttons/RoundButtons.dart';
import 'package:flutter/material.dart';

import '../Screens/ShowPostScreen.dart';

class AddFirestoreDataScreen extends StatefulWidget {
  const AddFirestoreDataScreen({super.key});

  @override
  State<AddFirestoreDataScreen> createState() => _AddFirestoreDataScreenState();
}

class _AddFirestoreDataScreenState extends State<AddFirestoreDataScreen> {

  bool loading = false;
  final postController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            automaticallyImplyLeading: false,
            title:  const Center(child: Text("Add Firestore Data", style: TextStyle(color: Colors.white),))
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [

              const SizedBox(height: 30,),

              TextFormField(
                maxLines: 4,
                keyboardType: TextInputType.text,
                controller: postController,
                decoration: InputDecoration(
                  // labelText: 'Text',
                  hintText: 'Add Some Data into Firestore!',
                  // prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
              ),

              const SizedBox(height: 30,),

              RoundButton(title: "Add into Firestore",
                  loading: loading,
                  onTap: () {
                    setState(() {
                      loading = true;
                    });

                    String id = DateTime.now().millisecondsSinceEpoch.toString();

                    fireStore.doc(id).set({
                      'title': postController.text.toString(),
                      'id': id,
                    }).then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FirestoreListScreen()));
                      ToastMessage().toastMessage("Post Added to Firestore Database!");
                      FocusScope.of(context).unfocus();
                      setState(() {
                        loading = false;
                      });
                    }).onError((error, stackTrace) {
                      ToastMessage().toastMessage(error.toString());
                      setState(() {
                        loading = false;
                      });
                    });
                  })
            ],
          ),
        ),

      ),
    );
  }

}
