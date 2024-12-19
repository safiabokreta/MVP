import 'package:zefeffete/data/models/account_model.dart';
import 'package:zefeffete/domain/repositories/account_rep.dart';

class AccountRepositoryImpl implements AccountRepository {
  @override
  Future<void> insertAccount(AccountModel accountModel) async {
    // Placeholder for inserting an account into the database
  }

  @override
  Future<AccountModel?> getAccountByEmail(String email) async {
    // Placeholder for fetching an account by its email
  }

  @override
  Future<void> deleteAccount(String email) async {
    // Placeholder for deleting an account by email
  }
}
