import 'package:hungrx_app/data/Models/delete_account_response.dart';
import 'package:hungrx_app/data/repositories/delete_account_repository.dart';

class DeleteAccountUseCase {
  final DeleteAccountRepository _repository;

  DeleteAccountUseCase({required DeleteAccountRepository repository})
      : _repository = repository;

  Future<DeleteAccountResponse> execute(String userId) async {
    try {
      return await _repository.deleteAccount(userId);
    } catch (e) {
      throw Exception('UseCase error: $e');
    }
  }
}