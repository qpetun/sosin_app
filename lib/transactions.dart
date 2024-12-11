import 'package:flutter/material.dart';
import 'package:sosin_app/transaction_database.dart';
import 'entity/transaction.dart'; // Импорт DAO

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late UserDatabase database;
  final _descController = TextEditingController();
  final _amountController = TextEditingController();

  String? _selectedCategory;
  final List<String> _categories = [
    'Продукты',
    'Одежда',
    'Развлечения',
    'Транспорт',
    'Другое'
  ];

  @override
  void initState() {
    super.initState();
    $FloorUserDatabase.databaseBuilder('transaction_database.db').build().then((value) async {
      database = value;
      setState(() {});
    });
  }

  Future<List<Transaction>> retrieveTransactions() async {
    return await database.transactionDAO.retrieveTransactions();
  }

  Future<void> addUser() async {
    final name = _descController.text;
    final age = int.tryParse(_amountController.text) ?? 0;

    if (name.isNotEmpty && age > 0 && _selectedCategory != null) {
      Transaction newTransaction = Transaction(desc: name, amount: age, category: _selectedCategory!);
      await database.transactionDAO.insertTransaction([newTransaction]);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Покупки"),
      ),
      body: FutureBuilder<List<Transaction>>(
        future: retrieveTransactions(),
        builder: (BuildContext context, AsyncSnapshot<List<Transaction>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: const Icon(Icons.delete_forever),
                  ),
                  key: ValueKey<int>(snapshot.data![index].id!),
                  onDismissed: (DismissDirection direction) async {
                    await database.transactionDAO.deleteTransaction(snapshot.data![index].id!);
                    setState(() {
                      snapshot.data!.remove(snapshot.data![index]);
                    });
                  },
                  child: Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(8.0),
                      title: Text(snapshot.data![index].desc),
                      subtitle: Text('${snapshot.data![index].category} - ${snapshot.data![index].amount} руб.'),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Добавить Покупку"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _descController,
                      decoration: const InputDecoration(labelText: "Название"),
                    ),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(labelText: "Категория"),
                      items: _categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                    TextField(
                      controller: _amountController,
                      decoration: const InputDecoration(labelText: "Сумма"),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      addUser();
                      Navigator.pop(context);
                    },
                    child: const Text("Добавить"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Назад"),
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Добавить покупку',
        child: const Icon(Icons.add),
      ),
    );
  }
}
