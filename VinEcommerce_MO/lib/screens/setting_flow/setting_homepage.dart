import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vin_ecommerce/data_access/user_repository.dart';
import 'package:vin_ecommerce/screens/setting_flow/update_password.dart';
import 'package:vin_ecommerce/screens/sign_in_page.dart';
import 'package:vin_ecommerce/styles/app_assets.dart';
import 'package:vin_ecommerce/styles/color.dart';
import 'package:vin_ecommerce/styles/preferred_size_appbar.dart';

import '../../models/user_model.dart';
import '../../styles/color_tile.dart';

class SettingHomePage extends StatefulWidget {
  const SettingHomePage({super.key});

  @override
  State<SettingHomePage> createState() => _SettingHomePageState();
}

class _SettingHomePageState extends State<SettingHomePage> {
  UserRepository userRepo = UserRepository();
  User? _user;
  getData() async {
      var user = await userRepo.getInfo();
    setState(() {
      _user = user;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    String imgUrl = _user != null || _user?.imgUrl != null ? _user!.imgUrl! :AppAssets.default_avatar_url;
    String name = _user != null || _user?.name != null ? _user!.name! :"";
    String phone = _user != null || _user?.phone != null ? _user!.phone! :"";
    String plate = _user != null || _user?.plate != null ? _user!.plate! :""; 
    return SafeArea(
      child: Scaffold(
        appBar: CustomerAppBarSetting(
          title: "Thông tin",
          isEditable: true,
        ).build(context),

        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(children: [
            const SizedBox(
              height: 32,
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 16),
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(imgUrl),
                          fit: BoxFit.cover)),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16),
                  child: Text(
                    name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            diviver(),
            Column(
              children: [
                ColorTile(
                  icon: Icons.person_outline,
                  color: primaryColor,
                  text: "Họ và tên",
                  status: false,
                  subTitle: name,
                ),
                ColorTile(
                  icon: Icons.call,
                  color: deliveredForegroundColor,
                  text: "Số điện thoại",
                  subTitle: phone,
                  status: false,
                ),
                ColorTile(
                  icon: Icons.two_wheeler,
                  color: pickedUpForegroundColor,
                  text: "Biển số xe",
                  subTitle: plate,
                  status: false,
                ),
                diviver(),
                InkWell(
                  child: ColorTile(icon: Icons.lock, color: redColor, text: "Đổi mật khẩu", subTitle: "", status: true),
                  onTap: () {
                    Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => UpdatePassWordPage()) );     
                  },
                ),
                InkWell(
                  child: Container(
                    child: colorTile(Icons.logout, Colors.black, "Đăng xuất"),
                  ),
                  onTap: () async {
                    final SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    var onGoingOrder = pref.getString('onGoingOrder') != null
                        ? pref.getString('onGoingOrder')!
                        : "";
                    if (onGoingOrder != "") {
                      AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              animType: AnimType.topSlide,
                              showCloseIcon: true,
                              title: "Cảnh báo",
                              btnOkColor: primaryColor,
                              desc:
                                  "   Bạn đang trong đơn hàng, hãy hoàn thành đơn hàng này trước khi đăng xuất   ",
                              btnOkOnPress: () {})
                          .show();
                    } else {
                      AwesomeDialog(
                              context: context,
                              dialogType: DialogType.question,
                              animType: AnimType.leftSlide,
                              showCloseIcon: true,
                              title: "Đăng xuất",
                              btnOkColor: primaryColor,
                              btnOkText: "Đồng ý",
                              btnCancelText: "Đóng",
                              desc:
                                  "   Bạn có muốn thoát khỏi phiên đăng nhập này không ?  ",
                              btnOkOnPress: () {
                                pref.clear();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => SignInPage()));
                              },
                              btnCancelOnPress: (){})
                          .show();
                      
                    }
                  },
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }


  Widget colorTile(IconData icon, Color color, String text) {
    Widget leading = Container(
      height: 50,
      width: 50,
      child: Icon(icon, color: color),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(18),
      ),
    );

    Widget title = Container(
      child: Text(text),
    );

    return ListTile(
      leading: leading,
      title: title,
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
    );
  }

  Widget diviver() {
    return Divider(
      thickness: 1.5,
      color: Colors.black12,
    );
  }
}
