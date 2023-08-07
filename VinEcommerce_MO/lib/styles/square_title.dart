import 'package:flutter/material.dart';

class SquareTitle extends StatelessWidget {
  final String imgPath;

  const SquareTitle({super.key, required this.imgPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(imgPath, height: 62,),
    );
  }
}