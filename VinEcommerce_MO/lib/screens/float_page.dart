import 'package:flutter/material.dart';
import 'package:vin_ecommerce/models/welcome.dart';
import 'package:vin_ecommerce/models/welcome_model.dart';
import 'package:vin_ecommerce/screens/sign_in_page.dart';
import 'package:vin_ecommerce/styles/color.dart';

class FloatPage extends StatefulWidget {
  const FloatPage({super.key});
  @override
  State<FloatPage> createState() => _FloatPageState();
}

class _FloatPageState extends State<FloatPage> {
  int currentIndex = 0;
  List<Welcome> welcomes = [];
  Welcomes wel = new Welcomes();
  
  getWelcomes(){
    setState(() {
      welcomes = wel.getAll();
  // welcomes.add(new  Welcome("All your favorites","Get all your loved items, just place the order we do the rest"));
  // welcomes.add(new  Welcome("Anytime, anywhere","Order anything you want from your home with just one click"));
  // welcomes.add(new  Welcome("Order from choosen Store","All merchandises or foods are provided from the most quality stores "));
  // welcomes.add(new  Welcome("Free delivery offers","You don’t have to worry about the fees come up with orders"));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWelcomes();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(children: [
          Container(
            margin: EdgeInsets.only(top: (size.height * 1 / 6)),
            height: size.height * 2 / 3,
            child: PageView.builder(onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            }, 
            itemCount: 4 ,
            itemBuilder: (context, index) {
              
              return Container(
                decoration: BoxDecoration(),
                child: Column(children: [
                  Container(
                    height: size.height * 2 / 5,
                    width: size.width * 2 / 3,
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(24))),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 50),
                    child: Text(
                      welcomes[index].title,
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    margin: const EdgeInsets.only(top: 35),
                    child: Text(
                      welcomes[index].detail,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Color(0xFF646982)),
                    ),
                  )
                ]),
              );
            }),
          ),
          Container(
            height: 12,
            margin: const EdgeInsets.only(left: 46),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return buildIndicator(index == currentIndex, size);
                }),
          ),

          Container(
            margin: const EdgeInsets.only(top: 40),
            width: size.width * 2 / 3,
            child: InkWell(
              onTap: (){
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => SignInPage()), (route) => false);
              },
              child: Container(
                width: double.infinity,
                
                padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14
                ),
                
                decoration: BoxDecoration(
                  color: primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      offset: Offset(3,6),
                      blurRadius: 6
                    )
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),

                child: Text(
                  'SKIP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )

        ]),
      ),
    );
  }

  Widget buildIndicator(bool isActive, Size size) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceInOut,
      margin: const EdgeInsets.only(left: 32),
      width: isActive ? size.width * 1 / 5 : 24,
      decoration: BoxDecoration(
          color: isActive ? Colors.orange : Color(0xFFFFE1CE),
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
                color: Colors.black38, offset: Offset(2, 3), blurRadius: 3)
          ]),
    );
  }
}
