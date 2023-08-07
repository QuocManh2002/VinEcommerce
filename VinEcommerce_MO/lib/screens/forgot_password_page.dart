import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer2/sizer2.dart';
import 'package:vin_ecommerce/screens/verification_page.dart';
import 'package:vin_ecommerce/styles/color.dart';

import '../styles/button_style.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var phone = "";
    const countryCode = "+84";
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: midnightBlueColor,
      body: SafeArea(
        child: Container(
          child: Column(children: [
            Container(
              height: 30.h,
              width: size.width,
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(right: 250),
                      child: Image.asset('assets/images/corner_left.png',
                          height: 120, color: secondaryTextColor)),
                  Text(
                    'Forgot Password',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Please sign in to your existing account',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
            Container(
              height: 66.h,
              width: size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24))),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'PHONE',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                      width: double.infinity,
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        onChanged: (value){
                          phone = value;
                        },
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffA0A5BA))),
                            // border: OutlineInputBorder(),
                            // hintText: "Input Phone here",
                            fillColor: Color(0xffF0F5FA),
                            filled: true),
                        textAlignVertical: TextAlignVertical.center,
                        autofocus: false,
                        style: TextStyle(fontSize: 20),
                      ),
                      height: 64,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: size.width,
                    height: 64,
                    child: ElevatedButton(
                      style: elevatedButtonStyle.copyWith(),
                      child: Text('SEND CODE'),
                      onPressed: () async {
                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: '${countryCode + phone}',
                          verificationCompleted:
                              (PhoneAuthCredential credential) {},
                          verificationFailed: (FirebaseAuthException e) {},
                          codeSent:
                              (String verificationId, int? resendToken) {},
                          codeAutoRetrievalTimeout: (String verificationId) {},
                        );

                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => VerificationPage()),
                            (route) => false);
                      },
                    ),
                  ),
                ]),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
