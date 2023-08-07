import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sizer2/sizer2.dart';
import 'package:vin_ecommerce/screens/landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
     MainApp(),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return const MaterialApp(
        title: 'VinEcom',
        debugShowCheckedModeBanner: false,
        home: LandingPage(),
        // home: SettingHomePage(),
        // home: OrderTrackingPage(),
        // home: ShipperHomePage(),
      );
    });
  }
}
