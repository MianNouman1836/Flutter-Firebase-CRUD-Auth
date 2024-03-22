import 'package:firebase_practice/Auth%20Screens/LoginScreen.dart';
import 'package:firebase_practice/Start%20Up%20Screens/StartScreen.dart';
import 'package:firebase_practice/Utils/ToastMessage.dart';
import 'package:firebase_practice/Widgets/Buttons/RoundButtons.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Screens/ShowPostScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void createAccount() {
    setState(() {
      loading = true;
    });
    if (_formKey.currentState!.validate()) {
      _auth
          .createUserWithEmailAndPassword(
          email: emailController.text.toString(),
          password: passwordController.text.toString())
          .then((value) {
        ToastMessage().toastMessage("SignUp Successful!");
        setState(() {
          loading = false;
        });
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const StartScreen()));
      }).onError((error, stackTrace) {
        ToastMessage().toastMessage(error.toString());
        setState(() {
          loading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            "SignUp",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          // Close the keyboard when tapping any part of the screen
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 70,
                ),
                Image.asset(
                  'Assets/Images/Signup.png',
                  width: 100,
                  height: 100,
                ),
                const Text(
                  "Create Your Account",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.w900),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                    key: _formKey,
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
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Invalid Email!, Please Enter a Valid Email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: passwordController,
                          obscureText: !isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter your Password',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                              icon: Icon(
                                isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
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
                              return 'Invalid Password!, Please Enter a Valid Password';
                            }
                            return null;
                          },
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 30,
                ),
                RoundButton(
                  title: "Create Account",
                  loading: loading,
                  onTap: () {
                    createAccount();
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    const Text(
                      "Already Having Account?",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.deepPurple),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
