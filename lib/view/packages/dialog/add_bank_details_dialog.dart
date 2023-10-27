import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/progress_bar.dart';

class AddBankDetailsDialog extends StatefulWidget {
  AddBankDetailsDialog({Key? key, this.title, required this.description, required this.callback, this.titleStyle, this.descStyle}) : super(key: key);
  String? title;
  final String description;
  final Function(
    String name,
    String accountNumber,
    String routingNumber,
    String accountType,
    String bankName,
  )? callback;
  TextStyle? titleStyle;
  TextStyle? descStyle;
  @override
  State<AddBankDetailsDialog> createState() => _AddBankDetailsDialogState();
}

class _AddBankDetailsDialogState extends State<AddBankDetailsDialog> {
  TextEditingController accountName = TextEditingController();
  TextEditingController accountNumber = TextEditingController();
  TextEditingController routingNumber = TextEditingController();
  TextEditingController accountType = TextEditingController();
  TextEditingController bankName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
      child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 22, right: 22),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  SizedBox(
                    width: 20,
                  ),
                  Column(children: [
                    Center(
                      child: Text(
                        widget.title != null ? widget.title!.tr : 'Alert'.tr,
                        style: widget.titleStyle ?? TextStyle(fontSize: 16, color: Colors.redAccent),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                        alignment: Alignment.center,
                        child: Text(
                          widget.description.tr,
                          // 'Please allow location access to use the app.Your location is used to determine Travel and Meet Now mode connections'
                          //     .tr,
                          style: widget.descStyle ?? const TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        )),
                  ]),
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.close,
                      size: 20,
                    ),
                  )
                ]),
                const SizedBox(height: 25),
                TextField(
                  controller: accountName,
                  decoration: const InputDecoration(hintText: "Account holder name", border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: accountNumber,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: "Account number", border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: routingNumber,
                  decoration: const InputDecoration(hintText: "Routing number", border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: accountType,
                  decoration: InputDecoration(hintText: "Account type", border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: bankName,
                  decoration: InputDecoration(hintText: "Bank name", border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    if (checkValidation()) {
                      Navigator.pop(context);
                      if (widget.callback != null) {
                        widget.callback!(
                          accountName.text,
                          accountNumber.text,
                          routingNumber.text,
                          accountType.text,
                          bankName.text,
                        );
                      }
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    // width: Get.width / 2.9,
                    padding: EdgeInsets.only(top: Get.height * 0.019, bottom: Get.height * 0.019, left: Get.width * 0.04, right: Get.width * 0.04),
                    decoration: const BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Text(
                      "Submit and cancel order".tr,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  bool checkValidation() {
    if (accountName.text.isEmpty) {
      CommonDialog.showToastMessage("Please enter account name");

      return false;
    } else if (accountNumber.text.isEmpty) {
      CommonDialog.showToastMessage("Please enter account number");

      return false;
    } else if (routingNumber.text.isEmpty) {
      CommonDialog.showToastMessage("Please enter routing number");

      return false;
    } else if (accountType.text.isEmpty) {
      CommonDialog.showToastMessage("Please enter account type");

      return false;
    } else if (bankName.text.isEmpty) {
      CommonDialog.showToastMessage("Please enter bank name");

      return false;
    } else {
      return true;
    }
  }
}
