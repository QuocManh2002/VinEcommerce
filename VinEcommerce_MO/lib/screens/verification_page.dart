import 'package:flutter/material.dart';
import 'package:sizer2/sizer2.dart';
import 'package:vin_ecommerce/screens/order_flow/shipper_homepage.dart';
import 'package:vin_ecommerce/styles/button_style.dart';
import 'package:vin_ecommerce/styles/color.dart';
import 'package:vin_ecommerce/styles/my_text_field.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return
     SafeArea(
       child: Scaffold(
        resizeToAvoidBottomInset: false, 
        backgroundColor: midnightBlueColor,
        body: Container(
          
            child: Column(
          children: [
            
                    
                
            Container(
              height: 33.h,
              width: size.width,
              child: Column(
                children: [
                  Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(right: 250),
                child: Image.asset('assets/images/corner_left.png',
                    height: 120, color: secondaryTextColor)),
                  Text(
                    'Verification',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'We have sent an OTP to your phone',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    '0123456789',
                    style: TextStyle(
                        color: lightGrayColor, fontWeight: FontWeight.bold),
                  ),
                  
                ],
              ),
            ),
            Container(
              height: 63.h,
              width: size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24))),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        'CODE',
                        style: TextStyle(),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MyTextFieldVerifi(
                        height: 64, width: 64, align: TextAlign.center),
                    MyTextFieldVerifi(
                        height: 64, width: 64, align: TextAlign.center),
                    MyTextFieldVerifi(
                        height: 64, width: 64, align: TextAlign.center),
                    MyTextFieldVerifi(
                        height: 64, width: 64, align: TextAlign.center),
                  ],
                ),
                SizedBox(
                  height: 42,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t receive any OTP?',
                      style: TextStyle(color: secondaryTextColor),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        'RESEND',
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 42,
                ),
                Container(
                  height: 64,
                  width: size.width * 5 / 6,
                  child: ElevatedButton(
                    style: elevatedButtonStyle,
                    child: Text('SEND CODE', style: TextStyle(fontWeight: FontWeight.bold),),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                                    builder: (_) => ShipperHomePage()));
                    },
                  ),
                ),
              ]),
            ),
          ],
        )),
         ),
     );
  }
}
