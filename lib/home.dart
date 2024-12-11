import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:sosin_app/transactions.dart';
import 'transaction_database.dart';

enum DisplayMode { sum, percentage }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TransactionDatabase database;
  Map<String, double> categoryData = {};
  DisplayMode _displayMode = DisplayMode.sum;
  final List<Color> chartColors = [
    Color(0xFF6EC1E4),  // Мягкий светло-голубой
    Color(0xFF81C784),  // Мятный
    Color(0xFFFFB74D),  // Теплый оранжевый
    Color(0xFFBA68C8),  // Светлый фиолетовый
    Color(0xFF80CBC4),  // Мятный голубой
    Color(0xFFFF8A65),  // Теплый коралловый
    Color(0xFF90A4AE),  // Светлый серый
    Color(0xFFB39DDB),  // Лаванда
    Color(0xFF4DB6AC),  // Салатовый
    Color(0xFFFFD54F),  // Пастельно-желтый
  ];


  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCategoryData();
  }

  Future<void> _initDatabase() async {
    database = await $FloorUserDatabase.databaseBuilder('transaction_database.db').build();
    _loadCategoryData();
  }

  Future<void> _loadCategoryData() async {
    final transactions = await database.transactionDAO.retrieveTransactions();
    final Map<String, double> data = {};
    for (var transaction in transactions) {
      data[transaction.category] = (data[transaction.category] ?? 0) + transaction.amount;
    }
    setState(() {
      categoryData = data;
    });
  }

  List<PieChartSectionData> _prepareChartData() {
    final totalSum = categoryData.values.fold(0.0, (sum, value) => sum + value);
    int colorIndex = 0;

    return categoryData.entries.map((entry) {
      final percentage = (entry.value / totalSum * 100).toStringAsFixed(1);
      final valueToShow = _displayMode == DisplayMode.sum
          ? entry.value.toStringAsFixed(1)
          : '$percentage%';

      final color = chartColors[colorIndex % chartColors.length];
      colorIndex++;

      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: '${entry.key}: $valueToShow', // Подпись категории
        radius: 100,
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<ProfileScreen>(
                  builder: (context) => ProfileScreen(
                    appBar: AppBar(
                      title: const Text('Профиль'),
                    ),
                    actions: [
                      SignedOutAction((context) {
                        Navigator.of(context).pop();
                      }),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                categoryData.isNotEmpty
                    ? SizedBox(
                  height: 300,
                  child: PieChart(
                    PieChartData(
                      sections: _prepareChartData(),
                      centerSpaceRadius: 50,
                      sectionsSpace: 2,
                    ),
                  ),
                )
                    : const CircularProgressIndicator(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                    ).then((_) {
                      setState(() {
                        _loadCategoryData(); // Перезагрузка данных
                      });
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    textStyle: const TextStyle(fontSize: 14),
                  ),
                  child: const Text('К покупкам'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _displayMode = _displayMode == DisplayMode.sum
                        ? DisplayMode.percentage
                        : DisplayMode.sum;
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: Text(_displayMode == DisplayMode.sum
                    ? '%'
                    : '₽'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
