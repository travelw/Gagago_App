import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../CommonWidgets/common_back_button.dart';
import '../../constants/color_constants.dart';
import '../../constants/string_constants.dart';
import '../../utils/dimensions.dart';

class TermsConditions extends StatefulWidget {
  String? title;
  TermsConditions({Key? key,this.title}) : super(key: key);

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {



  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
            top: Get.height * 0.080,
            left: Get.width * 0.060,
            right: Get.width * 0.060,
            bottom: Get.height * 0.020),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CommonBackButton(
                name: '',
              ),
              SizedBox(
                height: Get.height * 0.04,
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title.toString(),style: TextStyle(fontSize: 25,color: AppColors.backTextColor,fontWeight: FontWeight.bold,fontFamily: StringConstants.poppinsBold),),
                     SizedBox(height: 10,),
                     Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.\n\nContrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.\n\nThe standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.',style: TextStyle(fontSize: 14,color: AppColors.backTextColor,fontFamily: StringConstants.poppinsRegular))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
