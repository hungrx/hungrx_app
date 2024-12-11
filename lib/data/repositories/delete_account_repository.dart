import 'package:hungrx_app/data/Models/delete_account_response.dart';
import 'package:hungrx_app/data/datasources/api/delete_account_api.dart';

class DeleteAccountRepository {
  final DeleteAccountApi _api;

  DeleteAccountRepository({DeleteAccountApi? api}) : _api = api ?? DeleteAccountApi();

  Future<DeleteAccountResponse> deleteAccount(String userId) async {
    try {
      final response = await _api.deleteAccount(userId);
      return DeleteAccountResponse.fromJson(response);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}
