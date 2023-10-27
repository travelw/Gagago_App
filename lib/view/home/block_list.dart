import 'package:flutter/material.dart';
import 'package:gagagonew/CommonWidgets/common_back_button.dart';
import 'package:gagagonew/CommonWidgets/common_no_block_user_found.dart';
import 'package:gagagonew/Service/call_service.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:gagagonew/constants/string_constants.dart';
import 'package:gagagonew/model/block_list_response_model.dart';
import 'package:gagagonew/model/unblock_response_model.dart';
import 'package:gagagonew/utils/progress_bar.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlockUserListScreen extends StatefulWidget {
  const BlockUserListScreen({Key? key}) : super(key: key);

  @override
  State<BlockUserListScreen> createState() => _BlockUserListScreenPageState();
}

class _BlockUserListScreenPageState extends State<BlockUserListScreen> {
  bool isLoading = false;
  List<Data> blockUserData = [];
  List<BlockPersonDetail> blockUserList = [];
  String accessToken = "", userName = "", userId = "";

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      BlockListResponseModel model = await CallService().getBlockUserList();
      setState(() {
        isLoading = false;
        blockUserData = model.data!;
        debugPrint("blockUserData $blockUserData");
      });
    });
  }

  updateList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userFName = prefs.getString('userFirstName')!;
    String userLName = prefs.getString('userLastName')!;
    userId = prefs.getString('userId')!;
    userName = "$userFName $userLName";
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      BlockListResponseModel model = await CallService().getBlockUserList();
      setState(() {
        blockUserData = model.data!;
        debugPrint("blockUserData $blockUserData");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: Get.width * 0.14, right: Get.width * 0.050, left: Get.width * 0.050, bottom: Get.height * 0.010),
            child: Column(
              children: [
                CommonBackButton(
                  name: "Blocked Users".tr,
                ),
                SizedBox(
                  height: Get.height * 0.030,
                ),
                isLoading == true
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: Colors.transparent,
                      ))
                    : blockUserData.isNotEmpty
                        ? Expanded(
                            child: MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: blockUserData.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Padding(
                                                  //this padding will be you border size
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: Container(
                                                    height: 50,
                                                    width: 50,
                                                    padding: const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: AppColors.inputFieldBorderColor, width: 1),
                                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                      color: Colors.white,
                                                    ),
                                                    child: CircleAvatar(
                                                        radius: 18,
                                                        backgroundColor: Colors.white,
                                                        backgroundImage: blockUserData[index].blockPersonDetail == null
                                                            ? Image.asset(
                                                                'assets/images/png/dummypic.png',
                                                              ).image
                                                            : blockUserData[index].blockPersonDetail?.userProfile == null
                                                                ? Image.asset(
                                                                    'assets/images/png/dummypic.png',
                                                                  ).image
                                                                : NetworkImage(blockUserData[index].blockPersonDetail!.userProfile!.isEmpty
                                                                    ? ''
                                                                    : blockUserData[index].blockPersonDetail?.userProfile?[0].imageName.toString() ?? "")),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: Get.width * 0.015,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              blockUserData[index].blockPersonDetail == null
                                                                  ? ""
                                                                  : "${blockUserData[index].blockPersonDetail?.firstName ?? ""} ${blockUserData[index].blockPersonDetail?.lastName ?? ""}",
                                                              /*connectionList[index].name,*/
                                                              style: TextStyle(
                                                                  fontSize: Get.height * 0.020,
                                                                  fontWeight: FontWeight.w600,
                                                                  color: AppColors.gagagoLogoColor,
                                                                  fontFamily: StringConstants.poppinsRegular),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: Get.width * 0.010,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            // height: 30,
                                            padding: const EdgeInsets.symmetric(vertical: 5),

                                            child: TextButton(
                                              onPressed: () {
                                                String id = blockUserData[index].blockedTo.toString();
                                                String userName = blockUserData[index].blockPersonDetail!.firstName?.toString() ?? "";

                                                if (blockUserData[index].blockPersonDetail?.lastName != null) {
                                                  if (blockUserData[index].blockPersonDetail?.lastName?.toString() == null) {
                                                    userName = "$userName ${blockUserData[index].blockPersonDetail?.lastName?.trim()}";
                                                  }
                                                }

                                                debugPrint("userName $userName    -?????????? ${blockUserData[index].blockPersonDetail!.firstName!}");
                                                showAlertDialog(context, id, userName);
                                              },
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                              ),
                                              child: Text(
                                                'Unblock'.tr,
                                                style: TextStyle(fontSize: Get.height * 0.015, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: StringConstants.poppinsRegular),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: Get.height * 0.010,
                                      )
                                    ],
                                  );
                                },
                              ),
                            ),
                          )
                        : Expanded(
                            child: Padding(
                            padding: EdgeInsets.only(bottom: Get.height * 0.10),
                            child: const NoBlockUserFoundScreen(),
                          )),
              ],
            ),
          ),
          /*  Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(top: Get.height * 0.010),
              child: SvgPicture.asset(
                StringConstants.svgPath + "bottomLogin.svg",
                height: Get.height * 0.070,
              ),
            ),
          ),*/
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context, String id, String userName) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel".tr),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
        child: Text("Yes".tr),
        onPressed: () async {
          Get.back();
          debugPrint("My User Id $userId");
          var map = <String, dynamic>{};
          // map['blocked_by'] = userId;
          map['blocked_to'] = id;
          UnBlockResponseModel userBlock = await CallService().unBlockUser(map);
          if (userBlock.success! == true) {
            updateList().then((value) {
              CommonDialog.showToastMessage("$userName${" has been unblocked".tr}");
            });
          } else {
            CommonDialog.showToastMessage(userBlock.message.toString());
          }

          /*UserLogOutResponseModel stateUpdate =
          await CallService().getUerLogOut(map);
          if (stateUpdate.success == true) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.clear();
            Navigator.pop(context);
            Get.offAllNamed(RouteHelper.getLoginPage());
            //Navigator.pop(context);
          } else {
            CommonDialog.showToastMessage(
                stateUpdate.message.toString());
          }*/
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        "Alert".tr,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
      content: Text(
        "${"Do you want to unblock ".tr}$userName?",
        style: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
