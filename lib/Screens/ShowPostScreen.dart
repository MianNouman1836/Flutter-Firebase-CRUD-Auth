import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_practice/Screens/AddPostScreen.dart';
import 'package:firebase_practice/Utils/ToastMessage.dart';
import 'package:flutter/material.dart';
import '../Auth Screens/LoginScreen.dart';
import '../Utils/LogoutConfirmationDialog.dart';

class ShowPostScreen extends StatefulWidget {
  const ShowPostScreen({super.key});

  @override
  State<ShowPostScreen> createState() => _ShowPostScreenState();
}

class _ShowPostScreenState extends State<ShowPostScreen> {

  final _auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  final searchFilterController = TextEditingController();
  final editTextController = TextEditingController();


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
          title: Center(
              child: Row(
            children: [
              const Text(
                "Post Screen",
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(
                width: 190,
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
                  ))
            ],
          )),
        ),

        body: Column(

          children: [

            const SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                keyboardType: TextInputType.text,
                 controller: searchFilterController,
                decoration: InputDecoration(
                  labelText: 'Search',
                 // hintText: 'Enter your Email',
                  prefixIcon: const Icon(Icons.filter_alt_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                    const BorderSide(color: Colors.blue),
                  ),
                ),
                onChanged: (String value){
                  setState(() {

                  });
                },
              ),
            ),

            const SizedBox(height: 10,),

            Container(
              color: Colors.blueAccent,
              height: 40,
              width: 400,
              child: const Center(
                child: Text('Using Firebase Animated List', style: TextStyle(
                    fontSize: 20,
                    color: Colors.white
                ),),
              ),
            ),

            Expanded(
              child: FirebaseAnimatedList(
                  query: ref,
                  defaultChild: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                  itemBuilder: (context, snapshot, animation, index) {
                    final title = snapshot.child('title').value.toString();

                    if (searchFilterController.text.isEmpty) {
                      return ListTile(
                        title: Text(snapshot.child('title').value.toString()),
                        subtitle: Text(snapshot.child('id').value.toString()),
                        trailing: PopupMenuButton(
                        icon: const Icon(Icons.more_vert_outlined),
                        itemBuilder: (context) => [
                           PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  showEditTextDialog(title, snapshot.child('id').value.toString());
                                },
                                leading: const Icon(Icons.edit, color: Colors.deepPurple,),
                                title: const Text('Edit', style: TextStyle(color: Colors.deepPurple),),
                              )),
                            PopupMenuItem(
                              value: 2,
                              child: ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  ref.child(snapshot.child('id').value.toString()).remove();
                                },
                                leading: const Icon(Icons.delete, color: Colors.red,),
                                title: const Text('Delete', style: TextStyle(color: Colors.red),),
                              )),
                        ]),
                      );
                    } else if (title.toLowerCase().contains(searchFilterController.text.toLowerCase().toString())) {
                      return ListTile(
                        title: Text(snapshot.child('title').value.toString()),
                        subtitle: Text(snapshot.child('id').value.toString()),
                      );
                    } else {
                      return Container();
                    }

                  }),
            ),

          ],
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddPostScreen()));
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
              child:  TextField(
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
                  ref.child(id).update({
                    'title': editTextController.text.toString()
                  }).then((value) {
                    ToastMessage().toastMessage('Updated Successfully!');
                  }).onError((error, stackTrace) {
                    ToastMessage().toastMessage(error.toString());
                  });
                },
              ),
            ],
          );
        });
  }

}

//Container(
//             color: Colors.blueAccent,
//             height: 40,
//             width: 400,
//             child: const Center(
//               child: Text('Using Stream Builder', style: TextStyle(
//                   fontSize: 20,
//                   color: Colors.white
//               ),),
//             ),
//           ),
//
//           Expanded(
//               child: StreamBuilder(
//             stream: ref.onValue,
//             builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const CircularProgressIndicator();
//               } else if (!snapshot.hasData) {
//                 return const Text('No data available.');
//               } else {
//                 Map<dynamic, dynamic> map =
//                     snapshot.data!.snapshot.value as dynamic;
//                 List<dynamic> list = [];
//                 list.clear();
//                 list = map.values.toList();
//                 return ListView.builder(
//                     itemCount: snapshot.data!.snapshot.children.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(list[index]['title']),
//                         subtitle: Text(list[index]['id']),
//                       );
//                     });
//               }
//             },
//           )),