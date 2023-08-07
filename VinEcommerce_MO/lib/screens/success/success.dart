import 'package:flutter/material.dart';
import 'package:vin_ecommerce/styles/app_assets.dart';
import 'package:vin_ecommerce/styles/customer_page_route.dart';

import '../../styles/button_style.dart';
import '../order_flow/order_tracking_page.dart';

class SuccessPage extends StatefulWidget {

  const SuccessPage({super.key});
  
  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body:
         Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppAssets.success_gif),
              SizedBox(height: 32,),
              Text(
                'Done! Order Accepted.',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 32,
              ),
              Text(
                'Come To Restaurant To Pick Up Order',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 32,
              ),
              ElevatedButton(
                  style: elevatedButtonStyle,
                  child: Text('RETAURANT LOCATION'),
                  onPressed: () {
                    Navigator.pushReplacement(context, CustomerPageRoute(child: OrderTrackingPage(), direction: AxisDirection.left));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
