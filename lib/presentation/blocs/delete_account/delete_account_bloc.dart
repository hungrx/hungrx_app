import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/domain/usecases/profile_screen/delete_account_usecase.dart';
import 'package:hungrx_app/presentation/blocs/delete_account/delete_account_event.dart';
import 'package:hungrx_app/presentation/blocs/delete_account/delete_account_state.dart';


class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  final DeleteAccountUseCase _deleteAccountUseCase;
  final AuthService _authService;

  DeleteAccountBloc({
    required DeleteAccountUseCase deleteAccountUseCase,
    required AuthService authService,
  })  : _deleteAccountUseCase = deleteAccountUseCase,
        _authService = authService,
        super(DeleteAccountInitial()) {
    on<DeleteAccountRequested>(_onDeleteAccountRequested);
  }

  Future<void> _onDeleteAccountRequested(
    DeleteAccountRequested event,
    Emitter<DeleteAccountState> emit,
  ) async {
    emit(DeleteAccountLoading());

    try {
      final response = await _deleteAccountUseCase.execute(event.userId);
      if (response.status == true) {
        // Use AuthService's logout method which properly clears all data
        await _authService.logout();
        emit(DeleteAccountSuccess(message: response.message));
      }
    } catch (e) {
      emit(DeleteAccountFailure(error: e.toString()));
    }
  }
}