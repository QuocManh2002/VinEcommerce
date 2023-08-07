import 'dart:async';
import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer2/sizer2.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:vin_ecommerce/data_access/order_repository.dart';
import 'package:vin_ecommerce/data_access/user_repository.dart';
import 'package:vin_ecommerce/screens/setting_flow/setting_homepage.dart';
import 'package:vin_ecommerce/styles/app_assets.dart';
import 'package:vin_ecommerce/styles/color.dart';
import 'package:vin_ecommerce/styles/order_status_style.dart';

import '../../models/order_model.dart';
import '../../models/user_model.dart';
import 'order_detail.dart';
import 'order_panel_widget.dart';

class ShipperHomePage extends StatefulWidget {
  const ShipperHomePage({super.key});
  @override
  State<StatefulWidget> createState() => _ShipperHomePageState();
}

class _ShipperHomePageState extends State<ShipperHomePage>
    with TickerProviderStateMixin {
  late TabController tabController;
  OrderRepository orderRepo = new OrderRepository();
  List<Order> _orderList = [];
  List<Order> _deliveredList = [];
  bool isRefresh = false;
  String _avatarUrl = "";
  bool _onGoingOrder = false;
  final cron = Cron();
  int alarmId = 1;
  bool isLoading = true;
  User? _user;
  UserRepository userRepo = UserRepository();
  String avatarUserUrl ="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    reload();
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  reload() {
    // cron.schedule(Schedule.parse("* * * * *"), ()  => {
    //   print("MANHA"),
    //    getData(),
    // });

  }

  testAlarm() {
    print('Manhhhhh');
  }

  getData() async {
    var list = await orderRepo.getPendingOrders();
    var deliveredList = await orderRepo.getDeliveredOrders();
    SharedPreferences pref = await SharedPreferences.getInstance();
    var avatar = pref.getString('avatarLogin') != null ?pref.getString('avatarLogin')!:AppAssets.default_avatar_url;
    var onGoingOrder =
        pref.getString('onGoingOrder').toString().trim() == "" || pref.getString('onGoingOrder') == null ? false : true;
    var user = await userRepo.getInfo();
    setState(() {
      _avatarUrl = avatar;
      _orderList = list;
      _deliveredList = deliveredList;
      _onGoingOrder = onGoingOrder;
      _user = user;
    });
    isLoading = false;
  }

  Future<void> _handleRefresh() async {
    getData();
    return await Future.delayed(Duration(seconds: 0));
  }

  @override
  Widget build(BuildContext context) {
    avatarUserUrl = _user != null && _user?.imgUrl != null? _user!.imgUrl! : AppAssets.default_avatar_url; 
    return SafeArea(
        child: 
        
        Scaffold(
      backgroundColor: Colors.white,
      appBar: _appbar(),
      body: 
      isLoading? 
        Center(child: Image.asset(AppAssets.loading_gif),):
      SlidingUpPanel(
        parallaxEnabled: true,
        parallaxOffset: .5,
        minHeight: _onGoingOrder ? 20.h : 0.h,
        maxHeight: 70.h,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        body: LiquidPullToRefresh(
          onRefresh: _handleRefresh,
          color: primaryColor,
          height: 50,
          showChildOpacityTransition: false,
          child: TabBarView(
            controller: tabController,
            children: [
              ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _orderList.length,
                  itemBuilder: (context, index) {
                    int orderId = _orderList[index].Id != null
                        ? _orderList[index].Id!
                        : 0;
                    String orderStatusId = _orderList[index].Status != null
                        ? _orderList[index].Status!
                        : "";
                    String storeName = _orderList[index].storeName != null
                        ? _orderList[index].storeName!
                        : "";
                    String toBuildingName =
                        _orderList[index].fromBuildingName != null
                            ? _orderList[index].fromBuildingName!
                            : "";
                    String fromBuildingName =
                        _orderList[index].toBuildingName != null
                            ? _orderList[index].toBuildingName!
                            : "";
                    String customerName = _orderList[index].customerName != null
                        ? _orderList[index].customerName!
                        : "";
                    String storeImageUrl =
                        _orderList[index].storeImageUrl != null
                            ? _orderList[index].storeImageUrl!
                            : AppAssets.default_store_image_url;
                    return InkWell(
                        child: Container(
                          margin: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(155, 220, 222, 224),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24))),
                          child: Container(
                            height: 30.h,
                            child: Column(children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Container(
                                      margin: EdgeInsets.only(left: 16),
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          image: DecorationImage(
                                              image:
                                                  NetworkImage(storeImageUrl),
                                              fit: BoxFit.fill)),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 12),
                                        child: Text(
                                          storeName,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Mã đơn hàng #',
                                              style: TextStyle(
                                                  color: secondaryTextColor),
                                            ),
                                            Text(
                                              orderId.toString(),
                                              style: TextStyle(
                                                  color: secondaryTextColor),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(child: Text('')),
                                  OrderStatus(
                                    statusId: orderStatusId,
                                  )
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.black38,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 25),
                                      child: Text(
                                        'Từ',
                                        style: TextStyle(
                                            color: secondaryTextColor),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                            'assets/images/from_icon.png'),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          fromBuildingName,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 25),
                                          child: Text(
                                            'Đến',
                                            style: TextStyle(
                                                color: secondaryTextColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                            'assets/images/to_icon.png'),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          toBuildingName,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(child: Text('')),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                child: Row(
                                  children: [
                                    Text(
                                      'Khách hàng',
                                      style:
                                          TextStyle(color: secondaryTextColor),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      customerName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(child: Text('')),
                                    InkWell(
                                        onTap: () async {
                                          final SharedPreferences _prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          _prefs.setString(
                                              'orderId', orderId.toString());
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    OrderDetailPage()),
                                          );
                                        },
                                        child: Text(
                                          'CHI TIẾT >',
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontWeight: FontWeight.bold),
                                        ))
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ),
                        onTap: () async {
                          
                          final SharedPreferences _prefs =
                              await SharedPreferences.getInstance();
                          _prefs.setString('orderId', orderId.toString());
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => OrderDetailPage()),
                          );
                        });
                  }),
              ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _deliveredList.length,
                  itemBuilder: ((context, index) {
                    int orderId = _deliveredList[index].Id != null
                        ? _deliveredList[index].Id!
                        : 0;
                    String orderStatusId = _deliveredList[index].Status != null
                        ? _deliveredList[index].Status!
                        : "";
                    String storeName = _deliveredList[index].storeName != null
                        ? _deliveredList[index].storeName!
                        : "";
                    String toBuildingName =
                        _deliveredList[index].fromBuildingName != null
                            ? _deliveredList[index].fromBuildingName!
                            : "";
                    String fromBuildingName =
                        _deliveredList[index].toBuildingName != null
                            ? _deliveredList[index].toBuildingName!
                            : "";
                    String customerName =
                        _deliveredList[index].customerName != null
                            ? _deliveredList[index].customerName!
                            : "";
                    String storeImageUrl =
                        _orderList[index].storeImageUrl != null
                            ? _orderList[index].storeImageUrl!
                            : AppAssets.default_store_image_url;
                    return InkWell(
                      onTap: () async {
                        final SharedPreferences _prefs =
                            await SharedPreferences.getInstance();
                        _prefs.setString('orderId', orderId.toString());
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => OrderDetailPage()),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(155, 220, 222, 224),
                            borderRadius:
                                BorderRadius.all(Radius.circular(24))),
                        child: Container(
                          height: 30.h,
                          child: Column(children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Container(
                                    margin: EdgeInsets.only(left: 16),
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        image: DecorationImage(
                                            // image: AssetImage(AppAssets.default_avatar),
                                            image: NetworkImage(storeImageUrl),
                                            fit: BoxFit.fill)),
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 12),
                                      child: Text(
                                        storeName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Mã đơn hàng #',
                                            style: TextStyle(
                                                color: secondaryTextColor),
                                          ),
                                          Text(
                                            orderId.toString(),
                                            style: TextStyle(
                                                color: secondaryTextColor),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(child: Text('')),
                                OrderStatus(
                                  statusId: orderStatusId,
                                )
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Divider(
                                thickness: 1,
                                color: Colors.black38,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 25),
                                    child: Text(
                                      'Từ',
                                      style:
                                          TextStyle(color: secondaryTextColor),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                          'assets/images/from_icon.png'),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        fromBuildingName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 25),
                                        child: Text(
                                          'Đến',
                                          style: TextStyle(
                                              color: secondaryTextColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    children: [
                                      Image.asset('assets/images/to_icon.png'),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        toBuildingName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(child: Text('')),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  Text(
                                    'Khách hàng',
                                    style: TextStyle(color: secondaryTextColor),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    customerName,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(child: Text('')),
                                  InkWell(
                                      onTap: () async {
     
                                        final SharedPreferences _prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        _prefs.setString(
                                            'orderId', orderId.toString());

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  OrderDetailPage()),
                                        );
                                      },
                                      child: Text(
                                        'CHI TIẾT >',
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontWeight: FontWeight.bold),
                                      ))
                                ],
                              ),
                            ),
                          ]),
                        ),
                      ),
                    );
                  })),
            ],
          ),
        ),
        panelBuilder: (controller) => OrderPanelWidget(
          controller: controller,
          status: "Đang giao",
          isHomePage: true,
        ),
      ),
      floatingActionButtonLocation: _onGoingOrder
          ? FloatingActionButtonLocation.endTop
          : FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: getData,
        backgroundColor: Colors.white,
        child: Image.asset(AppAssets.refresh),
      ),
    ));
  }

  void getValidation() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    print("token ne`" + token!);
  }

  PreferredSize _appbar() {
    return PreferredSize(
        child: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _topBar(),
            _tabBar(),
          ],
        )),
        preferredSize: Size.fromHeight(140));
  }

  Widget _topBar() {
    return Container(
      decoration: BoxDecoration(color: primaryColor),
      child: Row(
        children: [
          SizedBox(width: 32,),
          Text("VinEcom", style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.w900, fontFamily: 'SF Pro Text' ),),
          const SizedBox(
            width: 16,
          ),
          Expanded(child: Text("")),
          Container(
            margin: EdgeInsets.only(top: 20, right: 20),
            padding: EdgeInsets.only(bottom: 10),
              alignment: AlignmentDirectional.topEnd,
              child: RawMaterialButton(
                shape: CircleBorder(),
                onPressed: () {
                  getValidation();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SettingHomePage()),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(left: 16),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image:  avatarUserUrl != ""
                              ? NetworkImage(avatarUserUrl)
                              : NetworkImage(AppAssets.default_avatar_url),
                          fit: BoxFit.cover)),
                ),
              ))
        ],
      ),
    );
  }

  Widget _tabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: TabBar(
          controller: tabController,
          indicatorColor: primaryColor,
          labelColor: primaryColor,
          unselectedLabelColor: secondaryTextColor,
          tabs: const [
            Tab(text: 'Đơn hàng khả dụng'),
            Tab(
              text: 'Lịch sử',
            ),
          ]),
    );
  }
}
