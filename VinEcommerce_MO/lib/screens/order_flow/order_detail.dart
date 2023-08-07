import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer2/sizer2.dart';
import 'package:vin_ecommerce/data_access/order_repository.dart';
import 'package:vin_ecommerce/models/order_detail_model.dart';
import 'package:vin_ecommerce/screens/success/status_order.dart';
import 'package:vin_ecommerce/styles/app_assets.dart';
import 'package:vin_ecommerce/styles/button_style.dart';
import 'package:vin_ecommerce/styles/color.dart';
import 'package:vin_ecommerce/styles/customer_page_route.dart';
import 'package:vin_ecommerce/styles/order_status_style.dart';

import '../../models/order_model.dart';
// import 'alert_dialog.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key});
  @override
  State<StatefulWidget> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  bool isLoading = true;
  Order? _order;
  List<OrderDetail> _orderDetail = [];
  OrderRepository orderRepo = new OrderRepository();

  String _orderId = "";
  int _total = 0;

  getData() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();

    var orderId = _prefs.getString('orderId');

    var order = await orderRepo.getOrderById(orderId.toString());
    var orderDetail = await orderRepo.getOrderDetails(orderId.toString());
    var total = await orderRepo.getTotal();
    _orderId = orderId.toString();
    setState(() {
      _order = order;
      _orderDetail = orderDetail;
      _total = total;
    });
    isLoading = false;
  }

  Future<bool> receiveOrder() async {
    return await orderRepo.receiveOrder(_orderId);
  }

  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int orderId = _order != null ? _order!.Id! : 0;
    String storeName = _order != null ? _order!.storeName! : "";
    String customerName = _order != null ? _order!.customerName! : "";
    String fromBuildingName = _order != null ? _order!.fromBuildingName! : "";
    String toBuildingName = _order != null ? _order!.toBuildingName! : "";
    String customerPhone = _order != null ? _order!.customerPhone! : "";
    String status = _order != null ? _order!.Status! : "";
    String customerImgUrl = _order?.customerImageUrl != null ? _order!.customerImageUrl! : AppAssets.default_avatar_url;
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    height: 55,
                    child: RawMaterialButton(
                      fillColor: Color(0xffECF0F4),
                      shape: CircleBorder(),
                      elevation: 1,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        'assets/images/left_arrow.png',
                        scale: 1.5,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 60),
                      child: isLoading
                          ? Text('')
                          : Text(
                              '# ' + orderId.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24),
                              textAlign: TextAlign.center,
                            ),
                    ),
                  )
                ],
              ),
            ),
            preferredSize: Size.fromHeight(100)),
        body: isLoading
            ? Center(child: Image.asset(AppAssets.loading_gif))
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Đơn hàng',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        width: 100.w,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 220, 222, 224),
                            borderRadius:
                                BorderRadius.all(Radius.circular(24))),
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 16, left: 16, right: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  storeName,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                OrderStatus(statusId: status)
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Divider(
                              thickness: 1,
                              color: Colors.black12,
                            ),
                          ),
                          ListView.builder(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _orderDetail.length,
                              itemBuilder: ((context, index) {
                                String productName =
                                    _orderDetail[index].productName != null
                                        ? _orderDetail[index].productName!
                                        : "";
                                int quantity =
                                    _orderDetail[index].quantity != null
                                        ? _orderDetail[index].quantity!
                                        : 0;

                                return Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Row(
                                      children: [
                                        Text(productName.toString()),
                                        Text('  x'),
                                        Text(quantity.toString())
                                      ],
                                    ),
                                  ),
                                );
                              })),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Divider(
                              thickness: 1,
                              color: Colors.black12,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 16, bottom: 16),
                            alignment: Alignment.centerLeft,
                            child: RichText(
                                maxLines: 1,
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                    text: 'Tổng tiền:  ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                    children: [
                                      TextSpan(
                                          text: _total.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: greenColor))
                                    ])),
                          )
                        ]),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        child: Text(
                          'Khách hàng',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        width: 100.w,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 220, 222, 224),
                            borderRadius:
                                BorderRadius.all(Radius.circular(24))),
                        child: Row(children: [
                          Container(
                            margin:
                                EdgeInsets.only(left: 16, top: 8, bottom: 8),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(customerImgUrl),
                                    fit: BoxFit.fill)),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(customerName),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  customerPhone,
                                  style: TextStyle(color: primaryColor),
                                )
                              ],
                            ),
                          ),
                        ]),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        child: Text(
                          'Địa điểm',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        width: 100.w,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 220, 222, 224),
                            borderRadius:
                                BorderRadius.all(Radius.circular(24))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Từ',
                                  style: TextStyle(color: secondaryTextColor),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 8),
                                  child: Row(
                                    children: [
                                      Image.asset(AppAssets.from_icon),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Text(fromBuildingName),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  'Đến',
                                  style: TextStyle(color: secondaryTextColor),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 8),
                                  child: Row(
                                    children: [
                                      Image.asset(AppAssets.to_icon),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Text(toBuildingName),
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                      ),
                      status == "Đang chuẩn bị"
                          ? Container(
                              margin: EdgeInsets.only(top: 16),
                              width: 100.w,
                              height: 52,
                              child: ElevatedButton(
                                style: elevatedButtonStyle,
                                child: Text('CHẤP NHẬN'),
                                onPressed: () async {
                                  var rs = await receiveOrder();
                                  if (rs) {
                                    Navigator.push(
                                        context,
                                        CustomerPageRoute(
                                            child: StatusOrderPage(status: 1),
                                            direction: AxisDirection.left));
                                  } else {
                                    AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.warning,
                                            
                                            animType: AnimType.topSlide,
                                            showCloseIcon: true,
                                            title: "Cảnh báo",
                                            btnOkColor: primaryColor,
                                            desc: 
                                                "   Bạn đang trong đơn hàng khác, không thể nhận đơn này   ",
                                            btnOkOnPress: () {})
                                        .show();
                                  }
                                },
                              ),
                            )
                          : Text(""),
                      status == "Đang chuẩn bị"
                          ? Container(
                              margin: EdgeInsets.only(top: 16),
                              width: 100.w,
                              height: 52,
                              child: TextButton(
                                style: ButtonStyle(
                                  side: MaterialStateProperty.all(
                                    BorderSide(
                                        width: 2,
                                        color: primaryColor,
                                        strokeAlign:
                                            BorderSide.strokeAlignInside),
                                  ),
                                ),
                                child: Text(
                                  'MÀN HÌNH CHÍNH',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                      fontSize: 18),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            )
                          : Text(""),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
