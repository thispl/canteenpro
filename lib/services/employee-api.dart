import 'dart:convert';
import 'package:canteenpro/shared/globals.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

Box box;
List data = [];

Future openBox() async {
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  box = await Hive.openBox('employees');
  return;
}

Future<bool> getAllData() async {
  await openBox();

  String url = Global.server +
      '/resource/Employee?fields=["employee","employee_name","rfid"]&filters=[["status","=","Active"]]&limit_page_length=999';
  try {
    var response = await http.get(Uri.parse(url));
    var _jsonDecode = jsonDecode(response.body)['data'];
    await putData(_jsonDecode);
  } catch (SocketException) {
    print('No Internet');
  }

  //get the data from the DB
  var mymap = box.toMap().values.toList();
  if (mymap.isEmpty) {
    data.add('Empty');
  } else {
    data = mymap;
  }
  return Future.value(true);
}

Future putData(data) async {
  await box.clear();
  //insert data
  for (var d in data) {
    box.add(d);
  }
}

Future<void> updateData() async {
  String url = Global.server +
      '/resource/Employee?fields=["employee","employee_name","rfid"]&filters=[["status","=","Active"]]&limit_page_length=999';
  try {
    var response = await http.get(Uri.parse(url));
    var _jsonDecode = jsonDecode(response.body)['data'];
    await putData(_jsonDecode);
  } catch (SocketException) {
    print('No Internet');
  }
}

Future<String> checkEmployee(String rfid) async {
  String currentEmployee = 'NA';
  await openBox();
  data.clear();
  //get the data from the DB
  var mymap = box.toMap().values.toList();
  if (mymap.isEmpty) {
    data.add('Empty');
  } else {
    data = mymap;
  }

  data.forEach((employee) {
    if (employee['rfid'] == rfid) {
      currentEmployee = employee['employee'];
      print(currentEmployee);
    }
  });
  print(currentEmployee);

  return currentEmployee;
}
