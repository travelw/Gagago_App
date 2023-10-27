import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gagagonew/utils/dimensions.dart';
import 'package:get/get.dart';
import '../constants/color_constants.dart';
import '../constants/string_constants.dart';

class CommonBackButton extends StatelessWidget {
  String name;
  String? click;

  CommonBackButton({Key? key, required this.name, this.click})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            //Get.back();
            //Get.toNamed(click);
            Navigator.pop(context, true);
          },
          child: SizedBox(
              width: Get.width * 0.090,
              child: SvgPicture.asset(
                "${StringConstants.svgPath}backIcon.svg",
                height: Get.height * 0.035,
              )),
        ),

        const SizedBox(
          width: 10,
        ),

        Expanded(
          child: Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: Dimensions.font20,
                color: AppColors.backTextColor,
                fontWeight: FontWeight.w600,
                fontFamily: StringConstants.poppinsRegular),
          ),
        ),

        SizedBox(
          width: Get.width * 0.095,
        )
        // Text(
        //   "  ",
        //   style: TextStyle(
        //       color: Colors.white,
        //       fontSize: Get.height*0.020),
        // ),
      ],
    );
  }
}
