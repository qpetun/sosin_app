// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $UserDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $UserDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $UserDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<UserDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorUserDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $UserDatabaseBuilderContract databaseBuilder(String name) =>
      _$UserDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $UserDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$UserDatabaseBuilder(null);
}

class _$UserDatabaseBuilder implements $UserDatabaseBuilderContract {
  _$UserDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $UserDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $UserDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<UserDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$UserDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$UserDatabase extends UserDatabase {
  _$UserDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TransactionDAO? _userDAOInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `User` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `age` INTEGER NOT NULL, `country` TEXT NOT NULL, `email` TEXT)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TransactionDAO get transactionDAO {
    return _userDAOInstance ??= _$UserDAO(database, changeListener);
  }
}

class _$UserDAO extends TransactionDAO {
  _$UserDAO(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'User',
            (Transaction item) => <String, Object?>{
                  'id': item.id,
                  'name': item.desc,
                  'age': item.amount,
                  'country': item.category,
                  'email': item.date
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Transaction> _userInsertionAdapter;

  @override
  Future<List<Transaction>> retrieveTransactions() async {
    return _queryAdapter.queryList('SELECT * FROM User',
        mapper: (Map<String, Object?> row) => Transaction(
            id: row['id'] as int?,
            desc: row['name'] as String,
            amount: row['age'] as int,
            category: row['country'] as String,
            date: row['email'] as String?));
  }

  @override
  Future<Transaction?> deleteTransaction(int id) async {
    return _queryAdapter.query('DELETE FROM User WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Transaction(
            id: row['id'] as int?,
            desc: row['name'] as String,
            amount: row['age'] as int,
            category: row['country'] as String,
            date: row['email'] as String?),
        arguments: [id]);
  }

  @override
  Future<List<int>> insertTransaction(List<Transaction> user) {
    return _userInsertionAdapter.insertListAndReturnIds(
        user, OnConflictStrategy.abort);
  }
}
