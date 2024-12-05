import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/presentation/blocs/user_id_global/user_id_event.dart';
import 'package:hungrx_app/presentation/blocs/user_id_global/user_id_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const UserInitial()) {
    on<LoadUserId>(_onLoadUserId);
    on<UpdateUserId>(_onUpdateUserId);
    on<ClearUserId>(_onClearUserId);
  }

  Future<void> _onLoadUserId(LoadUserId event, Emitter<UserState> emit) async {
    // Load user_id from SharedPreferences or other storage
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    emit(UserLoaded(userId));
  }

  Future<void> _onUpdateUserId(UpdateUserId event, Emitter<UserState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    if (event.userId != null) {
      await prefs.setString('user_id', event.userId!);
    }
    emit(UserLoaded(event.userId));
  }

  Future<void> _onClearUserId(ClearUserId event, Emitter<UserState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    emit(const UserLoaded(null));
  }
}