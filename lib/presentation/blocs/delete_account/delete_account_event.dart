abstract class DeleteAccountEvent {}

class DeleteAccountRequested extends DeleteAccountEvent {
  // Removed userId parameter since it will be fetched from AuthService
  DeleteAccountRequested();
}