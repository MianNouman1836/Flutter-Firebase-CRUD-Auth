import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/Auth%20Screens/VerifyCodeScreen.dart';
import 'package:firebase_practice/Utils/ToastMessage.dart';
import 'package:firebase_practice/Widgets/Buttons/RoundButtons.dart';
import 'package:flutter/material.dart';

class LoginWithPhoneScreen extends StatefulWidget {
  const LoginWithPhoneScreen({super.key});

  @override
  State<LoginWithPhoneScreen> createState() => _LoginWithPhoneScreenState();
}

class _LoginWithPhoneScreenState extends State<LoginWithPhoneScreen> {
  bool loading = false;
  final phoneNumberController = TextEditingController();
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
              "Login With Phone Number",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        labelText: '+92 334 855 9392',
                        hintText: 'Enter your Code',
                        prefixIcon: const Icon(Icons.call),
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
                          return 'Invalid Phone Number!, Please Enter a Valid Phone Number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    RoundButton(
                        title: "Send Code",
                        loading: loading,
                        onTap: () {
                          setState(() {
                            loading = true;
                          });

                          _auth.verifyPhoneNumber(
                            phoneNumber: phoneNumberController.text,
                            verificationCompleted: (_) {
                              setState(() {
                                loading = false;
                              });
                            },
                            verificationFailed: (error) {
                              setState(() {
                                loading = false;
                              });
                              ToastMessage().toastMessage(error.toString());
                            },
                            codeSent: (String verificationID, int? token) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VerifyCodeScreen(verificationID: verificationID)));
                              setState(() {
                                loading = false;
                              });
                            },
                            codeAutoRetrievalTimeout: (error) {
                              ToastMessage().toastMessage(error.toString());
                              setState(() {
                                loading = false;
                              });
                            },
                          );
                        })
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
