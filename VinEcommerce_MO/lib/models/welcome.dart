import 'package:vin_ecommerce/models/welcome_model.dart';

class Welcomes{
  static Welcomes _instance = Welcomes._internal();
  List<Welcome> list =  [];

  Welcomes._internal();
  factory Welcomes() => _instance;
  getAll(){
    list.add(new  Welcome("All your favorites","Get all your loved items, just place the order we do the rest"));
    list.add(new  Welcome("Anytime, anywhere","Order anything you want from your home with just one click"));
    list.add(new  Welcome("Order from choosen Store","All merchandises or foods are provided from the most quality stores "));
    list.add(new  Welcome("Free delivery offers","You don’t have to worry about the fees come up with orders"));
    return list;
  }
}