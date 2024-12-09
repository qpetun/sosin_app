import 'package:floor/floor.dart';
import '../entity/transaction.dart';


@dao
abstract class TransactionDAO {
  @insert
  Future<List<int>> insertTransaction(List<Transaction> transaction);

  @Query('SELECT * FROM Transaction')
  Future<List<Transaction>> retrieveTransactions();

  @Query('DELETE FROM Transaction WHERE id = :id')
  Future<Transaction?> deleteTransaction(int id);
}