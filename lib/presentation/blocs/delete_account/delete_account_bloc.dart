import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/domain/usecases/delete_account_usecase.dart';
import 'package:hungrx_app/presentation/blocs/delete_account/delete_account_event.dart';
import 'package:hungrx_app/presentation/blocs/delete_account/delete_account_state.dart';

class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  final DeleteAccountUseCase _deleteAccountUseCase;

  DeleteAccountBloc({required DeleteAccountUseCase deleteAccountUseCase})
      : _deleteAccountUseCase = deleteAccountUseCase,
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
      emit(DeleteAccountSuccess(message: response.message));
    } catch (e) {
      emit(DeleteAccountFailure(error: e.toString()));
    }
  }
}