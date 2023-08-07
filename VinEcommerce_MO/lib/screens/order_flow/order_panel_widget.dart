// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer2/sizer2.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vin_ecommerce/screens/order_flow/order_tracking_page.dart';
import 'package:vin_ecommerce/screens/success/status_order.dart';
import 'package:vin_ecommerce/styles/app_assets.dart';
import 'package:vin_ecommerce/styles/color.dart';
import '../../data_access/order_repository.dart';
import '../../models/order_detail_model.dart';
import '../../models/order_model.dart';
import '../../styles/button_style.dart';
import '../../styles/customer_page_route.dart';

class OrderPanelWidget extends StatefulWidget {
  final ScrollController controller;
  final String status;
  final bool isHomePage;
  const OrderPanelWidget(
      {super.key, required this.controller, required this.status, required this.isHomePage});
  @override
  State<OrderPanelWidget> createState() => _OrderPanelWidgetState();
}

class _OrderPanelWidgetState extends State<OrderPanelWidget> {
  final ScrollController controller = ScrollController();
  Order? _order;
  List<OrderDetail> _orderDetail = [];
  OrderRepository orderRepo = new OrderRepository();
  bool isLoading = true;
  String _orderId = "";
  bool _isHomePage =false;


  getData() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    var orderId = _prefs.getString('onGoingOrder') != null
        ? _prefs.getString('onGoingOrder')!
        : "";
        List<OrderDetail> orderDetail = [];
        Order? order;
    if (orderId != "") {
       order = await orderRepo.getOrderById(orderId.toString());
       orderDetail = await orderRepo.getOrderDetails(orderId.toString());
    }

    setState(() {
      if (orderId != "") {
        _order = order;
        _orderDetail = orderDetail;
      }

      _orderId = orderId;
    });
    isLoading = false;
  }

  @override
  void initState() {
    _isHomePage = widget.isHomePage;
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      children: <Widget>[
        SizedBox(
          height: 16,
        ),
        isLoading ? Text('') : orderWidget(),
        SizedBox(
          height: 16,
        )
      ],
    );
  }

  Widget orderWidget() {
    String storeName = _order != null ? _order!.storeName! : "";
    String customerName = _order != null ? _order!.customerName! : "";
    String customerPhone = _order != null ? _order!.customerPhone! : "";
    Uri phoneNumber = Uri.parse('tel:+84' + customerPhone);
    String storeImageUrl = _order != null
        ? _order!.storeImageUrl!
        : AppAssets.default_store_image_url;
        String customerImageUrl = _order != null && _order?.customerImageUrl != null  ? _order!.customerImageUrl! : AppAssets.default_avatar_url;
    return 
    _orderId ==""? Text(""):
    Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(14))),
      child: Column(children: [
        Container(
          height: 5,
          width: 60,
          decoration: BoxDecoration(
              color: secondaryTextColor,
              borderRadius: BorderRadius.all(Radius.circular(12))),
        ),
        Container(
          margin: EdgeInsets.only(top: 8),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 16),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        image: NetworkImage(storeImageUrl), fit: BoxFit.fill)),
              ),
              const SizedBox(
                width: 6,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 17,
                  ),
                  Text(
                    storeName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 16),
                    child: Row(
                      children: [
                        Container(
                          width: 35.w,
                          height: 52,
                          child: ElevatedButton(
                            style: elevatedButtonStyle,
                            child: Text('HOÀN THÀNH', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            
                            ),
                            onPressed: () {
                              var rs = orderRepo.finishOrder();

                              Navigator.push(
                                  context,
                                  CustomerPageRoute(
                                      child: StatusOrderPage(status: 3),
                                      direction: AxisDirection.left));
                            },
                          ),
                        ),
                        
                         SizedBox(
                          width: _isHomePage ? 8:14,
                        ),
                        Container(
                          height: 55,
                          width: 55,
                          child: RawMaterialButton(
                            fillColor: primaryColor,
                            shape: CircleBorder(),
                            elevation: 1,
                            onPressed: () async {
                              await launchUrl(phoneNumber);
                            },
                            child: Image.asset(
                              AppAssets.phone,
                              scale: 1.5,
                            ),
                          ),
                        ),

                        _isHomePage? Container(
                          height: 55,
                           width: 55,
                           margin: EdgeInsets.only(left: 18),
                          child: RawMaterialButton(
                            fillColor: primaryColor,
                            shape: CircleBorder(),
                            elevation: 1,
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  CustomerPageRoute(
                                      child: OrderTrackingPage(),
                                      direction: AxisDirection.left));
                            },
                            child: Image.asset(
                              AppAssets.map,
                              
                            ),
                          ),
                        ): Text("")
                      ],
                    ),
                  ),
                  
                  
                  Container(
                    margin: const EdgeInsets.only(top: 24),
                    width: 68.w,
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _orderDetail.length,
                        itemBuilder: ((context, index) {
                          String productName =
                              _orderDetail[index].productName != null
                                  ? _orderDetail[index].productName!
                                  : "";
                          int quantity = _orderDetail[index].quantity != null
                              ? _orderDetail[index].quantity!
                              : 0;

                          return Container(
                            child: Row(
                              children: [
                                Text(productName.toString()),
                                Text('  x'),
                                Text(quantity.toString())
                              ],
                            ),
                          );
                        })),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Divider(
            thickness: 2,
            color: Color.fromARGB(255, 228, 228, 228),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  height: 30.h,
                  width: 20.w,
                  child: IconStepper(
                    direction: Axis.vertical,
                    enableNextPreviousButtons: false,
                    enableStepTapping: false,
                    stepColor: primaryColor,
                    activeStepBorderColor: Colors.white,
                    activeStepBorderWidth: 0.0,
                    activeStepBorderPadding: 0.0,
                    lineColor: primaryColor,
                    lineLength: 2.h,
                    lineDotRadius: 0.1,
                    stepRadius: 15,
                    alignment: Alignment.centerLeft,
                    activeStep: 1,
                    activeStepColor: primaryColor,
                    icons: [
                      Icon(Icons.check, color: Colors.white),
                      Icon(Icons.radio_button_off, color: Colors.white),
                      Icon(
                        Icons.check,
                        color: primaryColor,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: 45,
                          child: Text(
                            'Xác nhận đơn hàng',
                            style: TextStyle(color: primaryColor),
                          )),
                      Container(
                          height: 45,
                          child: Text('Giao đến cho khách hàng',
                              style: TextStyle(color: secondaryTextColor))),
                      Container(
                          height: 45,
                          child: Text('Hoàn thành đơn hàng',
                              style: TextStyle(color: secondaryTextColor)))
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Divider(
            thickness: 2,
            color: Color.fromARGB(255, 228, 228, 228),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 16),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(customerImageUrl),
                        fit: BoxFit.fill)),
              ),
              Container(
                margin: EdgeInsets.only(left: 16),
                child: Text(
                  customerName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        )
      ]),
    );
  }
}
