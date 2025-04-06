import 'package:chat_app/Authentication/auth_service.dart';
import 'package:chat_app/Materials/myButton.dart';
import 'package:chat_app/Materials/textField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    final email = TextEditingController();
    final password = TextEditingController();
    final confirmPassword = TextEditingController();
    final name = TextEditingController();

    void showErrorMessage(String str) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(str),
                content: Text("Try Again"),
              ));
    }

    void signUserUp() async {
      if (password.text != confirmPassword.text) {
        showErrorMessage("Password did not matched!!");
        return;
      }

      final authService = Provider.of<AuthService>(context, listen: false);

      try {
        await authService.signUpwithEmailandPassword(
            email.text, password.text, name.text);
      } on FirebaseException catch (e) {
        if (e.code == 'email-already-in-use') {
          showErrorMessage("Email already used!!");
        } else {
          showErrorMessage(
              "Something went Wrong!!Possibly email syntax incorrect or does not exist");
        }
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

                Text(
                  "DropCHAT",
                  style: TextStyle(
                    fontFamily: "Bytesized",
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
                //name
                const SizedBox(
                  height: 20,
                ),
                MyTextField(
                  controller: name,
                  hintText: "Enter Your Name",
                  obscure: false,
                ),
                //authentication
                const SizedBox(
                  height: 10,
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
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                  controller: confirmPassword,
                  hintText: "Confirm Password",
                  obscure: true,
                ),
                //login button
                MyButton(
                  name: "Sign Up",
                  onTap: signUserUp,
                ),

                const SizedBox(
                  height: 20,
                ),
                //register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already Have an Account? ",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Sign In",
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
