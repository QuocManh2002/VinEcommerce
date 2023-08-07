import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vin_ecommerce/styles/app_assets.dart';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';
class UserRepository{
  updateInfo(String name, String phone, String imgUrl, String plate) async{
    var url = AppAssets.shipperInfo;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    var body = { "name":name, "avatarUrl":imgUrl, "licensePlate":plate, "phone": phone };
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await http.put(Uri.parse(url), headers: headers, body: json.encode(body));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  getInfo() async{
    var url = AppAssets.shipperInfo;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await http.get(Uri.parse(url), headers: headers);
    if(response.statusCode == 200){
      dynamic user =  json.decode(response.body);
      User _user = User.fromJson(user);
      return _user;
    }
  }

  updatePassword(String currentPassword,String newPassword) async{
    var url = AppAssets.updatePassword;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var body = { "currentPassword":currentPassword, "newPassword":newPassword };
    var response = await http.patch(Uri.parse(url), headers: headers, body: json.encode(body));
    if(response.statusCode == 200){
      return true;
    }
    return false;
  }
}