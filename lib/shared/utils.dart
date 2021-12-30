import 'package:form_field_validator/form_field_validator.dart';

final requiredValidator =
    RequiredValidator(errorText: 'this field is required');

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

getCurrentDate() {
  var date = new DateTime.now().toString();

  var dateParse = DateTime.parse(date);

  var formattedDate = "${dateParse.year}-${dateParse.month}-${dateParse.day}";

  return formattedDate.toString();
}

getCurrentTime() {
  var date = new DateTime.now().toString();

  var timeParse = DateTime.parse(date);

  var formattedTime =
      "${timeParse.hour}:${timeParse.minute}:${timeParse.second}";

  return formattedTime.toString();
}
