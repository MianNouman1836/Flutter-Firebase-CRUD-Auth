import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_practice/Utils/ToastMessage.dart';
import '../Utils/LogoutConfirmationDialog.dart';
import 'AddFirestoreDataScreen.dart';

class FirestoreListScreen extends StatefulWidget {
  const FirestoreListScreen({Key? key}) : super(key: key);

  @override
  State<FirestoreListScreen> createState() => _FirestoreListScreenState();
}

class _FirestoreListScreenState extends State<FirestoreListScreen> {
  final _auth = FirebaseAuth.instance;
  final editTextController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('Users').snapshots();

  CollectionReference ref = FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          automaticallyImplyLeading: false,
          title: Center(
            child: Row(
              children: [
                const Text(
                  "Firestore Data",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  width: 170,
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return LogoutConfirmationDialog();
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            Container(
              color: Colors.blueAccent,
              height: 40,
              width: 400,
              child: const Center(
                child: Text(
                  'Using Firestore Database',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: fireStore,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 4,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Loading'),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Some Error Occurred!');
                  }

                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(snapshot.data!.docs[index]['title'].toString()),
                          subtitle: Text(snapshot.data!.docs[index]['id'].toString()),
                          trailing: PopupMenuButton(
                            icon: const Icon(Icons.more_vert_outlined),
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: ListTile(
                                  leading: Icon(Icons.edit, color: Colors.deepPurple),
                                  title: Text('Edit', style: TextStyle(color: Colors.deepPurple)),
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: ListTile(
                                  leading: Icon(Icons.delete, color: Colors.red),
                                  title: Text('Delete', style: TextStyle(color: Colors.red)),
                                ),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 'edit') {
                                showEditTextDialog(
                                  snapshot.data!.docs[index]['title'].toString(),
                                  snapshot.data!.docs[index]['id'].toString(),
                                );
                              } else if (value == 'delete') {
                                _deleteDocument(snapshot.data!.docs[index]['id'].toString());
                              }
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddFirestoreDataScreen()),
            );
          },
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add_comment_outlined),
        ),
      ),
    );
  }

  Future<void> showEditTextDialog(String title, String id) async {
    editTextController.text = title;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Your Text'),
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: TextField(
              controller: editTextController,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () {
                Navigator.of(context).pop();
                _updateDocument(id, editTextController.text);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteDocument(String documentId) async {
    await ref.doc(documentId).delete();
  }

  Future<void> _updateDocument(String documentId, String updatedTitle) async {
    await ref.doc(documentId).update({'title': updatedTitle});
  }
}
