import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:vin_ecommerce/data_access/user_repository.dart';
import 'package:vin_ecommerce/screens/setting_flow/setting_homepage.dart';
import 'package:vin_ecommerce/styles/button_style.dart';

import '../../models/user_model.dart';
import '../../styles/app_assets.dart';
import '../../styles/color.dart';

class UpdatePassWordPage extends StatefulWidget {
  const UpdatePassWordPage({super.key});

  @override
  State<UpdatePassWordPage> createState() => _UpdatePassWordPageState();
}

class _UpdatePassWordPageState extends State<UpdatePassWordPage> {
  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  UserRepository userRepo = UserRepository();
  User? _userLogin;
  bool passenableCurrent = true;
  bool passenableNew = true;
  bool passenableConfirm = true;
  bool isLoadingUpdate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    var userLogin = await userRepo.getInfo();
    setState(() {
      _userLogin = userLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    String imgUrl =
        _userLogin != null ? _userLogin!.imgUrl! : AppAssets.default_avatar_url;
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar(),
      body: Container(
        margin: EdgeInsets.only(top: 32),
        child: Center(
          child: Column(children: [
            CircleAvatar(
              radius: 64,
              backgroundImage: NetworkImage(imgUrl),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              margin: EdgeInsets.only(left: 28),
              alignment: Alignment.topLeft,
              child: Text(
                'Mật khẩu hiện tại',
                style: TextStyle(fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 28, right: 28),
              child: Container(
                width: double.infinity,
                child: TextField(
                  controller: currentPassword,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      fillColor: Color.fromARGB(255, 230, 230, 230),
                      filled: true,
                      suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              if (passenableCurrent) {
                                passenableCurrent = false;
                              } else {
                                passenableCurrent = true;
                              }
                            });
                          },
                          icon: Icon(passenableCurrent == true
                              ? Icons.remove_red_eye
                              : Icons.password))),
                  autofocus: false,
                  obscureText: passenableCurrent,
                  textAlignVertical: TextAlignVertical.center,
                ),
                height: 64,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              margin: EdgeInsets.only(left: 28),
              alignment: Alignment.topLeft,
              child: Text(
                'Mật khẩu mới',
                style: TextStyle(fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 28, right: 28),
              child: Container(
                width: double.infinity,
                child: TextField(
                  controller: newPassword,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      fillColor: Color.fromARGB(255, 230, 230, 230),
                      filled: true,
                      suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              if (passenableNew) {
                                passenableNew = false;
                              } else {
                                passenableNew = true;
                              }
                            });
                          },
                          icon: Icon(passenableNew == true
                              ? Icons.remove_red_eye
                              : Icons.password))),
                  autofocus: false,
                  obscureText: passenableNew,
                  textAlignVertical: TextAlignVertical.center,
                ),
                height: 64,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              margin: EdgeInsets.only(left: 28),
              alignment: Alignment.topLeft,
              child: Text(
                'Xác nhận mật khẩu mới',
                style: TextStyle(fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 28, right: 28),
              child: Container(
                width: double.infinity,
                child: TextField(
                  controller: confirmPassword,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      fillColor: Color.fromARGB(255, 230, 230, 230),
                      filled: true,
                      suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              if (passenableConfirm) {
                                passenableConfirm = false;
                              } else {
                                passenableConfirm = true;
                              }
                            });
                          },
                          icon: Icon(passenableConfirm == true
                              ? Icons.remove_red_eye
                              : Icons.password))),
                  autofocus: false,
                  obscureText: passenableConfirm,
                  textAlignVertical: TextAlignVertical.center,
                ),
                height: 64,
              ),
            ),
            SizedBox(
              height: 32,
            ),
            ElevatedButton(
              onPressed: () async {
                if (currentPassword.text.trim() == "" ||
                    newPassword.text.trim() == "" ||
                    confirmPassword.text.trim() == "") {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.topSlide,
                    showCloseIcon: true,
                    title: "Cập nhật",
                    btnOkColor: primaryColor,
                    btnOkText: "Đồng ý",
                    desc: "   Hãy điền đầy đủ mật khẩu   ",
                    btnOkOnPress: () {},
                  ).show();
                } else if (newPassword.text != confirmPassword.text) {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.topSlide,
                    showCloseIcon: true,
                    title: "Cập nhật",
                    btnOkColor: primaryColor,
                    btnOkText: "Đồng ý",
                    desc:
                        "   Mật khẩu và xác nhận mật khẩu không giống nhau   ",
                    btnOkOnPress: () {},
                  ).show();
                } else {
                  setState(() {
                    isLoadingUpdate = true;
                  });
                  isLoadingUpdate = await userRepo.updatePassword(
                      currentPassword.text, newPassword.text);
                  if (isLoadingUpdate) {
                    isLoadingUpdate = false;
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.success,
                      animType: AnimType.topSlide,
                      showCloseIcon: true,
                      title: "Cập nhật",
                      btnOkColor: greenColor,
                      btnOkText: "Đồng ý",
                      desc: "   Cập nhật mật khẩu thành công  ",
                      btnOkOnPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => SettingHomePage()));
                      },
                    ).show();
                  } else {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.topSlide,
                      showCloseIcon: true,
                      title: "Cập nhật",
                      btnOkColor: primaryColor,
                      btnOkText: "Đồng ý",
                      desc: "   Mật khẩu hiện tại không đúng  ",
                      btnOkOnPress: () {
                        setState(() {});
                      },
                    ).show();
                  }
                }
              },
              child: Text(
                "LƯU",
              ),
              style: elevatedButtonStyle,
            )
          ]),
        ),
      ),
    ));
  }

  PreferredSize appBar() {
    return PreferredSize(
        child: Container(
            margin: const EdgeInsets.only(top: 16),
            child: Row(
              children: [
                Container(
                  height: 55,
                  child: RawMaterialButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => SettingHomePage()));
                    },
                    shape: CircleBorder(),
                    child: Image.asset(AppAssets.left_arrow),
                    elevation: 1,
                  ),
                ),
                Container(
                  child: Text(
                    "Đổi mật khẩu",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(child: Text("")),
              ],
            )),
        preferredSize: Size.fromHeight(75));
  }
}
