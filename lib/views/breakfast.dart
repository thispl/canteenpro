import 'package:canteenpro/controllers/item_controller.dart';
import 'package:canteenpro/services/item-api.dart';
import 'package:canteenpro/shared/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:intl/intl.dart';

class BreakfastPage extends StatelessWidget {
  final TextEditingController qty = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCFAF8),
      body: Center(
          child: FutureBuilder(
        future: getAllData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (data.contains('empty')) {
              return Text('No Data');
            } else {
              List bfdata = [];
              data.forEach((item) {
                var today = DateFormat('EEEE').format(DateTime.now());
                if (item['selected_days'] != null) {
                  if (item['type'] == 'Breakfast' &&
                      item['selected_days'].contains(today)) {
                    bfdata.add(item);
                  }
                }
              });
              return Column(
                children: [
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.only(right: 15.0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: StaggeredGridView.countBuilder(
                        crossAxisCount: 2,
                        itemCount: bfdata.length,
                        itemBuilder: (context, index) {
                          return _buildCard(
                              bfdata[index]['name'],
                              bfdata[index]['subsidy_rate'].toString(),
                              bfdata[index]['item_image'].toString(),
                              false,
                              context);
                        },
                        staggeredTileBuilder: (index) => StaggeredTile.fit(1)),
                  ))
                ],
              );
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      )),
    );
  }

  Widget _buildCard(
      String name, String price, String imgPath, bool added, context) {
    return Padding(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
        child: GetBuilder<ItemController>(
          init: ItemController(),
          initState: (_) {},
          builder: (controller) {
            return GestureDetector(
              onTap: () {
                Alert(
                    context: context,
                    title: "Quantity",
                    content: Column(
                      children: <Widget>[
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                          ],
                          autofocus: true,
                          controller: qty,
                          decoration: InputDecoration(
                            icon: Icon(Icons.account_circle),
                            labelText: 'Enter Quantity',
                          ),
                        ),
                      ],
                    ),
                    buttons: [
                      DialogButton(
                        onPressed: () {
                          controller.cartList
                              .add({'item': name, 'qty': qty.text});
                          controller.update();
                          Get.back();
                        },
                        child: Text(
                          "Confirm",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      )
                    ]).show();
              },
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 3.0,
                            blurRadius: 5.0)
                      ],
                      color: Colors.white),
                  child: Column(children: [
                    Container(
                        height: 120.0,
                        width: 90.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imgPath.contains('files')
                                    ? CachedNetworkImageProvider(
                                        Global.baseUrl + imgPath)
                                    : AssetImage('assets/generic_food.jpg'),
                                fit: BoxFit.cover))),
                    Text(name,
                        style: TextStyle(
                            color: Color(0xFF575E67),
                            fontFamily: 'Varela',
                            fontSize: 14.0)),
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child:
                            Container(color: Color(0xFFEBEBEB), height: 1.0)),
                  ])),
            );
          },
        ));
  }
}
