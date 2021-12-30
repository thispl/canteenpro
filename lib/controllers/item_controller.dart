import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:canteenpro/controllers/login_controller.dart';
import 'package:canteenpro/shared/globals.dart';
import 'package:canteenpro/shared/utils.dart';
import 'package:canteenpro/views/login.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:device_info/device_info.dart';

class ItemController extends GetxController {
  final LoginController loginController = Get.put(LoginController());
  Box orderBox;

  Future openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    orderBox = await Hive.openBox('orders');
    return;
  }

  Future putData(orders) async {
    //insert data
    orderBox.add(orders);
  }

  List cartList = [].obs;
  List checkoutList = [];
  Map<String, String> checkoutItems = {};

  checkout() async {
    print(cartList);
    await openBox();
    cartList.forEach((item) {
      var qty = item['qty'].toString();
      if (item['qty'] == '') {
        qty = '1';
      }
      checkoutItems = {
        "employee": loginController.currentEmployeeId.value,
        "date": getCurrentDate(),
        "time": getCurrentTime(),
        "item": item['item'].toString(),
        "qty": qty,
      };
      checkoutList.add(checkoutItems);
    });
    var payload = jsonEncode(checkoutList);
    await putData(payload);

    Alert(
      context: Get.context,
      type: AlertType.success,
      title: "Thank You!!!",
      desc: "Bon Appetite",
      buttons: [
        DialogButton(
          child: Text(
            "Ok",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Get.offAll(LoginPage()),
          width: 120,
        )
      ],
    ).show();
  }

  pushOrderToServer() async {
    // Loader.hide();
    await openBox();
    //get the data from the DB
    // var ob = orderBox.toMap();
    // ob.forEach((index, orders) {
    //   String orderNo = '1234';
    //   List orderList = jsonDecode(orders);
    //   orderList.forEach((order) {
    //     order['order_no'] = orderNo;
    //   });
    //   orderNoList.add(orderList);
    // });
    var orderMap = orderBox.toMap().values.toList();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    try {
      String url = Global.server + '/method/cms.api.enqueue_cms_log';
      Map<String, String> requestHeaders = {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      final res = await http.post(Uri.parse(url),
          body: {'payloads': jsonEncode(orderMap), 'deviceid': androidInfo.id},
          headers: requestHeaders);
      if (res.statusCode == 200) {
        Loader.hide();
        var response = jsonDecode(res.body)['message'];
        if (response == 'OK') {
          orderBox.clear();
          Loader.hide();
          Alert(
            context: Get.context,
            type: AlertType.success,
            title: "Updated",
            desc: "Entries synced to server",
            buttons: [
              DialogButton(
                child: Text(
                  "Ok",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Get.offAll(LoginPage()),
                width: 120,
              )
            ],
          ).show();
        }
      }
    } catch (SocketException) {
      Alert(context: Get.context, title: 'No Internet Connection');
    }
  }

  getLatestOrderNo() async {
    try {
      String url = Global.server + '/method/cms.api.get_order_no';
      Map<String, String> requestHeaders = {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      };
      final res = await http.get(Uri.parse(url), headers: requestHeaders);
      if (res.statusCode == 200) {
        Loader.hide();
        var response = jsonDecode(res.body)['message'];
        print(response);
        // return response + 1;
      }
    } catch (SocketException) {
      Alert(context: Get.context, title: 'No Internet Connection');
    }
  }
}
