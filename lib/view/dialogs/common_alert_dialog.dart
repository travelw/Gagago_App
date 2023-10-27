import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonAlertDialog extends StatelessWidget {
  CommonAlertDialog({
    Key? key,
    this.title,
    required this.description,
    required this.callback,
    this.titleStyle,
    this.descStyle

  }) : super(key: key);
  String? title;
  final String description;
  final Function? callback;
  TextStyle? titleStyle;
  TextStyle? descStyle;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)), //this right here
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 12, right: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                title != null ? title!.tr : 'Alert'.tr,
                style:titleStyle?? TextStyle(fontSize: 16, color: Colors.redAccent),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
                alignment: Alignment.center,
                child: Text(
                  description.tr,
                  // 'Please allow location access to use the app.Your location is used to determine Travel and Meet Now mode connections'
                  //     .tr,
                  style:descStyle?? const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
            const SizedBox(height: 30),
            const Divider(
              height: 1,
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (callback != null) {
                  callback!();
                }
              },
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "Ok".tr,
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
