import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_practice/Utils/ToastMessage.dart';
import 'package:firebase_practice/Widgets/Buttons/RoundButtons.dart';
import 'package:flutter/material.dart';

import 'ShowPostScreen.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {

  bool loading = false;
  final postController = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref('Post');

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
          title:  const Center(child: Text("Add Post", style: TextStyle(color: Colors.white),))
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
                  hintText: 'What is in Your Mind?',
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

              RoundButton(title: "Post an Update",
                  loading: loading,
                  onTap: () {
                setState(() {
                  loading = true;
                });

                String id = DateTime.now().millisecondsSinceEpoch.toString();

                databaseRef.child(id).set({
                  'title' : postController.text.toString(),
                  'id' : id,
                }).then((value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ShowPostScreen()));
                  ToastMessage().toastMessage("Post Added!");
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
