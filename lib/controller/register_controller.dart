import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../model/destination_model.dart';
import '../model/interests_model.dart';

class RegisterController extends GetxController {
  String? name;
  String? dob;
  String? email;
  String? countryCode;
  String? phoneNumber;
  String? password;
  String? gender;
  String? orientation;
  String? ethnicity;
  String? tripStyle;
  String? travelWithIn;
  List<Countries>? destinations = [];
  List<Interest>? interests = [];
  List<String> images = ['', '', '', '', '', '', '', '', ''];
  List<bool> backendImageCompress = [true,true,true,true,true,true,true,true,true];
  String? aboutMe;
  String? referralCode;
  int? genderVisible;
  int? sexualOrientationVisible;
  int? ethnicityVisible;

  //Social Signup purposes
  bool isSocialSignup = false;
  String? socialFirstName;
  String? socialLastName;
  String? socialEmail;
  String? socialImageUrl;
  String? socialType;
  String? socialToken;
}
