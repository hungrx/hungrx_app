abstract class DeleteAccountState {}

class DeleteAccountInitial extends DeleteAccountState {}

class DeleteAccountLoading extends DeleteAccountState {}

class DeleteAccountSuccess extends DeleteAccountState {
  final String message;

  DeleteAccountSuccess({required this.message});
}

class DeleteAccountFailure extends DeleteAccountState {
  final String error;

  DeleteAccountFailure({required this.error});
}