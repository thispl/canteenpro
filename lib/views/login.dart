import 'package:canteenpro/controllers/login_controller.dart';
import 'package:canteenpro/views/home.dart';
import 'package:canteenpro/views/qrscanner.dart';
import 'package:canteenpro/views/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:input_with_keyboard_control/input_with_keyboard_control.dart';

class LoginPage extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());
  final TextEditingController rfid = TextEditingController();
  final TextEditingController empid = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('canteenPRO'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Get.to(SettingsPage()),
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => Alert(
              context: Get.context,
              type: AlertType.success,
              title: "Exit",
              desc: "Are you sure to Exit?",
              buttons: [
                DialogButton(
                  child: Text(
                    "Yes",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => SystemNavigator.pop(),
                  width: 120,
                )
              ],
            ).show(),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 230,
                  width: 450,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    color: Colors.blue,
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        child:
                            SvgPicture.asset("assets/svg/ellipse_top_pink.svg"),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: SvgPicture.asset(
                            "assets/svg/ellipse_bottom_pink.svg"),
                      ),
                      Positioned(
                        left: 140,
                        top: 60,
                        child: Image.asset(
                          "assets/tpl_logo.png",
                          width: 100,
                          height: 100,
                        ),
                      ),
                      Positioned(
                        right: 19,
                        top: 15,
                        child: Text(
                          'TAMILNADU PETROPRODUCTS LIMITED',
                          style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ),
                      Positioned(
                        left: 19,
                        bottom: 15,
                        child: Text(
                          'CANTEENPRO',
                          style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'WELCOME',
                        style: TextStyle(fontSize: 22),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Canteen Management System',
                        style: TextStyle(fontSize: 22),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GetBuilder<LoginController>(
                        init: LoginController(),
                        initState: (_) {},
                        builder: (loginController) {
                          String idType = loginController.idType.value;
                          if (idType == 'RFID Card') {
                            return GetRFID(controller: controller, rfid: rfid);
                          }
                          // else if (idType == 'Employee ID') {
                          //   return GetEmployeeID(
                          //       controller: controller, empid: empid);
                          // }
                          else {
                            return GetQRID(
                                controller: controller, empid: empid);
                          }
                        },
                      ),
                      GetBuilder<LoginController>(
                        init: LoginController(),
                        initState: (_) {},
                        builder: (loginController) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.all(8),
                                child: ElevatedButton(
                                  onPressed: () {
                                    loginController.idType.value = 'RFID Card';
                                    loginController.update();
                                  },
                                  child: Text('RFID',
                                      style: TextStyle(fontSize: 14)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(8),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => GetQRScan(),
                                    ));
                                  },
                                  child: Text('Scan QR',
                                      style: TextStyle(fontSize: 14)),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GetQRID extends StatelessWidget {
  const GetQRID({
    Key key,
    @required this.controller,
    @required this.empid,
  }) : super(key: key);

  final LoginController controller;
  final TextEditingController empid;

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'To Proceed Ordering, Enter your Employee ID',
            style: TextStyle(color: Colors.black.withOpacity(0.6)),
          ),
        ),
        InputWithKeyboardControl(
          focusNode: InputWithKeyboardControlFocusNode(),
          onSubmitted: (value) {
            controller.checkEmployeeID(value).then((isEmployeeFound) {
              isEmployeeFound
                  ? Get.to(HomePage())
                  : Alert(
                      context: context,
                      type: AlertType.error,
                      title: "Employee Not Found",
                      desc: "Contact Administrator",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "Ok",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                          width: 120,
                        )
                      ],
                    ).show();
            });
            controller.update();
          },
          autofocus: true,
          controller: empid,
          width: 300,
          startShowKeyboard: false,
          buttonColorEnabled: Colors.blue,
          buttonColorDisabled: Colors.black,
          underlineColor: Colors.black,
          showUnderline: true,
          showButton: true,
        )
      ],
    );
  }
}

class GetRFID extends StatelessWidget {
  const GetRFID({
    Key key,
    @required this.controller,
    @required this.rfid,
  }) : super(key: key);

  final LoginController controller;
  final TextEditingController rfid;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'To Proceed Ordering, Show your ID Card near the reader',
            style: TextStyle(color: Colors.black.withOpacity(0.6)),
          ),
        ),
        InputWithKeyboardControl(
          focusNode: InputWithKeyboardControlFocusNode(),
          onSubmitted: (value) {
            controller.checkEmployeeRFID(value).then((isEmployeeFound) {
              isEmployeeFound
                  ? Get.to(HomePage())
                  : Alert(
                      context: context,
                      type: AlertType.error,
                      title: "Employee Not Found",
                      desc: "Contact Administrator",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "Ok",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                          width: 120,
                        )
                      ],
                    ).show();
            });
            controller.update();
          },
          autofocus: true,
          controller: rfid,
          width: 300,
          startShowKeyboard: false,
          buttonColorEnabled: Colors.blue,
          buttonColorDisabled: Colors.black,
          underlineColor: Colors.black,
          showUnderline: true,
          showButton: true,
        )
      ],
    );
  }
}

class GetEmployeeID extends StatelessWidget {
  const GetEmployeeID({
    Key key,
    @required this.controller,
    @required this.empid,
  }) : super(key: key);

  final LoginController controller;
  final TextEditingController empid;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'To Proceed Ordering, Enter your Employee ID',
            style: TextStyle(color: Colors.black.withOpacity(0.6)),
          ),
        ),
        TextFormField(
          onFieldSubmitted: (value) {
            controller.checkEmployeeID(value).then((isEmployeeFound) {
              isEmployeeFound
                  ? Get.to(HomePage())
                  : Alert(
                      context: context,
                      type: AlertType.error,
                      title: "Employee Not Found",
                      desc: "Contact Administrator",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "Ok",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                          width: 120,
                        )
                      ],
                    ).show();
            });
            controller.update();
          },
          controller: empid,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
          ],
        )
      ],
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
