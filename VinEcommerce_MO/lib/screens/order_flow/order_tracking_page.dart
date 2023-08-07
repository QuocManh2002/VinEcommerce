import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer2/sizer2.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:vin_ecommerce/data_access/order_repository.dart';
import 'package:vin_ecommerce/models/order_model.dart';
import 'package:vin_ecommerce/screens/order_flow/shipper_homepage.dart';
import 'package:vin_ecommerce/styles/app_assets.dart';
import '../../styles/color.dart';
import 'order_panel_widget.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({super.key});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  late GoogleMapController _controller;
  LatLng? store = null;
  LatLng? destination = null;
  String _status = "";
  final cron = Cron();
  OrderRepository orderRepo = OrderRepository();

  bool isLoading = true;
  double currentLat = 0;
  double currentLng = 0;
  LatLng currentLocation = LatLng(0, 0);
  CameraPosition _tracking = CameraPosition(target: LatLng(0, 0));

  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  List<Uint8List> listIcon = [];
  void loadIcon() async {
    listIcon.add(await getBytesFromAssets(AppAssets.shop, 100));
    listIcon.add(await getBytesFromAssets(AppAssets.apartment, 100));
    listIcon.add(await getBytesFromAssets(AppAssets.delivery, 100));
    isLoading = false;
  }

  void getCurrentLocation() async {
    Geolocator.requestPermission()
        .then((location) {})
        .onError((error, stackTrace) {
      print("error" + error.toString());
    });
    await Geolocator.getCurrentPosition().then((value) {
      currentLat = value.latitude;
      currentLng = value.longitude;
      CameraPosition tracking =
          CameraPosition(target: LatLng(currentLat, currentLng), zoom: 18);
      setState(() {
        currentLocation = LatLng(value.latitude, value.longitude);
        _tracking = tracking;
      });
    });
  }

  @override
  void initState() {
    getData();
    loadIcon();
    getCurrentLocation();
    scheduleTask();
    super.initState();
  }

  scheduleTask() {
    cron.schedule(Schedule.parse("* * * * *"), () async {
      reloadLocation();
    });
  }

  reloadLocation() async {
    await Geolocator.getCurrentPosition().then((value) {
      currentLat = value.latitude;
      currentLng = value.longitude;
      CameraPosition tracking =
          CameraPosition(target: LatLng(currentLat, currentLng), zoom: 18);
      setState(() {
        currentLocation = LatLng(value.latitude, value.longitude);
        _tracking = tracking;
        _controller.animateCamera(CameraUpdate.newCameraPosition(
            new CameraPosition(
                target: LatLng(currentLat, currentLng), zoom: 18)));
      });
    });
  }

  getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var orderId = pref.getString('onGoingOrder');
    Order order = await orderRepo.getOrderById(orderId.toString());
    var status = order.Status != null ? order.Status! : "";
    String fromLat = order.fromLat != null ? order.fromLat! : "";
    String fromLng = order.fromLng != null ? order.fromLng! : "";
    String toLat = order.toLat != null ? order.toLat! : "";
    String toLng = order.toLng != null ? order.toLng! : "";
    store = LatLng(
        double.parse(fromLat.toString()), double.parse(fromLng.toString()));
    destination =
        LatLng(double.parse(toLat.toString()), double.parse(toLng.toString()));
    isLoading = false;
    setState(() {
      _status = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Theo dõi đơn hàng',
          style: TextStyle(fontSize: 17, color: Colors.black),
        ),
        leading: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ShipperHomePage()),
              );
            },
            child: Image.asset(AppAssets.left_arrow)),
      ),
      body: SlidingUpPanel(
        parallaxEnabled: true,
        parallaxOffset: .5,
        minHeight: 20.h,
        maxHeight: 70.h,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        body: isLoading
            ? Center(child: Image.asset(AppAssets.loading_gif))
            : Stack(
                fit: StackFit.expand,
                children: [
                  GoogleMap(
                    initialCameraPosition: _tracking,
                    markers: {
                      Marker(
                          markerId: MarkerId("source"),
                          position: store != null
                              ? store!
                              : LatLng(10.838394211191604, 106.83183683942438),
                          icon: BitmapDescriptor.fromBytes(listIcon[0])),
                      Marker(
                          markerId: MarkerId("destination"),
                          position: destination != null
                              ? destination!
                              : LatLng(10.838394211191604, 106.83183683942438),
                          icon: BitmapDescriptor.fromBytes(listIcon[1])),
                      Marker(
                          markerId: MarkerId("current"),
                          position: LatLng(currentLat, currentLng),
                          icon: BitmapDescriptor.fromBytes(listIcon[2])),
                    },
                    onMapCreated: (GoogleMapController controller) {
                      _controller = controller;
                    },
                  ),
                ],
              ),
        panelBuilder: (controller) => OrderPanelWidget(
          controller: controller,
          status: _status,
          isHomePage: false,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {await Geolocator.getCurrentPosition().then((value) {
      currentLat = value.latitude;
      currentLng = value.longitude;
      CameraPosition tracking =
          CameraPosition(target: LatLng(currentLat, currentLng), zoom: 18);
      setState(() {
        currentLocation = LatLng(value.latitude, value.longitude);
        _tracking = tracking;
        _controller.animateCamera(CameraUpdate.newCameraPosition(
            new CameraPosition(
                target: LatLng(currentLat, currentLng), zoom: 18)));
      });
    });},
        child: Image.asset(AppAssets.gps),
        backgroundColor: primaryColor,
      ),
    ));
  }
}
