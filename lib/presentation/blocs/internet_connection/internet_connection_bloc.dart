import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:hungrx_app/data/repositories/connectivity_repository.dart';
import 'package:hungrx_app/presentation/blocs/internet_connection/internet_connection_event.dart';
import 'package:hungrx_app/presentation/blocs/internet_connection/internet_connection_state.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final ConnectivityRepository _connectivityRepository;
  StreamSubscription? _connectivitySubscription;

  ConnectivityBloc({required ConnectivityRepository connectivityRepository})
      : _connectivityRepository = connectivityRepository,
        super(ConnectivityInitial()) {
    on<CheckConnectivity>(_onCheckConnectivity);
    on<ConnectivityStatusChanged>(_onConnectivityStatusChanged);

    // Subscribe to connectivity changes
    _connectivitySubscription =
        _connectivityRepository.connectionStream.listen((status) {
      add(ConnectivityStatusChanged(
          status == InternetConnectionStatus.connected));
    });
  }

  Future<void> _onCheckConnectivity(
      CheckConnectivity event, Emitter<ConnectivityState> emit) async {
    final hasConnection =
        await _connectivityRepository.checkInternetConnection();
    emit(hasConnection
        ? ConnectivityConnected()
        : ConnectivityDisconnected());
  }

  void _onConnectivityStatusChanged(
      ConnectivityStatusChanged event, Emitter<ConnectivityState> emit) {
    emit(event.isConnected
        ? ConnectivityConnected()
        : ConnectivityDisconnected());
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}