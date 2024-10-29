import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityService {
  final InternetConnectionChecker connectionChecker;

  ConnectivityService({InternetConnectionChecker? checker})
      : connectionChecker = checker ?? InternetConnectionChecker();

  Future<bool> hasInternetConnection() async {
    return await connectionChecker.hasConnection;
  }

  Stream<InternetConnectionStatus> get connectionStream =>
      connectionChecker.onStatusChange;
}