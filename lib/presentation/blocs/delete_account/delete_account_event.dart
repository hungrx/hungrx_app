abstract class DeleteAccountEvent {}

class DeleteAccountRequested extends DeleteAccountEvent {
  final String userId;

  DeleteAccountRequested({required this.userId});
}
