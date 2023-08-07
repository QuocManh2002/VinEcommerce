import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vin_ecommerce/screens/order_flow/shipper_homepage.dart';

class RouteGenerator{
  Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;
    switch(settings.name){
      case'/':
        return MaterialPageRoute(builder: (_) => const ShipperHomePage());
      default: 
        return _errorRoute();  
    }
  }

  static Route<dynamic> _errorRoute(){
    return MaterialPageRoute(builder: (_) {
        return Scaffold(
          body: Center(child: Text("ERROR")),
        );
    });
  }
}

