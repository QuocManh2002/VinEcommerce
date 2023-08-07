import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vin_ecommerce/models/order_detail_model.dart';
import 'package:vin_ecommerce/models/order_model.dart';
import 'package:http/http.dart' as http;
import '../styles/app_assets.dart';

class OrderRepository {
  List<Order> orderList = [];
  List<Order> deliveredList = [];
  List<OrderDetail> _orderDetailList = [];
  Order? _order = null;

  getPendingOrders() async {
    var url = AppAssets.getPendingOrder;
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var pendingOrders = json.decode(response.body);
      List<dynamic> _pendingOrders = pendingOrders;
      return _pendingOrders.map((e) => Order.fromJson(e)).toList();
    }
  }

  getDeliveredOrders() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    var url = AppAssets.shipperDeliveryList;
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      List<dynamic> orders = json.decode(response.body);
      deliveredList = orders.map((e) => Order.fromJson(e)).toList();
      return deliveredList;
    }
  }

  getOrderById(String id) async {
    var url = AppAssets.getOrders + "/" + id;
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      dynamic order = json.decode(response.body);
      _order = Order.fromJson(order);
      return _order;
    }
  }

  static List<Order> convert(List<dynamic> _orderList) {
    return _orderList.map((e) => Order.fromJson(e)).toList();
  }

  getOrderDetails(String id) async {
    var url = AppAssets.getOrders + "/" + id;
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      dynamic order = json.decode(response.body);
      List<dynamic> orderDetails = order['details'];
      // dynamic productName = jsonDecode(orderDetails.toString());
      print(orderDetails[0]['product']['name'].toString());
      _orderDetailList =
          orderDetails.map((e) => OrderDetail.fromJson(e)).toList();
      return _orderDetailList;
    }
  }

  getTotal() async {
    var total = 0;

    for (var item in _orderDetailList) {
      int price = item.price != null ? item.price! : 0;
      int quantity = item.quantity != null ? item.quantity! : 0;
      total += (price * quantity);
      
    }
    return total+= 5000;
  }

  Future<bool> receiveOrder(String orderId) async {
    var url = AppAssets.receiveOrder + orderId.toString();
    final SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await http.put(Uri.parse(url), headers: headers);
    if(response.statusCode == 200){
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('onGoingOrder', orderId);
      print('ReceiveOrder Successfully');
      return true;
      
    }else{
      print('ReceiveOrder fail');
      return false;
    }
  }

  finishOrder() async{
    var url = AppAssets.finishOrder ;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await http.patch(Uri.parse(url), headers:  headers);
    if(response.statusCode == 200){
      print('finish order successfully');
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('onGoingOrder', "");
      return true;
    }else{
      print('finish order fail');
      return false;
    }
  }

  List<Order> getOrderList() => this.orderList;
}
