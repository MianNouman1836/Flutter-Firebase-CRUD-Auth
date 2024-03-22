import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Auth Screens/LoginScreen.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

   LogoutConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Logout Confirmation'),
      content: const Text('Are you sure you want to logout?'),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
        TextButton(
          child: const Text('Logout'),
          onPressed: () {
            _auth.signOut().then((value) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            });
          },
        ),
      ],
    );
  }
}
