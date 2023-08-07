import 'package:flutter/material.dart';

import 'color.dart';

class OrderStatus extends StatelessWidget {
  const OrderStatus({super.key, required this.statusId});
  final String statusId ;
  @override
  Widget build(BuildContext context) {
    
    switch(statusId){
      case "Đang chuẩn bị": return Container(
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
          color: Color.fromARGB(50, 255, 152, 34),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(14))),
      child: Text(
        'Đang chuẩn bị',
        style: TextStyle(color: primaryColor),
      ),
    );
      case 'Đang giao':  return Container(
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
          color: pickedUpBackgroundColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(14))),
      child: Text(
        'Đang giao',
        style: TextStyle(color: pickedUpForegroundColor),
      ),
    );
      case 'Hoàn thành': return Container(
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
          color: Color.fromARGB(48, 60, 255, 34),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(14))),
      child: Text(
        'Hoàn thành',
        style: TextStyle(color: greenColor),
      ),
    );
      case 'Đã hủy': return Container(
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
          color: Color.fromARGB(49, 255, 67, 34),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(14))),
      child: Text(
        'Đã hủy',
        style: TextStyle(color: redColor),
      ),
    );
    }
    return Text('data');
  }
}
