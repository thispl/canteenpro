import 'package:canteenpro/controllers/item_controller.dart';
import 'package:canteenpro/views/login.dart';
import 'package:canteenpro/views/syncdata.dart';
import 'package:canteenpro/views/unsyncdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
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
        children: [
          ListTile(
            title: Text('Sync Items/Employees'),
            onTap: () {
              Get.to(SyncData());
            },
          ),
          GetBuilder<ItemController>(
            init: ItemController(),
            initState: (_) {},
            builder: (controller) {
              return ListTile(
                title: Text('Sync Food Entry'),
                onTap: () {
                  Loader.show(context,
                      progressIndicator: CircularProgressIndicator());
                  controller.pushOrderToServer();
                },
              );
            },
          ),
          ListTile(
            title: Text('Unsynced Items'),
            onTap: () {
              Get.to(UnsyncData());
            },
          ),
        ],
      ),
    );
  }
}
