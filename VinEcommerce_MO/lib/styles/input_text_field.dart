import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  const InputTextField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 28),
      child: SizedBox(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
              enabledBorder:
                  OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffA0A5BA))),
              fillColor: Color.fromARGB(255, 230, 230, 230),
              filled: true),
          textAlignVertical: TextAlignVertical.center,
          autofocus: false,
          style: TextStyle(fontSize: 20),
          
        ),
      ),
    );
  }
}
