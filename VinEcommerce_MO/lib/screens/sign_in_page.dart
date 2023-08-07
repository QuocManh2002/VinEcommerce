import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer2/sizer2.dart';
import 'package:vin_ecommerce/styles/button_style.dart';
import 'package:vin_ecommerce/styles/color.dart';
import 'package:http/http.dart' as http;

import '../styles/app_assets.dart';
import 'order_flow/shipper_homepage.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passenable = true;
  bool isRemember = false;
  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
  }

  // final storage = new FlutterSecureStorage();
  login(String phone, String password) async {
    try {
      var body = {"phone": phone, "password": password};
      var headers = {'Content-Type': 'application/json'};
      http.Response response = await http.post(
          Uri.parse(AppAssets.shipperAuthorize),
          headers: headers,
          body: json.encode(body));
      if (response.statusCode == 200) {
        var data = json.decode(response.body.toString());
        print(data['accessToken']);
        final SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.setString('token', data['accessToken'].toString());
        _prefs.setString('nameLogin', data['name'].toString());
        _prefs.setString('avatarLogin', data['avatarUrl'] != null? data['avatarUrl'] !:"");
        _prefs.setString('phoneLogin', data['phone'].toString());
        _prefs.setString('plateLogin', data['licensePlate'].toString());
        _prefs.setString('userIdLogin', data['userId'].toString());
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('3');
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xff1E1E2E),
        body: Container(
          child: Column(
            children: [
              Container(
                height: 30.h,
                width: size.width,
                child: Column(
                  children: [
                    Container(
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.only(right: 250),
                        child: Image.asset('assets/images/corner_left.png',
                            height: 120, color: secondaryTextColor)),
                    Text(
                      'Đăng nhập',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Vui lòng đăng nhập để sử dụng app',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Container(
                width: size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24))),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        
                        alignment: Alignment.topLeft,
                        child: Text(
                          'SỐ ĐIỆN THOẠI',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Container(
                          width: double.infinity,
                          child: TextField(
                            controller: phoneController,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
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
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'PASSWORD',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Container(
                          width: double.infinity,
                          child: TextField(
                            controller: passwordController,
                            style: TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),

                                // border: OutlineInputBorder(),
                                // hintText: "Input Phone here",
                                fillColor: Color(0xffF0F5FA),
                                filled: true,
                                suffix: IconButton(
                                    onPressed: () {
                                      //add Icon button at end of TextField
                                      setState(() {
                                        //refresh UI
                                        if (passenable) {
                                          //if passenable == true, make it false
                                          passenable = false;
                                        } else {
                                          passenable =
                                              true; //if passenable == false, make it true
                                        }
                                      });
                                    },
                                    icon: Icon(passenable == true
                                        ? Icons.remove_red_eye
                                        : Icons.password))),
                            autofocus: false,
                            obscureText: passenable,
                            textAlignVertical: TextAlignVertical.center,
                          ),
                          height: 64,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        child: Row(
                          children: [
                            // Container(
                            //   margin: EdgeInsets.only(right: 0),
                            //   child: Checkbox(
                            //     value: this.isRemember,
                            //     activeColor: Color(0xffFF7622),
                            //     onChanged: (isRemember) {
                            //       setState(() {
                            //         this.isRemember =
                            //             (isRemember)! ? isRemember : false;
                            //       });
                            //     },

                            //     // controlAffinity: ListTileControlAffinity.leading,
                            //   ),
                            // ),
                            // Container(
                            //   child: Text(
                            //     'Remember me',
                            //     style: TextStyle(
                            //       color: Color(0xff7E8A97),
                            //     ),
                            //   ),
                            // ),
                            Spacer(),
                            // Container(
                            //   margin: EdgeInsets.only(right: 2),
                            //   child: InkWell(
                            //     child: Text('Forgot Password',
                            //         style: TextStyle(
                            //           color: Color(0xffFF7622),
                            //         )),
                            //     onTap: () {
                            //       Navigator.pushAndRemoveUntil(
                            //           context,
                            //           MaterialPageRoute(
                            //               builder: (_) => ForgotPasswordPage()),
                            //           (route) => false);
                            //     },
                            //   ),
                            // )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: size.width,
                        height: 64,
                        child: ElevatedButton(
                          style: elevatedButtonStyle.copyWith(),
                          child: Text('Đăng nhập'),
                          onPressed: () async {
                            var phone = phoneController.text.toString().trim();
                            var password =
                                passwordController.text.toString().trim();
                            if (phone == "" || password == "") {
                              AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.warning,
                                      animType: AnimType.topSlide,
                                      showCloseIcon: true,
                                      title: "Cảnh báo",
                                      btnOkColor: primaryColor,
                                      desc:
                                          "   Số điện thoại hoặc mật khẩu không được để trống   ",
                                      btnOkOnPress: () {})
                                  .show();
                            } else {
                              var rs = await login(phone, password);
                              if (rs) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ShipperHomePage()),
                                    (route) => false);
                              } else {
                                AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.warning,
                                        animType: AnimType.topSlide,
                                        showCloseIcon: true,
                                        title: "Cảnh báo",
                                        btnOkColor: primaryColor,
                                        desc:
                                            "   Số điện thoại hoặc mật khẩu không đúng   ",
                                        btnOkOnPress: () {
                                          
                                        })
                                    .show();
                              }
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Text(
                          //   'Don\'t have an account?',
                          //   style: TextStyle(color: secondaryTextColor),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 12),
                          //   child: InkWell(
                          //     onTap: () {
                          //       Navigator.pushAndRemoveUntil(
                          //           context,
                          //           MaterialPageRoute(
                          //               builder: (_) => SignUpPage()),
                          //           (route) => false);
                          //     },
                          //     child: Text(
                          //       'SIGN UP',
                          //       style: TextStyle(
                          //           color: primaryColor,
                          //           fontWeight: FontWeight.bold),
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                      const SizedBox(
                        height: 157,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
