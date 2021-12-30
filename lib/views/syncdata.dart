import 'dart:convert';
import 'package:canteenpro/shared/globals.dart';
import 'package:canteenpro/shared/utils.dart';
import 'package:canteenpro/views/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class SyncData extends StatefulWidget {
  @override
  _SyncDataState createState() => _SyncDataState();
}

class _SyncDataState extends State<SyncData> {
  Box itembox;
  Box employeebox;
  List items = [];
  List employees = [];
  Future openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    itembox = await Hive.openBox('items');
    employeebox = await Hive.openBox('employees');
    return;
  }

  Future<bool> getAllData() async {
    await openBox();
    String itemUrl, employeeUrl;
    var _items, _employees;

    try {
      itemUrl = Global.server +
          '/resource/Food Item?fields=["name","subsidy_rate","type","item_image","selected_days"]&filters=[["status","=","Active"]]&limit_page_length=999';
      var itemResponse = await http.get(Uri.parse(itemUrl));
      _items = jsonDecode(itemResponse.body)['data'];

      employeeUrl = Global.server +
          '/resource/Employee?fields=["employee","employee_name","rfid"]&filters=[["status","=","Active"]]&limit_page_length=9999';
      var employeeResponse = await http.get(Uri.parse(employeeUrl));
      _employees = jsonDecode(employeeResponse.body)['data'];
      await putData(_items, _employees);
    } catch (SocketException) {
      print('No Internet');
    }

    //get the data from the DB
    var itemmap = itembox.toMap().values.toList();
    if (itemmap.isEmpty) {
      items.add('Empty');
    } else {
      items = itemmap;
    }

    var empmap = employeebox.toMap().values.toList();
    if (empmap.isEmpty) {
      employees.add('Empty');
    } else {
      employees = empmap;
    }

    return Future.value(true);
  }

  Future putData(items, employees) async {
    await itembox.clear();
    await employeebox.clear();
    //insert data
    for (var i in items) {
      itembox.add(i);
    }

    for (var e in employees) {
      employeebox.add(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sync with Server'),
      ),
      body: Center(
          child: FutureBuilder(
        future: getAllData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (items.contains('empty')) {
              return Text('No Data');
            } else {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      AppBar(
                        leading: Icon(Icons.dashboard),
                        elevation: 0,
                        title: Text('Server Data'),
                        backgroundColor: Colors.green,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Total Employees',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ],
                                ),
                                Text(
                                  "${employees.length}",
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Total Items',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ],
                                ),
                                Text(
                                  "${items.length}",
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(LoginPage());
                              },
                              child: Container(
                                height: 80,
                                // decoration: BoxDecoration(color: Colors.white),
                                child: Center(
                                  child: Text('Proceed',
                                      style: TextStyle(
                                          fontFamily: 'Varela',
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF545D68))),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ]),
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
