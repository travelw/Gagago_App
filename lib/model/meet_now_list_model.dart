import 'package:gagagonew/model/meet_now_model.dart';

class MeetNowListModel{
  String name="";
  List<MeetNowModel> categories=[];

  MeetNowListModel(String name,List<MeetNowModel> categories){
    this.name=name;
    this.categories=categories;
  }
}