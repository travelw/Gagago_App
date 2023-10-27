

import 'dart:io';

class SubscriptionService{

  static List<String> productLists = Platform.isIOS? [
    'com.gagago.gagagonew.onemonth',
    'com.gagago.gagagonew.sixmonths',
    'com.gagago.gagagonew.twelvemonths'
  ]:['plan_1',
    'plan_2',
    'plan_3'];
}