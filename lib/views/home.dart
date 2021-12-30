import 'package:canteenpro/controllers/item_controller.dart';
import 'package:canteenpro/controllers/login_controller.dart';
import 'package:canteenpro/models/item.dart';
import 'package:canteenpro/views/breakfast.dart';
import 'package:canteenpro/views/checkout.dart';
import 'package:canteenpro/views/dinner.dart';
import 'package:canteenpro/views/login.dart';
import 'package:canteenpro/views/lunch.dart';
import 'package:canteenpro/views/snacks.dart';
import 'package:canteenpro/views/supper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Item> cartList = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF545D68)),
          onPressed: () {
            Get.to(LoginPage());
          },
        ),
        title: Text('CanteenPRO',
            style: TextStyle(
                fontFamily: 'Varela',
                fontSize: 20.0,
                color: Color(0xFF545D68))),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home, color: Color(0xFF545D68)),
            onPressed: () {
              Get.to(LoginPage());
            },
          ),
        ],
      ),
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(left: 20.0),
        children: <Widget>[
          SizedBox(height: 15.0),
          GetBuilder<LoginController>(
            init: LoginController(),
            initState: (_) {},
            builder: (controller) {
              return Text('Welcome !! ${controller.currentEmployeeName.value}',
                  style: TextStyle(
                      fontFamily: 'Varela',
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold));
            },
          ),
          SizedBox(height: 15.0),
          TabBar(
              controller: _tabController,
              indicatorColor: Colors.transparent,
              labelColor: Color(0xFFC88D67),
              isScrollable: true,
              labelPadding: EdgeInsets.only(right: 45.0),
              unselectedLabelColor: Color(0xFFCDCDCD),
              tabs: [
                Tab(
                  child: Text('Breakfast',
                      style: TextStyle(
                        fontFamily: 'Varela',
                        fontSize: 21.0,
                      )),
                ),
                Tab(
                  child: Text('Lunch',
                      style: TextStyle(
                        fontFamily: 'Varela',
                        fontSize: 21.0,
                      )),
                ),
                Tab(
                  child: Text('Dinner',
                      style: TextStyle(
                        fontFamily: 'Varela',
                        fontSize: 21.0,
                      )),
                ),
                Tab(
                  child: Text('Snacks',
                      style: TextStyle(
                        fontFamily: 'Varela',
                        fontSize: 21.0,
                      )),
                ),
                Tab(
                  child: Text('Supper',
                      style: TextStyle(
                        fontFamily: 'Varela',
                        fontSize: 21.0,
                      )),
                )
              ]),
          Container(
              height: MediaQuery.of(context).size.height - 50.0,
              width: double.infinity,
              child: TabBarView(controller: _tabController, children: [
                BreakfastPage(),
                LunchPage(),
                DinnerPage(),
                SnacksPage(),
                SupperPage()
              ]))
        ],
      ),
      floatingActionButton: GetBuilder<ItemController>(
        init: ItemController(),
        initState: (_) {},
        builder: (controller) {
          return FloatingActionButton(
            onPressed: () {
              Get.to(CheckoutPage());
            },
            backgroundColor: Color(0xFFF17532),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.shopping_cart_outlined),
                  Text(
                    '${controller.cartList.length}',
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
