import 'package:flutter/material.dart';



class MyTextField extends StatelessWidget {
  TextEditingController controller;
  final String hintText;
  bool obscure;
  MyTextField({super.key,required this.controller,required this.hintText,
  required this.obscure});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        obscureText: obscure,
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey,
          ),




        ),

      ),
    );
  }
}
