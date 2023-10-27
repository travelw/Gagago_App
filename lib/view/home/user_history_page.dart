import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:gagagonew/model/notification_response_model.dart';
import 'package:gagagonew/service/call_service.dart';
import 'package:gagagonew/utils/dimensions.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import '../../CommonWidgets/common_back_button.dart';
import '../../CommonWidgets/common_no_notification_found.dart';
import '../../constants/string_constants.dart';

class UserHistoryScreen extends StatefulWidget {
  const UserHistoryScreen({Key? key}) : super(key: key);

  @override
  State<UserHistoryScreen> createState() => _UserHistoryScreenState();
}

class _UserHistoryScreenState extends State<UserHistoryScreen> {
  bool isLoading = false;
  List<String> notificationsList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //init();
  }

 /* init() async {
    isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      NotificationResponseModel responseModel =
          await CallService().getNotificationsList();
      setState(() {
        isLoading = false;
        notificationsList = responseModel.data!;
        print("NotificationsList $notificationsList");
      });
    });
  }*/

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonBackButton(
                name: 'History',
              ),
              SizedBox(
                height: Get.height * 0.04,
              ),
              Text(
                "Today",
                overflow: TextOverflow.visible,
                  style: TextStyle(fontSize: Dimensions.font20,color: AppColors.backTextColor,fontWeight: FontWeight.w600,fontFamily: StringConstants.poppinsRegular),
              ),
              MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                removeLeft: true,
                removeRight: true,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  // itemCount: notificationsList.length,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(top: Get.height * 0.015),
                      child: GestureDetector(
                        onTap: () {},
                        child: Card(
                          color: AppColors.historyColor,
                          elevation: 3,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Container(
                                        margin: EdgeInsets.only(left: 5),
                                        child: /*Text(notificationsList[index].message!,
                                                overflow: TextOverflow.visible,
                                                style: new TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontSize: Get.height * 0.018,
                                                  fontFamily: StringConstants
                                                      .poppinsRegular,
                                                ),
                                              ),*/
                                        Text(
                                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit.Qui s que erat lorem",
                                          overflow: TextOverflow.visible,
                                          style: new TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                            fontSize: Get.height * 0.018,
                                            fontFamily:
                                                StringConstants.poppinsRegular,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 4.0),
                                      child: SvgPicture.asset(StringConstants.svgPath +
                                          "timeimage.svg"),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 4.0,top: 4.0),
                                      child: Text(
                                        '2:59 PM',
                                        overflow: TextOverflow.visible,
                                        style: new TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.grayColorNormal,
                                          fontSize: Get.height * 0.015,
                                          fontFamily:
                                              StringConstants.poppinsRegular,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                                /*Text(
                                        Jiffy(notificationsList[index].createdAt.toString()).fromNow(),
                                        */ /*'2 mins ago',*/ /*
                                        overflow: TextOverflow.visible,
                                        style: new TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.grayColorNormal,
                                          fontSize: Get.height * 0.018,
                                          fontFamily:
                                              StringConstants.poppinsRegular,
                                        ),
                                      )*/
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
