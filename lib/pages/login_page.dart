import 'package:chat_app/Authentication/auth_service.dart';
import 'package:chat_app/Materials/myButton.dart';
import 'package:chat_app/Materials/textField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final email = TextEditingController();
    final password = TextEditingController();

    // void showCircularProgress() {
    //   showDialog(
    //       context: context,
    //       builder: (context) {
    //         return Center(
    //           child: CircularProgressIndicator(
    //             color: Colors.black,
    //           ),
    //         );
    //       });
    // }

    void invalidEmail() {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
              title: Text("Invalid Email"), content: Text("Try Again")));
    }

    void invalidPassword() {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
              title: Text("Invalid Password"), content: Text("Try Again")));
    }

    void signUserIn() async {
      //get the auth service instance
      final authService = Provider.of<AuthService>(context, listen: false);

      try {
        await authService.signInWithEmailandPassword(email.text, password.text);
      } on FirebaseAuthException catch (e) {
        // print("FirebaseAuthException Code: ${e.code}"); // Debugging

        setState(() {
          if (e.code == 'user-not-found') {
            invalidEmail();
          } else if (e.code == 'wrong-password') {
            invalidPassword();
          } else if (e.code == 'invalid-credential') {
            // Handle this case
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Invalid Credentials"),
                content: Text(
                    "The email or password is incorrect. Please try again."),
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Authentication Error"),
                content: Text(e.message ?? "Something went wrong"),
              ),
            );
          }
        });
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //icon
                Image.asset("image/mslogo.png"),
                //welcome
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Welcome Back Dear",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                //authentication
                const SizedBox(
                  height: 20,
                ),
                MyTextField(
                  controller: email,
                  hintText: "Email",
                  obscure: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                  controller: password,
                  hintText: "Password",
                  obscure: true,
                ),
                //forget password
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 25),
                      child: Text(
                        "Forget Password?",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
                //login button
                MyButton(
                  name: "Sign In",
                  onTap: signUserIn,
                ),

                const SizedBox(
                  height: 20,
                ),
                //register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not Registered Yet? ",
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Register Now",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                        ),
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
