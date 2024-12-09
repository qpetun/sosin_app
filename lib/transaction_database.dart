import 'dart:async';
import 'package:floor/floor.dart';
import 'dao/transation_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'entity/transaction.dart';


part 'transaction_database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Transaction])
abstract class UserDatabase extends FloorDatabase {
  TransactionDAO get transactionDAO;
}