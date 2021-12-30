import 'package:canteenpro/controllers/item_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CheckoutPage extends StatelessWidget {
  final ItemController controller = Get.put(ItemController());
  final TextEditingController editqty = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFF545D68)),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text('Checkout',
              style: TextStyle(
                  fontFamily: 'Varela',
                  fontSize: 20.0,
                  color: Color(0xFF545D68))),
        ),
        body: Center(
          child: GetBuilder<ItemController>(
            init: ItemController(),
            initState: (_) {},
            builder: (controller) {
              return ListView.builder(
                  itemCount: controller.cartList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text("${controller.cartList[index]['item']}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                              onPressed: () {
                                Alert(
                                    context: context,
                                    title: "Quantity",
                                    content: Column(
                                      children: <Widget>[
                                        TextFormField(
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]'))
                                          ],
                                          autofocus: true,
                                          controller: editqty,
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
                                          controller.cartList[index]['qty'] =
                                              editqty.text;
                                          controller.update();
                                          Get.back();
                                        },
                                        child: Text(
                                          "Confirm",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      )
                                    ]).show();
                              },
                              child:
                                  Text("${controller.cartList[index]['qty']}")),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              controller.cartList.removeAt(index);
                              controller.update();
                            },
                          ),
                        ],
                      ),
                    );
                  });
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 6.0,
            color: Colors.transparent,
            elevation: 9.0,
            clipBehavior: Clip.antiAlias,
            child: GetBuilder<ItemController>(
              init: ItemController(),
              initState: (_) {},
              builder: (controller) {
                return InkWell(
                  onTap: () {
                    controller.checkout();
                    controller.update();
                  },
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(color: Colors.white),
                    child: Center(
                      child: Text('Proceed to Checkout',
                          style: TextStyle(
                              fontFamily: 'Varela',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF545D68))),
                    ),
                  ),
                );
              },
            )));
  }
}
