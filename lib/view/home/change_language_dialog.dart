
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeLanguageDialog extends StatefulWidget {
  final Function(int) callBack;

  const ChangeLanguageDialog({Key? key, required this.callBack}) : super(key: key);

  @override
  State<ChangeLanguageDialog> createState() => _ChangeLanguageDialogState();
}

class _ChangeLanguageDialogState extends State<ChangeLanguageDialog> {
  SharedPreferences? prefs;

  int value = 0;
  List<LanguageModel> languageList = [
    LanguageModel(false, "English".tr, 1),
    LanguageModel(false, "Portuguese".tr, 4),
    LanguageModel(false, "French".tr, 7),
    LanguageModel(false, "Spanish".tr, 2),
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    prefs = await SharedPreferences.getInstance();

    int currentLangId = prefs!.getInt("language_id") ?? 1;
    debugPrint("currentLangId $currentLangId");

    for (int i = 0; i < languageList.length; i++) {
      if (languageList[i].id == currentLangId) {
        languageList[i].isSelected = true;
        value = i;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:  Text("Choose Language".tr),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey, // Background color
                    ),
                    child:  Text('Cancel'.tr),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: SizedBox(
                    child: ElevatedButton(
                  child:  Text('Save'.tr),
                  onPressed: () {
                    widget.callBack(languageList[value].id!);
                  },
                )),
              ),
            ],
          ),
        )
      ],
      content: StatefulBuilder(builder: (BuildContext context, StateSetter setState1) {
        return SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Divider(),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: languageList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return RadioListTile(
                        title: Text(languageList[index].title),
                        value: index,
                        // groupValue: languageList[index].isSelected,
                        // groupValue: languageList[index],
                        groupValue: value,
                        onChanged: (ind) {
                          setState(() => value = ind!);
                          for (int i = 0; i < languageList.length; i++) {
                            languageList[i].isSelected = false;
                          }
                          setState1(() {
                            languageList[ind!].isSelected = true;
                          });
                        },
                        // onChanged: (value) {
                        //   debugPrint("oon change press");
                        //   for (int i = 0; i < languageList!.length; i++) {
                        //     languageList[i].isSelected = false;
                        //   }
                        //   setState1(() {
                        //     languageList[index].isSelected = true;
                        //   });
                        //   debugPrint("languageList[index].isSelected ${languageList[index].isSelected}");
                        // });
                      );
                    }),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class LanguageModel {
  bool? isSelected;
  String title;
  int? id;

  LanguageModel(this.isSelected, this.title, this.id);
}
