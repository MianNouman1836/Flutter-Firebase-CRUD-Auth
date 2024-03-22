import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/Utils/ToastMessage.dart';
import 'package:firebase_practice/Widgets/Buttons/RoundButtons.dart';
import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {

  final emailController = TextEditingController();
  bool loading = false;

  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

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
          title: const Center(
            child: Text(
              "Forget Password",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                    const BorderSide(color: Colors.blue),
                  ),
                ),
              ),

              const SizedBox(height: 40,),

              RoundButton(
                loading: loading,
                  title: 'Reset',
                  onTap: (){

                  setState(() {
                    loading = true;
                  });

                    _auth.sendPasswordResetEmail(email: emailController.text.toString()

                    ).then((value) {
                      ToastMessage().toastMessage('Reset Request Send');
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
                  }
              )
            ],
          ),
        ),
      ),
    );
  }
}
