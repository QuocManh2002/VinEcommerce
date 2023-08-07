import 'package:flutter/material.dart';

class ColorTile extends StatelessWidget {
  const ColorTile({super.key, required this.icon, required this.color, required this.text, required this.subTitle , required this.status});
  final IconData icon;
  final Color color;
  final String text;
  final String subTitle;
  final bool status;
  @override
  Widget build(BuildContext context) {
    return 
    status?
    ListTile(
      leading: Container(
      height: 50,
      width: 50,
      child: Icon(icon, color: color),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(18),
      ),
    ),
    title: Container(
      child: Text(text),
    ),
    trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
    )
    :
    ListTile(
      leading: Container(
      height: 50,
      width: 50,
      child: Icon(icon, color: color),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(18),
      ),
    ),
    title: Container(
      child: Text(text),
    ),
    subtitle: Text(subTitle),
    );

  }
}


  