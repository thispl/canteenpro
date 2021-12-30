import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

Box box;
List data = [];

Future openBox() async {
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  box = await Hive.openBox('items');
  return;
}

Future<bool> getAllData() async {
  await openBox();
  //get the data from the DB
  var mymap = box.toMap().values.toList();
  if (mymap.isEmpty) {
    data.add('Empty');
  } else {
    data = mymap;
  }
  return Future.value(true);
}
