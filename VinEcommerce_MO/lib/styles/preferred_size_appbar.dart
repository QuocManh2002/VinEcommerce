import 'package:flutter/material.dart';
import 'package:vin_ecommerce/screens/order_flow/shipper_homepage.dart';
import 'package:vin_ecommerce/screens/setting_flow/setting_homepage.dart';
import 'package:vin_ecommerce/styles/color.dart';
import '../screens/setting_flow/update_info.dart';
import 'app_assets.dart';

class CustomerAppBarSetting extends StatelessWidget {
  final String title;
  final bool isEditable;
  const CustomerAppBarSetting({super.key, required this.title, required this.isEditable});

  @override
  PreferredSize build(BuildContext context) {
    
    
    return
     PreferredSize(
        child: Container(
            margin: const EdgeInsets.only(top: 16),
            child: Row(
              children: [
                Container(
                  height: 55,
                  child: RawMaterialButton(
                    onPressed: () {
                      isEditable? 
                      Navigator.push(context, MaterialPageRoute(builder: (_) => ShipperHomePage())):
                      Navigator.push(context, MaterialPageRoute(builder: (_) => SettingHomePage()));
                      
                    },
                    shape: CircleBorder(),
                    child: Image.asset(AppAssets.left_arrow),
                    elevation: 1,
                  ),
                ),
                Container(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(child: Text("")),
                isEditable ? 
                InkWell(
                  child: Container(
                    margin: EdgeInsets.only(right: 16),
                    child: Text('Sửa', style: TextStyle(decorationStyle: TextDecorationStyle.double, decoration: TextDecoration.underline, color: primaryColor, fontSize: 20,fontWeight: FontWeight.bold ),
                    )),
                    onTap: (){
                     
                      Navigator.push(context, MaterialPageRoute(builder: (_) => UpdateInfoPage()));
                    },
                ):
                Text("")
              ],
            )),
        preferredSize: Size.fromHeight(75));
  }
  }
