import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/registerPage.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool loginPage = true;
  void setPage() {
    setState(() {
      loginPage = !loginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (loginPage
        ? LoginPage(
            onTap: setPage,
          )
        : RegisterPage(
            onTap: setPage,
          ));
  }
}
