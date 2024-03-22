import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/Start%20Up%20Screens/StartScreen.dart';
import 'package:flutter/material.dart';

import '../Screens/ShowPostScreen.dart';
import '../Utils/ToastMessage.dart';
import '../Widgets/Buttons/RoundButtons.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationID;
  const VerifyCodeScreen({super.key, required this.verificationID});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false;
  final codeVerificationController = TextEditingController();
  final _auth = FirebaseAuth.instance;

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
          title: const Center(
              child: Text(
                "Verify Phone Number",
                style: TextStyle(color: Colors.white),
              )),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 50,),

              TextFormField(
                keyboardType: TextInputType.number,
                controller: codeVerificationController,
                decoration: InputDecoration(
                  labelText: '6 Digit Code',
                  hintText: 'Enter your Code',
                  prefixIcon: const Icon(Icons.message),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Invalid Code!, Please Enter a Valid Code';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 80,),

              RoundButton(
                  title: "Verify",
                  loading: loading,
                  onTap: () async {
                    setState(() {
                      loading = true;
                    });
                    final credentials = PhoneAuthProvider.credential(
                        verificationId: widget.verificationID,
                        smsCode: codeVerificationController.text.toString());
                    try {
                      await _auth.signInWithCredential(credentials);
                      ToastMessage().toastMessage("Logged in Using Phone Number!");
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StartScreen()));
                    } catch (error) {
                      setState(() {
                        loading = false;
                      });
                      ToastMessage().toastMessage(error.toString());
                    }
                  })


            ],
          ),
        ),
      ),
    );
  }
}
