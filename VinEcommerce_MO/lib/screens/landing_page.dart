import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vin_ecommerce/screens/order_flow/shipper_homepage.dart';
import 'package:vin_ecommerce/styles/color.dart';
import 'package:vin_ecommerce/styles/customer_page_route.dart';

import 'float_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<StatefulWidget> createState() => _LandingPage();
}

class _LandingPage extends State<LandingPage> {
  String token = "";

  @override
  void initState() {
    // TODO: implement initState
  getData();
    super.initState();
  }

  getData() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    String token = _prefs.getString('token').toString();
    Timer(Duration(seconds: 3), () {
      if (token.toString().trim() == "null") {
        Navigator.pushReplacement(context,
            CustomerPageRoute(child: FloatPage(), direction: AxisDirection.up));
      } else {
        Navigator.pushReplacement(
            context,
            CustomerPageRoute(
                child: ShipperHomePage(), direction: AxisDirection.up));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: Image.asset(
              'assets/images/corner_left.png',
              color: Color(0xffD9D9D9),
            ),
          ),
          Spacer(),
          Container(
              child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 42),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(right: 36),
                  child: Text(
                    'Vin',
                    style: TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 62),
                child: Text(
                  'Ecom',
                  style: TextStyle(fontSize: 42),
                ),
              )
            ],
          )),
          Spacer(),
          Container(
            alignment: Alignment.bottomRight,
            child: Image.asset('assets/images/corner_right.png'),
          )
        ],
      ),
    ));
  }
}
