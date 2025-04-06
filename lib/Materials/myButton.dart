import 'package:flutter/material.dart';


class MyButton extends StatelessWidget {
  final String name;
  void Function()? onTap;
  MyButton({super.key,required this.name,required this.onTap});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 10,left: 20,right: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 15,bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(name,style: TextStyle(color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
