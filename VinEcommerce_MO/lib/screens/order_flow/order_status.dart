import 'package:flutter/material.dart';
import 'package:vin_ecommerce/styles/color.dart';

class OrderStatusPage extends StatelessWidget {
  const OrderStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  
         
       SafeArea(
         child: Scaffold(
          backgroundColor: redColor,
           body: SizedBox(
                
            height: 500,
            child: Container(
              height: 500,
              child: Expanded(child: Text('test'))),
               ),
         ),
       );
   
  }
}