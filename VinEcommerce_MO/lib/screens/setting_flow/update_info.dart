import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vin_ecommerce/data_access/user_repository.dart';
import 'package:vin_ecommerce/screens/setting_flow/setting_homepage.dart';
import 'package:vin_ecommerce/styles/app_assets.dart';
import 'package:vin_ecommerce/data_access/image_repository.dart';
import 'package:vin_ecommerce/styles/color.dart';
import '../../models/user_model.dart';
import '../../styles/button_style.dart';
import '../../styles/input_text_field.dart';
import '../../styles/preferred_size_appbar.dart';

class UpdateInfoPage extends StatefulWidget {
  const UpdateInfoPage({super.key});

  @override
  State<UpdateInfoPage> createState() => _UpdateInfoPageState();
}

class _UpdateInfoPageState extends State<UpdateInfoPage> {
  String _imgUrl = "";
  String _name = "";
  String _phone = "";
  String _vehiclePlate = "";
  XFile? myImage;
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController plateController = TextEditingController();
  ImageRepository imgRepo = ImageRepository();
  UserRepository userRepo = UserRepository();
  bool? isLoadingUpdate = false;

  bool isLoading = true;
  User? user;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    var _user = await userRepo.getInfo();
    String imgUrl = _user != null || _user?.imgUrl != null
        ? _user!.imgUrl!
        : AppAssets.default_avatar_url;
    String name = _user != null || _user?.name != null ? _user!.name! : "";
    String phone = _user != null || _user?.phone != null ? _user!.phone! : "";
    String plate = _user != null || _user?.plate != null ? _user!.plate! : "";
    setState(() {
      _name = name;
      _imgUrl = imgUrl;
      _phone = phone;
      _vehiclePlate = plate;
      phoneController.text = _phone;
      nameController.text = _name;
      plateController.text = _vehiclePlate;
    });
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomerAppBarSetting(title: "Thông tin", isEditable: false)
          .build(context),
      body: isLoading
          ? Center(
              child: Image.asset(AppAssets.loading_gif),
            )
          : Center(
              child: Container(
                margin: EdgeInsets.only(top: 32),
                child: Column(children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 64,
                        backgroundImage: myImage != null
                            ? Image.file(File(myImage!.path)).image
                            : NetworkImage(_imgUrl),
                      ),
                      Positioned(
                        child: IconButton(
                            onPressed: () async {
                              final ImagePicker _picker = ImagePicker();
                              myImage = await _picker.pickImage(
                                  source: ImageSource.gallery);
                              print('${myImage?.path}');
                              setState(() {});
                            },
                            icon: Icon(Icons.add_a_photo)),
                        bottom: -10,
                        left: 80,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 28),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Họ và tên',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  InputTextField(controller: nameController),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 28),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Số điện thoại',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  InputTextField(controller: phoneController),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 28),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Biển số xe',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  InputTextField(controller: plateController),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (myImage != null) {
                        var newImgUrl =
                            await imgRepo.uploadImageToFireBase(myImage);
                        _imgUrl = newImgUrl;
                      }

                      if (nameController.text.trim() == "" ||
                          phoneController.text.trim() == "" ||
                          plateController.text.trim() == "") {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.topSlide,
                          showCloseIcon: true,
                          title: "Cập nhật",
                          btnOkColor: primaryColor,
                          btnOkText: "Đồng ý",
                          desc: "   Hãy điền đầy đủ thông tin người dùng   ",
                          btnOkOnPress: () {},
                        ).show();
                      } else {
                        setState(() {
                          isLoadingUpdate = true;
                        });
                        isLoadingUpdate = await userRepo.updateInfo(
                            nameController.text,
                            phoneController.text,
                            _imgUrl,
                            plateController.text);
                        if (isLoadingUpdate!) {
                          isLoadingUpdate = false;
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.success,
                            animType: AnimType.topSlide,
                            showCloseIcon: true,
                            title: "Cập nhật",
                            btnOkColor: greenColor,
                            btnOkText: "Đồng ý",
                            desc: "   Cập nhật thông tin thành công  ",
                            btnOkOnPress: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => SettingHomePage()));
                            },
                          ).show();
                        }
                      }
                    },
                    child: isLoadingUpdate!
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "LƯU",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                    style: elevatedButtonStyle,
                  )
                ]),
              ),
            ),
    ));
  }
}
