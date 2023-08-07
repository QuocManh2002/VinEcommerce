import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextFieldVerifi extends StatelessWidget {
  final double height;
  final double width;
  final TextAlign align;
  const MyTextFieldVerifi({super.key, required this.height, required this.width, required this.align});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
                          height: this.height,
                          width: this.width,
                          child: TextFormField(
                            onChanged: (value) {
                              if(value.length == 1){
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffA0A5BA))
                            ),
                            // border: OutlineInputBorder(),
                            // hintText: "Input Phone here",
                            fillColor: Color(0xffF0F5FA),
                            filled: true
                          ),
                          textAlign: this.align,
                          
                          inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly
                          ],
                          ),
                        );
  }
}