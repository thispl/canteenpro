import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class LoginController extends GetxController {
  Box box;
  List employees = [].obs;
  var currentEmployeeName = ''.obs;
  var currentEmployeeId = ''.obs;
  var isEmployeeFound = false.obs;
  var idType = 'RFID Card'.obs;
  var qrEmployee = ''.obs;

  Future openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('employees');
    return;
  }

  Future<bool> checkEmployeeRFID(String rfid) async {
    currentEmployeeName.value = 'NA';
    await openBox();
    employees.clear();
    //get the data from the DB
    var empmap = box
        .toMap()
        .values
        .where((employee) => employee['rfid'] == rfid)
        .toList();
    if (empmap.isEmpty) {
      isEmployeeFound(false);
    } else {
      currentEmployeeName.value = empmap[0]['employee_name'];
      currentEmployeeId.value = empmap[0]['employee'];
      isEmployeeFound(true);
    }
    return isEmployeeFound.value;
  }

  Future<bool> checkEmployeeID(String empid) async {
    print("empid");
    currentEmployeeName.value = 'NA';
    await openBox();
    employees.clear();
    //get the data from the DB
    var empmap = box
        .toMap()
        .values
        .where((employee) => employee['employee'] == empid)
        .toList();
    if (empmap.isEmpty) {
      isEmployeeFound(false);
    } else {
      currentEmployeeName.value = empmap[0]['employee_name'];
      currentEmployeeId.value = empmap[0]['employee'];
      isEmployeeFound(true);
    }
    return isEmployeeFound.value;
  }
}
