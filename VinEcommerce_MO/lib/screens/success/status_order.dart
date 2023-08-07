import 'package:flutter/material.dart';
import 'package:vin_ecommerce/screens/order_flow/shipper_homepage.dart';

import '../../styles/app_assets.dart';
import '../../styles/button_style.dart';
import '../../styles/customer_page_route.dart';
import '../order_flow/order_tracking_page.dart';

class StatusOrderPage extends StatelessWidget {
  const StatusOrderPage({super.key, required this.status});
  final int status;
  @override
  Widget build(BuildContext context) {
    switch (status) {
      case 1:
        return SafeArea(
            child: Scaffold(
          body: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppAssets.success_gif),
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
                      Navigator.pushReplacement(
                          context,
                          CustomerPageRoute(
                              child: OrderTrackingPage(),
                              direction: AxisDirection.left));
                    }),
              ],
            ),
          ),
        ));

        case 2:
        return SafeArea(
            child: Scaffold(
          body: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppAssets.delivery_gif),
                Text(
                  'Done! Order Picked Up.',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 32,
                ),
                Text(
                  'Go To Customer To Deliver The Order',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 32,
                ),
                ElevatedButton(
                    style: elevatedButtonStyle,
                    child: Text('CUSTOMER LOCATION'),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          CustomerPageRoute(
                              child: OrderTrackingPage(),
                              direction: AxisDirection.left));
                    }),
              ],
            ),
          ),
        ));

        case 3:
        return SafeArea(
            child: Scaffold(
          body: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppAssets.delivery_man),
                Text(
                  'Done! Order Delivered Successfully.',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 32,
                ),
                Text(
                  'Go To Next Order',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 32,
                ),
                ElevatedButton(
                    style: elevatedButtonStyle,
                    child: Text('BACK TO HOMEPAGE'),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          CustomerPageRoute(
                              child: ShipperHomePage(),
                              direction: AxisDirection.left));
                    }),
              ],
            ),
          ),
        ));
    }
    return Text('');
  }
}
