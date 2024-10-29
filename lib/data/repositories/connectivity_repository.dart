import 'package:hungrx_app/data/services/connectivity_service.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityRepository {
  final ConnectivityService _connectivityService;

  ConnectivityRepository({ConnectivityService? connectivityService})
      : _connectivityService =
            connectivityService ?? ConnectivityService();

  Future<bool> checkInternetConnection() async {
    return await _connectivityService.hasInternetConnection();
  }

  Stream<InternetConnectionStatus> get connectionStream =>
      _connectivityService.connectionStream;
}