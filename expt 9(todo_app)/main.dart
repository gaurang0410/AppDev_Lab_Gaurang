import 'package:flutter/material.dart';
import 'todo_page.dart';
import 'history_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  
  // Keys to trigger refreshes in the other pages
  final GlobalKey<TodoPageState> _todoPageKey = GlobalKey<TodoPageState>();
  final GlobalKey<HistoryPageState> _historyPageKey = GlobalKey<HistoryPageState>();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      TodoPage(key: _todoPageKey, onTaskUpdated: _refreshPages),
      HistoryPage(key: _historyPageKey, onTaskUpdated: _refreshPages),
    ];
  }

  // This function tells both pages to reload their data from the database
  void _refreshPages() {
    _todoPageKey.currentState?.refreshTodoList();
    _historyPageKey.currentState?.refreshHistoryList();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Always refresh the lists when switching tabs to ensure they are up to date
    _refreshPages(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      // THIS IS THE CODE THAT CREATES THE TABS
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Active Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigo,
        onTap: _onItemTapped,
      ),
    );
  }
}