import 'package:connectivity_plus/connectivity_plus.dart';

final Connectivity _connectivity = Connectivity();
late ConnectivityResult result;

Future<ConnectivityResult> checkConnectivity() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  return connectivityResult;
}

Future<bool> isNetworkAvailable() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  } else {
    return false;
  }
}
