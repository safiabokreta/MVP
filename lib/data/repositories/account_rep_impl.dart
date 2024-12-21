
import 'package:zefeffete/data/datasources/account_ds.dart';
import 'package:zefeffete/data/models/account_model.dart';
import 'package:zefeffete/domain/repositories/account_rep.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountDataSource dataSource;

  // Constructor that requires the AccountDataSource
  AccountRepositoryImpl(this.dataSource);

  @override
  Future<void> insertAccount(AccountModel accountModel) async {
    // Delegate to the AccountDataSource to insert the account
    print("Repository: Inserting account into datasource...");
    await dataSource.insertAccount(accountModel);
    print("Repository: Account inserted into datasource.");
  }
  @override
  Future<void> updateProfileImage(String email, String image) async {
    await dataSource.updateProfileImage(email,image);
  }
  @override
  Future<AccountModel?> getAccountByEmail(String email) async {
    print("Repository: Searching for account with email: $email");

    // Get account from data source
    AccountModel? account = await dataSource.getAccountByEmail(email);

    // Check if account was found and log accordingly
    if (account != null) {
      print("Repository: Account found for email: $email");
    } else {
      print("Repository: No account found for email: $email");
    }

    // Return the found account (could be null if not found)
    return account;
  }
  Future<void> updateUsername(String email, String username) async{
        print("User repo update called" + username);

    await dataSource.updateUsername(email, username);
    
  }

  @override
  Future<void> deleteAccount(String email) async {
    // Delegate to the AccountDataSource to delete an account by email
    await dataSource.deleteAccount(email);
  }

  @override
  Future<AccountModel?> login(String email, String password) async {
    // Get the account by email
    final account = await dataSource.getAccountByEmail(email);
    if (account != null && account.password == password) {
      return account; // If password matches, return the account
    }
    return null; // Return null if no matching account is found or passwords don't match
  }

}
