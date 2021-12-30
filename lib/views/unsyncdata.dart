import 'dart:convert';
import 'package:canteenpro/shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import "package:collection/collection.dart";

class UnsyncData extends StatefulWidget {
  @override
  _SyncDataState createState() => _SyncDataState();
}

class _SyncDataState extends State<UnsyncData> {
  List unsyncedOrders = [];
  List orders = [];
  List itemList = [];
  Box orderBox;

  Future openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    orderBox = await Hive.openBox('orders');
    return;
  }

  Future<bool> getAllData() async {
    await openBox();
    orders.clear();
    itemList.clear();
    //get the data from the DB
    var orderMap = orderBox.toMap().values.toList();
    if (orderMap.isEmpty) {
      unsyncedOrders = [];
    } else {
      unsyncedOrders = orderMap;
    }
    for (var emporder in unsyncedOrders) {
      var employeeOrder = jsonDecode(emporder);
      for (var order in employeeOrder) {
        orders.add(order);
      }
    }
    // print(orders);
    Map groupbyItem = groupBy(orders, (obj) => obj['item']);
    Map groupedAndSum = Map();
    groupbyItem.forEach((k, v) {
      groupedAndSum[k] = {
        'sumOfItem':
            v.fold(0, (prev, element) => prev + int.parse(element['qty'])),
      };
    });
    // print(orders);
    groupedAndSum.forEach((key, value) {
      itemList.add({"item": key, "qty": value['sumOfItem']});
    });
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unsynced Orders List'),
      ),
      body: Center(
          child: FutureBuilder(
        future: getAllData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (unsyncedOrders.contains('empty')) {
              return Center(child: Text('No Data'));
            } else {
              return ListView.builder(
                itemCount: itemList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(itemList[index]['item']),
                    // subtitle: Text(
                    //     orders[index]['date'] + ' ' + orders[index]['time']),
                    trailing: Text(itemList[index]['qty'].toString()),
                  );
                },
              );
            }
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 5,
                  ),
                  Text('Syncing Data from the Server'),
                  SizedBox(
                    height: 5,
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {});
                      },
                      child: Text('Retry'))
                ],
              ),
            );
          }
        },
      )),
    );
  }
}
